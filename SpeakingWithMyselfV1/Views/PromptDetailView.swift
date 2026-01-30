import SwiftUI

struct PromptDetailView: View {
    let prompt: DailyPrompt
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    HStack(spacing: 8) {
                        Text("Day \(prompt.dayNumber)")
                            .fontWeight(.bold)
                        Text("•")
                        Text(prompt.dayLabel)
                    }
                    .font(.caption)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.indigo)
                    .clipShape(Capsule())
                    
                    HStack {
                        Image(systemName: "sparkles")
                        Text(prompt.topic)
                    }
                    .font(.subheadline)
                    .foregroundStyle(.indigo)
                    
                    Text(prompt.date, style: .date)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Prompt")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .textCase(.uppercase)
                        
                        Text(prompt.question)
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.indigo.opacity(0.08))
                    )
                    
                    if let response = prompt.response {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Your Reflection")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .textCase(.uppercase)
                                
                                Spacer()
                                
                                Button(action: {
                                    UIPasteboard.general.string = response
                                }) {
                                    Image(systemName: "doc.on.doc")
                                        .font(.caption)
                                        .foregroundStyle(.indigo)
                                }
                            }
                            
                            Text(response)
                                .font(.body)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.indigo.opacity(0.2), lineWidth: 1)
                        )
                    }
                    
                    if let respondedAt = prompt.respondedAt {
                        Text("Reflected on \(respondedAt, style: .date) at \(respondedAt, style: .time)")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    
                    if prompt.response != nil {
                        ShareLink(item: formattedReflection) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Share Reflection")
                            }
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.indigo)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Reflection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    PromptDetailView(prompt: DailyPrompt(
        question: "What emotion showed up most for you today?",
        topic: "Self-Awareness",
        weekNumber: 1,
        dayNumber: 1,
        dayLabel: "Introduce",
        response: "I felt a lot of gratitude today.",
        respondedAt: Date()
    ))
}

extension PromptDetailView {
    private var formattedReflection: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        
        var text = "Speaking with Myself\n"
        text += "\(dateFormatter.string(from: prompt.date)) • \(prompt.topic) • Day \(prompt.dayNumber) (\(prompt.dayLabel))\n\n"
        text += "Prompt: \(prompt.question)\n\n"
        if let response = prompt.response {
            text += "My Reflection: \(response)"
        }
        return text
    }
}
