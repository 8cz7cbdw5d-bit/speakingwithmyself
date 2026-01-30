import SwiftUI

struct TopicPickerView: View {
    @EnvironmentObject var dataStore: DataStore
    @Environment(\.dismiss) private var dismiss
    @State private var expandedTopic: UUID?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Each topic runs for 7 days. Tap a topic to see available starting prompts.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    LazyVStack(spacing: 12) {
                        ForEach(DataStore.availableTopics) { topic in
                            TopicExpandableCard(
                                topic: topic, 
                                isExpanded: expandedTopic == topic.id,
                                isCurrentTopic: dataStore.currentTopic?.id == topic.id,
                                onToggle: { 
                                    withAnimation(.spring(response: 0.3)) {
                                        expandedTopic = expandedTopic == topic.id ? nil : topic.id
                                    }
                                },
                                onSelectPrompt: { index in
                                    dataStore.selectTopic(topic, promptIndex: index)
                                    dismiss()
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Choose a Topic")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct TopicExpandableCard: View {
    let topic: WeeklyTopic
    let isExpanded: Bool
    let isCurrentTopic: Bool
    let onToggle: () -> Void
    let onSelectPrompt: (Int) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Button(action: onToggle) {
                HStack(spacing: 16) {
                    Image(systemName: topic.icon)
                        .font(.title2)
                        .foregroundStyle(.indigo)
                        .frame(width: 44, height: 44)
                        .background(.indigo.opacity(0.1))
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(topic.name)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            
                            if isCurrentTopic {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            }
                        }
                        
                        Text(topic.description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundStyle(.tertiary)
                }
                .padding()
            }
            .buttonStyle(.plain)
            
            // Expanded prompts
            if isExpanded {
                Divider()
                    .padding(.horizontal)
                
                VStack(spacing: 8) {
                    Text("Choose a starting prompt:")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    ForEach(Array(topic.corePrompts.enumerated()), id: \.offset) { index, prompt in
                        Button(action: { onSelectPrompt(index) }) {
                            HStack(alignment: .top, spacing: 12) {
                                Text("\(index + 1)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .frame(width: 24, height: 24)
                                    .background(.indigo)
                                    .clipShape(Circle())
                                
                                Text(prompt)
                                    .font(.subheadline)
                                    .foregroundStyle(.primary)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.gray.opacity(0.05))
                            )
                            .padding(.horizontal, 8)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.bottom, 12)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isCurrentTopic ? .indigo.opacity(0.1) : .gray.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isCurrentTopic ? .indigo : .clear, lineWidth: 2)
        )
    }
}

#Preview {
    TopicPickerView()
        .environmentObject(DataStore())
}
