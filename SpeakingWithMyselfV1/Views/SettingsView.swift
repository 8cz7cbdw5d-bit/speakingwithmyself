import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var dataStore: DataStore
    @ObservedObject var notificationManager: NotificationManager
    @State private var showingTimePicker = false
    @State private var showingWriteTimePicker = false
    
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
                        Label("Daily Question", systemImage: "bell.fill")
                    }
                    
                    if notificationManager.reminderEnabled {
                        Button(action: { showingTimePicker = true }) {
                            HStack {
                                Label("Question Time", systemImage: "clock")
                                Spacer()
                                Text(notificationManager.reminderTime, style: .time)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .foregroundStyle(.primary)
                    }
                    
                    Toggle(isOn: Binding(
                        get: { notificationManager.writeReminderEnabled },
                        set: { newValue in
                            if newValue {
                                Task { await notificationManager.enableWriteReminder() }
                            } else {
                                notificationManager.disableWriteReminder()
                            }
                        }
                    )) {
                        Label("Time to Write", systemImage: "pencil.circle.fill")
                    }
                    
                    if notificationManager.writeReminderEnabled {
                        Button(action: { showingWriteTimePicker = true }) {
                            HStack {
                                Label("Write Time", systemImage: "clock")
                                Spacer()
                                Text(notificationManager.writeReminderTime, style: .time)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .foregroundStyle(.primary)
                    }
                } header: {
                    Text("Notifications")
                } footer: {
                    Text("Get gentle reminders to reflect. The 'Time to Write' reminder is a second daily nudge to capture your thoughts.")
                }
                
                Section {
                    Toggle(isOn: Binding(
                        get: { dataStore.retainQuestionUntilCompleted },
                        set: { newValue in
                            dataStore.retainQuestionUntilCompleted = newValue
                            dataStore.saveRetainQuestionSetting()
                        }
                    )) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Retain Question Until Completed")
                            Text("When enabled, the same question stays until you answer it")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                } header: {
                    Text("Question Advancement")
                } footer: {
                    Text("By default, questions advance daily. Enable this to keep the same question until you respond.")
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
                    title: "Question Reminder Time",
                    selectedTime: $notificationManager.reminderTime,
                    onSave: {
                        Task { await notificationManager.updateReminderTime(notificationManager.reminderTime) }
                    }
                )
            }
            .sheet(isPresented: $showingWriteTimePicker) {
                TimePickerSheet(
                    title: "Write Reminder Time",
                    selectedTime: $notificationManager.writeReminderTime,
                    onSave: {
                        Task { await notificationManager.updateWriteReminderTime(notificationManager.writeReminderTime) }
                    }
                )
            }
        }
    }
}

struct TimePickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    var title: String
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
            .navigationTitle(title)
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
        .environmentObject(DataStore())
}
