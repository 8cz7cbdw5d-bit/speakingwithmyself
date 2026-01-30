import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var selectedPrompt: DailyPrompt?
    
    var body: some View {
        NavigationStack {
            Group {
                if dataStore.answeredPrompts.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "text.book.closed")
                            .font(.system(size: 60))
                            .foregroundStyle(.indigo.opacity(0.5))
                        
                        Text("No reflections yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Your journey begins with today's prompt")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(groupedByTopic, id: \.key) { topic, prompts in
                            Section {
                                ForEach(prompts) { prompt in
                                    HistoryRow(prompt: prompt)
                                        .onTapGesture {
                                            selectedPrompt = prompt
                                        }
                                }
                            } header: {
                                HStack {
                                    if let topicData = DataStore.availableTopics.first(where: { $0.name == topic }) {
                                        Image(systemName: topicData.icon)
                                    } else {
                                        Image(systemName: "folder.fill")
                                    }
                                    Text(topic)
                                }
                                .foregroundStyle(.indigo)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("History")
            .sheet(item: $selectedPrompt) { prompt in
                PromptDetailView(prompt: prompt)
            }
        }
    }
    
    private var groupedByTopic: [(key: String, value: [DailyPrompt])] {
        Dictionary(grouping: dataStore.answeredPrompts) { $0.topic }
            .sorted { $0.key < $1.key }
            .map { (key: $0.key, value: $0.value.sorted { $0.date > $1.date }) }
    }
}

struct HistoryRow: View {
    let prompt: DailyPrompt
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(prompt.date, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("Day \(prompt.dayNumber): \(prompt.dayLabel)")
                    .font(.caption2)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.indigo)
                    .clipShape(Capsule())
            }
            
            Text(prompt.question)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(2)
            
            if let response = prompt.response {
                Text(response)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    HistoryView()
        .environmentObject(DataStore())
}
