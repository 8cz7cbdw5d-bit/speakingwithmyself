import SwiftUI

struct DevToolsView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var showingTopicPicker = false
    @State private var showingDatePicker = false
    
    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    if dataStore.simulatedDate != nil {
                        HStack {
                            Image(systemName: "clock.badge.exclamationmark")
                                .foregroundStyle(.orange)
                            Text("TIME TRAVEL ACTIVE")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.orange)
                        }
                    }
                    
                    HStack {
                        Text("Effective Date")
                        Spacer()
                        Text(dateFormatter.string(from: dataStore.effectiveToday))
                            .foregroundStyle(dataStore.simulatedDate != nil ? .orange : .secondary)
                    }
                    
                    Button(action: { showingDatePicker = true }) {
                        HStack {
                            Image(systemName: "calendar")
                            Text("Set Simulated Date")
                        }
                    }
                    
                    Button(action: { dataStore.advanceSimulatedDay() }) {
                        HStack {
                            Image(systemName: "forward.fill")
                            Text("Advance to Next Day")
                        }
                    }
                    .disabled(dataStore.currentTopic == nil)
                    
                    if dataStore.simulatedDate != nil {
                        Button(role: .destructive, action: { dataStore.setSimulatedDate(nil) }) {
                            HStack {
                                Image(systemName: "clock.arrow.circlepath")
                                Text("Reset to Real Date")
                            }
                        }
                    }
                } header: {
                    Text("Time Travel")
                } footer: {
                    Text("Step through days to test the full 7-day cycle with your real responses.")
                }
                
                Section("Current State") {
                    if let topic = dataStore.currentTopic {
                        HStack {
                            Text("Topic")
                            Spacer()
                            Text(topic.name)
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        Text("No topic selected")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Day in Cycle")
                        Spacer()
                        Text("\(dataStore.currentDayInCycle) of 7")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Answered")
                        Spacer()
                        Text("\(dataStore.answeredPrompts.count)")
                            .foregroundStyle(.secondary)
                    }
                }
                
                Section("Topic") {
                    Button(action: { showingTopicPicker = true }) {
                        HStack {
                            Image(systemName: "arrow.triangle.2.circlepath")
                            Text("Change Topic")
                        }
                    }
                    
                    Button(role: .destructive, action: { dataStore.skipToNewTopic() }) {
                        HStack {
                            Image(systemName: "xmark.circle")
                            Text("Clear Topic")
                        }
                    }
                }
                
                Section("Data") {
                    Button(action: { dataStore.clearTodaysResponse() }) {
                        HStack {
                            Image(systemName: "eraser")
                            Text("Clear Today Response")
                        }
                    }
                    
                    Button(role: .destructive, action: clearAllData) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Clear ALL Data")
                        }
                    }
                }
                
                Section("7-Day Cycle Preview") {
                    if let topic = dataStore.currentTopic {
                        ForEach(0..<7, id: \.self) { index in
                            let day = index + 1
                            let cycle = DayCycle.cycle[index]
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("Day \(day): \(cycle.label)")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundStyle(day == dataStore.currentDayInCycle ? .white : .indigo)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 2)
                                        .background(day == dataStore.currentDayInCycle ? Color.indigo : Color.clear)
                                        .clipShape(Capsule())
                                    Spacer()
                                }
                                
                                Text(cycle.coreIntent)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                    .italic()
                                
                                if day == 1 {
                                    Text(topic.corePrompts[dataStore.currentCorePromptIndex % topic.corePrompts.count])
                                        .font(.caption2)
                                        .foregroundStyle(.primary)
                                        .lineLimit(2)
                                } else {
                                    Text(cycle.prompt(for: topic.name, weekNumber: 1))
                                        .font(.caption2)
                                        .foregroundStyle(.primary)
                                        .lineLimit(2)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    } else {
                        Text("Select a topic to preview")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Dev Tools")
            .sheet(isPresented: $showingTopicPicker) {
                TopicPickerView()
            }
            .sheet(isPresented: $showingDatePicker) {
                DatePickerSheet(selectedDate: dataStore.simulatedDate ?? Date()) { date in
                    dataStore.setSimulatedDate(date)
                }
            }
        }
    }
    
    private func clearAllData() {
        dataStore.prompts.removeAll()
        dataStore.currentPrompt = nil
        dataStore.currentTopic = nil
        dataStore.currentWeekStartDate = nil
        dataStore.currentCorePromptIndex = 0
        dataStore.simulatedDate = nil
        dataStore.savePrompts()
        UserDefaults.standard.removeObject(forKey: "currentTopic")
        UserDefaults.standard.removeObject(forKey: "weekStartDate")
        UserDefaults.standard.removeObject(forKey: "corePromptIndex")
        UserDefaults.standard.removeObject(forKey: "simulatedDate")
    }
}

struct DatePickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State var selectedDate: Date
    let onSelect: (Date) -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding()
                Spacer()
            }
            .navigationTitle("Set Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Set") {
                        onSelect(selectedDate)
                        dismiss()
                    }
                    .fontWeight(.bold)
                }
            }
        }
    }
}

#Preview {
    DevToolsView()
        .environmentObject(DataStore())
}
