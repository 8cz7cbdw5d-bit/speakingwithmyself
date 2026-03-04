import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    @Published var isAuthorized = false
    @Published var reminderEnabled = false
    @Published var reminderTime: Date = defaultReminderTime
    @Published var writeReminderEnabled = false
    @Published var writeReminderTime: Date = defaultWriteReminderTime
    
    private let userDefaults = UserDefaults.standard
    private let reminderEnabledKey = "reminderEnabled"
    private let reminderTimeKey = "reminderTime"
    private let writeReminderEnabledKey = "writeReminderEnabled"
    private let writeReminderTimeKey = "writeReminderTime"
    
    static var defaultReminderTime: Date {
        var components = DateComponents()
        components.hour = 9
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    static var defaultWriteReminderTime: Date {
        var components = DateComponents()
        components.hour = 20
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    init() {
        loadSettings()
        checkAuthorizationStatus()
    }
    
    func loadSettings() {
        reminderEnabled = userDefaults.bool(forKey: reminderEnabledKey)
        if let savedTime = userDefaults.object(forKey: reminderTimeKey) as? Date {
            reminderTime = savedTime
        }
        writeReminderEnabled = userDefaults.bool(forKey: writeReminderEnabledKey)
        if let savedTime = userDefaults.object(forKey: writeReminderTimeKey) as? Date {
            writeReminderTime = savedTime
        }
    }
    
    func saveSettings() {
        userDefaults.set(reminderEnabled, forKey: reminderEnabledKey)
        userDefaults.set(reminderTime, forKey: reminderTimeKey)
        userDefaults.set(writeReminderEnabled, forKey: writeReminderEnabledKey)
        userDefaults.set(writeReminderTime, forKey: writeReminderTimeKey)
    }
    
    func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }
    
    func requestAuthorization() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
            await MainActor.run {
                self.isAuthorized = granted
            }
            return granted
        } catch {
            return false
        }
    }
    
    func enableReminder() async {
        if !isAuthorized {
            let granted = await requestAuthorization()
            if !granted { return }
        }
        
        await MainActor.run {
            reminderEnabled = true
            saveSettings()
        }
        await scheduleReminder()
    }
    
    func disableReminder() {
        reminderEnabled = false
        saveSettings()
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyReflection"])
    }
    
    func enableWriteReminder() async {
        if !isAuthorized {
            let granted = await requestAuthorization()
            if !granted { return }
        }
        
        await MainActor.run {
            writeReminderEnabled = true
            saveSettings()
        }
        await scheduleWriteReminder()
    }
    
    func disableWriteReminder() {
        writeReminderEnabled = false
        saveSettings()
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["writeReminder"])
    }
    
    func updateReminderTime(_ time: Date) async {
        await MainActor.run {
            reminderTime = time
            saveSettings()
        }
        if reminderEnabled {
            await scheduleReminder()
        }
    }
    
    func updateWriteReminderTime(_ time: Date) async {
        await MainActor.run {
            writeReminderTime = time
            saveSettings()
        }
        if writeReminderEnabled {
            await scheduleWriteReminder()
        }
    }
    
    func scheduleReminder() async {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyReflection"])
        
        let content = UNMutableNotificationContent()
        content.title = "Time for Reflection"
        content.body = "A few minutes with yourself can shift your whole day."
        content.sound = .default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: reminderTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: "dailyReflection", content: content, trigger: trigger)
        
        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print("Failed to schedule notification: \(error)")
        }
    }
    
    func scheduleWriteReminder() async {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["writeReminder"])
        
        let content = UNMutableNotificationContent()
        content.title = "Time to Write"
        content.body = "Ready to capture your thoughts?"
        content.sound = .default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: writeReminderTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: "writeReminder", content: content, trigger: trigger)
        
        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print("Failed to schedule write reminder: \(error)")
        }
    }
}
