import SwiftUI

struct InsightsView: View {
    @EnvironmentObject var dataStore: DataStore
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Current topic progress
                    if let topic = dataStore.currentTopic {
                        currentTopicCard(topic: topic)
                    }
                    
                    // Stats overview
                    statsCard
                    
                    // Topics breakdown
                    topicsCard
                    
                    // Streak info
                    streakCard
                    
                    // Future AI summary placeholder
                    aiSummaryPlaceholder
                }
                .padding()
            }
            .navigationTitle("Insights")
        }
    }
    
    private func currentTopicCard(topic: WeeklyTopic) -> some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: topic.icon)
                Text("Current Focus: \(topic.name)")
                    .font(.headline)
                Spacer()
            }
            .foregroundStyle(.indigo)
            
            // 7-day progress
            VStack(alignment: .leading, spacing: 8) {
                Text("7-Day Cycle Progress")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                HStack(spacing: 8) {
                    ForEach(1...7, id: \.self) { day in
                        VStack(spacing: 4) {
                            Circle()
                                .fill(dayCompleted(day) ? Color.green : (day == dataStore.currentDayInCycle ? Color.indigo : Color.gray.opacity(0.3)))
                                .frame(width: 24, height: 24)
                                .overlay {
                                    if dayCompleted(day) {
                                        Image(systemName: "checkmark")
                                            .font(.caption2)
                                            .foregroundStyle(.white)
                                    }
                                }
                            
                            Text(DayCycle.cycle[day-1].label.prefix(3))
                                .font(.system(size: 8))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.indigo.opacity(0.08))
        )
    }
    
    private func dayCompleted(_ day: Int) -> Bool {
        guard let topic = dataStore.currentTopic else { return false }
        return dataStore.prompts.contains { 
            $0.topic == topic.name && $0.dayNumber == day && $0.response != nil 
        }
    }
    
    private var statsCard: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "chart.bar.fill")
                Text("Your Journey")
                    .font(.headline)
                Spacer()
            }
            .foregroundStyle(.indigo)
            
            HStack(spacing: 20) {
                StatBox(value: "\(dataStore.answeredPrompts.count)", label: "Reflections")
                StatBox(value: "\(uniqueTopics.count)", label: "Topics")
                StatBox(value: "\(totalWords)", label: "Words")
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.indigo.opacity(0.2), lineWidth: 1)
        )
    }
    
    private var topicsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "folder.fill")
                Text("Topics Explored")
                    .font(.headline)
                Spacer()
            }
            .foregroundStyle(.indigo)
            
            if uniqueTopics.isEmpty {
                Text("Start reflecting to see your topics here")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(uniqueTopics, id: \.self) { topic in
                    HStack {
                        if let topicData = DataStore.availableTopics.first(where: { $0.name == topic }) {
                            Image(systemName: topicData.icon)
                                .foregroundStyle(.indigo)
                        }
                        Text(topic)
                            .font(.subheadline)
                        Spacer()
                        Text("\(dataStore.promptsForTopic(topic).count) entries")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.indigo.opacity(0.2), lineWidth: 1)
        )
    }
    
    private var streakCard: some View {
        VStack(spacing: 12) {
            Image(systemName: "flame.fill")
                .font(.system(size: 40))
                .foregroundStyle(.orange)
            
            Text("\(currentStreak) Day Streak")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Keep the conversation going!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.orange.opacity(0.1))
        )
    }
    
    private var aiSummaryPlaceholder: some View {
        VStack(spacing: 12) {
            Image(systemName: "sparkles")
                .font(.system(size: 30))
                .foregroundStyle(.purple.opacity(0.5))
            
            Text("AI Insights Coming Soon")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            Text("Future versions will summarize your wins and patterns across topics")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.purple.opacity(0.2), style: StrokeStyle(lineWidth: 1, dash: [5]))
        )
    }
    
    private var uniqueTopics: [String] {
        Array(Set(dataStore.answeredPrompts.map { $0.topic })).sorted()
    }
    
    private var totalWords: Int {
        dataStore.answeredPrompts
            .compactMap { $0.response }
            .flatMap { $0.split(separator: " ") }
            .count
    }
    
    private var currentStreak: Int {
        let calendar = Calendar.current
        var streak = 0
        var checkDate = calendar.startOfDay(for: Date())
        
        while dataStore.prompts.contains(where: { 
            calendar.isDate($0.date, inSameDayAs: checkDate) && $0.response != nil 
        }) {
            streak += 1
            checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate) ?? checkDate
        }
        
        return streak
    }
}

struct StatBox: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.indigo)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    InsightsView()
        .environmentObject(DataStore())
}
