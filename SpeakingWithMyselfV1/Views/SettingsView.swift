import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var notificationManager: NotificationManager
    @State private var showingTimePicker = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle(isOn: Binding(
                        get: { notificationManager.reminderEnabled },
                        set: { newValue in
                            if newValue {
                                Task { await notificationManager.enableReminder() }
                            } else {
                                notificationManager.disableReminder()
                            }
                        }
                    )) {
                        Label("Daily Reminder", systemImage: "bell.fill")
                    }
                    
                    if notificationManager.reminderEnabled {
                        Button(action: { showingTimePicker = true }) {
                            HStack {
                                Label("Reminder Time", systemImage: "clock")
                                Spacer()
                                Text(notificationManager.reminderTime, style: .time)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .foregroundStyle(.primary)
                    }
                } header: {
                    Text("Notifications")
                } footer: {
                    Text("Get a gentle nudge to reflect each day. You can also manage notifications in iOS Settings.")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(isPresented: $showingTimePicker) {
                TimePickerSheet(
                    selectedTime: $notificationManager.reminderTime,
                    onSave: {
                        Task { await notificationManager.updateReminderTime(notificationManager.reminderTime) }
                    }
                )
            }
        }
    }
}

struct TimePickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedTime: Date
    var onSave: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                DatePicker(
                    "Reminder Time",
                    selection: $selectedTime,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                
                Spacer()
            }
            .padding()
            .navigationTitle("Set Reminder Time")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        onSave()
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    SettingsView(notificationManager: NotificationManager())
}
