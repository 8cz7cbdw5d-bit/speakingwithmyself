import SwiftUI

struct TodayView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var responseText: String = ""
    @State private var showingSavedConfirmation = false
    @State private var showingTopicPicker = false
    @State private var showingMenu = false
    @State private var isFirstResponse = false
    @FocusState private var isTextEditorFocused: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if dataStore.simulatedDate != nil {
                        HStack {
                            Image(systemName: "clock.badge.exclamationmark")
                            Text("Time Travel: \(dataStore.effectiveToday, style: .date)")
                        }
                        .font(.caption)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.orange)
                        .clipShape(Capsule())
                    }
                    
                    headerView
                    
                    if dataStore.currentTopic == nil {
                        selectTopicPrompt
                    } else if let prompt = dataStore.currentPrompt {
                        topicAndDayBadge(prompt: prompt)
                        dayProgressIndicator
                        promptCard(prompt: prompt)
                        
                        if prompt.dayNumber > 1 {
                            priorDayReference
                        }
                        
                        if prompt.response != nil && !showingSavedConfirmation {
                            completedReflectionView
                        } else {
                            reflectionInputView
                        }
                    }
                    
                    Spacer(minLength: 40)
                }
            }
            .onAppear {
                loadResponseForToday()
                isFirstResponse = dataStore.answeredPrompts.isEmpty
            }
            .onChange(of: dataStore.currentPrompt?.id) { _, _ in
                loadResponseForToday()
            }
            .overlay {
                if showingSavedConfirmation {
                    savedConfirmationOverlay
                }
            }
            .onTapGesture {
                isTextEditorFocused = false
            }
            .sheet(isPresented: $showingTopicPicker) {
                TopicPickerView()
            }
            .sheet(isPresented: $showingMenu) {
                MenuView()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { showingMenu = true }) {
                        Image(systemName: "line.3.horizontal")
                            .font(.title3)
                    }
                }
            }
        }
    }
    
    private func loadResponseForToday() {
        if let existing = dataStore.currentPrompt?.response {
            responseText = existing
            dataStore.clearDraft()
        } else if !dataStore.draftResponse.isEmpty {
            responseText = dataStore.draftResponse
        } else {
            responseText = ""
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Speaking with Myself")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.indigo)
            
            Text("The only conversation that matters every day.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 20)
    }
    
    private var selectTopicPrompt: some View {
        VStack(spacing: 20) {
            Image(systemName: "sparkles")
                .font(.system(size: 50))
                .foregroundStyle(.indigo)
            
            Text("Choose Your Focus")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Select a topic to explore for the next 7 days. Each day builds on the last, creating momentum.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: { showingTopicPicker = true }) {
                HStack {
                    Image(systemName: "list.bullet")
                    Text("Browse Topics")
                }
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.indigo)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding()
        .padding(.horizontal)
    }
    
    private func topicAndDayBadge(prompt: DailyPrompt) -> some View {
        VStack(spacing: 12) {
            if let topic = dataStore.currentTopic {
                HStack {
                    Image(systemName: topic.icon)
                    Text(topic.name)
                }
                .font(.headline)
                .foregroundStyle(.indigo)
            }
            
            HStack(spacing: 8) {
                Text("Day \(prompt.dayNumber)")
                    .fontWeight(.bold)
                Text("-")
                Text(prompt.dayLabel)
            }
            .font(.caption)
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(.indigo)
            .clipShape(Capsule())
            
            Text(dataStore.effectiveToday, style: .date)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private var dayProgressIndicator: some View {
        HStack(spacing: 6) {
            ForEach(1...7, id: \.self) { day in
                Circle()
                    .fill(day <= dataStore.currentDayInCycle ? Color.indigo : Color.gray.opacity(0.3))
                    .frame(width: 10, height: 10)
            }
        }
        .padding(.vertical, 8)
    }
    
    private func promptCard(prompt: DailyPrompt) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(prompt.question)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.indigo.opacity(0.08))
        )
        .padding(.horizontal)
    }
    
    private var priorDayReference: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your reflection from yesterday")
                .font(.caption)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            
            if let yesterday = dataStore.yesterdaysPrompt {
                VStack(alignment: .leading, spacing: 8) {
                    Text(yesterday.question)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .italic()
                    
                    if let response = yesterday.response {
                        Text(response)
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                    } else {
                        Text("No response recorded")
                            .font(.subheadline)
                            .foregroundStyle(.tertiary)
                            .italic()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.gray.opacity(0.08))
                )
            } else {
                Text("No prior reflection available")
                    .font(.subheadline)
                    .foregroundStyle(.tertiary)
                    .italic()
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.gray.opacity(0.08))
                    )
            }
        }
        .padding(.horizontal)
    }
    
    private var reflectionInputView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your reflection")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            TextEditor(text: $responseText)
                .focused($isTextEditorFocused)
                .frame(minHeight: 150)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.indigo.opacity(0.3), lineWidth: 1)
                )
                .scrollContentBackground(.hidden)
                .onChange(of: responseText) { _, newValue in
                    dataStore.saveDraft(newValue)
                }
            
            Button(action: saveResponse) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Save Reflection")
                }
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.indigo)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(responseText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .opacity(responseText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1)
            
            Button(action: { showingTopicPicker = true }) {
                HStack {
                    Image(systemName: "arrow.triangle.2.circlepath")
                    Text("Switch Topic")
                }
                .font(.subheadline)
                .foregroundStyle(.indigo)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 8)
        }
        .padding(.horizontal)
    }
    
    private var completedReflectionView: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 50))
                .foregroundStyle(.green)
            
            Text("Day \(dataStore.currentDayInCycle) Complete")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(completionMessage)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            if let response = dataStore.currentPrompt?.response {
                VStack(alignment: .leading, spacing: 8) {
                    Text("What you wrote:")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(response)
                        .font(.body)
                        .foregroundStyle(.primary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.gray.opacity(0.1))
                )
            }
            
            if let prompt = dataStore.currentPrompt {
                ShareLink(item: formattedReflection(for: prompt)) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.indigo)
                }
            }
            
            HStack(spacing: 16) {
                Button(action: { 
                    if let existing = dataStore.currentPrompt?.response {
                        responseText = existing
                    }
                    dataStore.clearTodaysResponse()
                }) {
                    Text("Edit")
                        .font(.subheadline)
                        .foregroundStyle(.indigo)
                }
                
                if dataStore.currentDayInCycle < 7 {
                    Button(action: {
                        dataStore.advanceSimulatedDay()
                        responseText = ""
                    }) {
                        Text("Next Day")
                            .font(.subheadline)
                            .foregroundStyle(.green)
                    }
                }
                
                Button(action: { showingTopicPicker = true }) {
                    Text("Switch Topic")
                        .font(.subheadline)
                        .foregroundStyle(.orange)
                }
            }
            .padding(.top, 8)
        }
        .padding()
        .padding(.horizontal)
    }
    
    private var completionMessage: String {
        let day = dataStore.currentDayInCycle
        switch day {
        case 1: return "Great start! Tomorrow we will reflect on what made this meaningful."
        case 2: return "Nice reflection! Tomorrow we will extract the key lessons."
        case 3: return "Powerful insights! Tomorrow we will find a place to apply them."
        case 4: return "Application identified! Tomorrow we will break it into steps."
        case 5: return "Plan in place! Tomorrow we will check on progress."
        case 6: return "Progress tracked! Tomorrow we will integrate and celebrate."
        case 7: return "Week complete! You have built real momentum. Ready for a new topic?"
        default: return "You showed up for yourself today. That matters."
        }
    }
    
    private var savedConfirmationOverlay: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.green)
            
            Text(isFirstResponse ? "Welcome to the journey!" : "Saved!")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(isFirstResponse 
                ? "Your first reflection is in the books. Keep showing up."
                : "Another moment of growth captured.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .transition(.scale.combined(with: .opacity))
    }
    
    private func saveResponse() {
        isFirstResponse = dataStore.answeredPrompts.isEmpty
        dataStore.saveResponse(responseText)
        dataStore.clearDraft()
        isTextEditorFocused = false
        
        withAnimation(.spring(response: 0.3)) {
            showingSavedConfirmation = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                showingSavedConfirmation = false
            }
        }
    }
}

#Preview {
    TodayView()
        .environmentObject(DataStore())
}

extension TodayView {
    private func formattedReflection(for prompt: DailyPrompt) -> String {
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
