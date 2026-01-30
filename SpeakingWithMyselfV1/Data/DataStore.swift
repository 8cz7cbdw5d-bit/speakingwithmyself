import Foundation
import Combine

class DataStore: ObservableObject {
    @Published var prompts: [DailyPrompt] = []
    @Published var currentPrompt: DailyPrompt?
    @Published var currentTopic: WeeklyTopic?
    @Published var currentWeekStartDate: Date?
    @Published var currentCorePromptIndex: Int = 0
    @Published var simulatedDate: Date? = nil
    @Published var draftResponse: String = ""
    
    private let userDefaults = UserDefaults.standard
    private let promptsKey = "savedPrompts"
    private let currentTopicKey = "currentTopic"
    private let weekStartKey = "weekStartDate"
    private let corePromptIndexKey = "corePromptIndex"
    private let simulatedDateKey = "simulatedDate"
    private let draftResponseKey = "draftResponse"
    
    var effectiveToday: Date {
        let calendar = Calendar.current
        if let simulated = simulatedDate {
            return calendar.startOfDay(for: simulated)
        }
        return calendar.startOfDay(for: Date())
    }
    
    static let availableTopics: [WeeklyTopic] = [
        WeeklyTopic(name: "Autonomy", description: "Owning your choices and direction", icon: "arrow.triangle.branch", 
            corePrompts: [
                "What is one task or decision recently where you felt you had real choice in how to approach it? How did that sense of ownership fuel your energy or results?",
                "Think about a moment this week when you got to do something your way. What did you choose, and how did it feel to have that freedom?",
                "Where in your life right now do you feel most in the driver seat? What makes that area feel like yours to shape?",
                "What is something you recently said yes or no to that felt aligned with what you actually wanted? What made that choice feel right?",
                "When did you last push back on how something should be done and try your own approach instead? What happened?"
            ]),
        WeeklyTopic(name: "Competence", description: "Growing your skills and mastery", icon: "chart.line.uptrend.xyaxis",
            corePrompts: [
                "What is one skill you are working on right now that is still in the getting there phase? What tiny improvement have you noticed lately, even if small?",
                "Think of an area where you are stretching yourself that has not fully clicked yet. What is a recent moment where you felt a little more capable than before?",
                "Which part of your role are you actively building mastery in that feels like a work in progress? What subtle signs of growth have shown up recently?",
                "What is something new you are learning that is taking time to land fully? What encouraging hint of momentum have you spotted?",
                "Is there a capability you are developing that is still unfolding? What small win or shift suggests it is starting to take root?"
            ]),
        WeeklyTopic(name: "Relatedness", description: "Connection and belonging", icon: "person.2.fill",
            corePrompts: [
                "Who has felt like a true collaborator lately? What specific interaction made you feel supported or valued?",
                "Think about a conversation recently that left you feeling genuinely understood. What made it land that way?",
                "Who is someone you have connected with lately in a way that felt real, not just transactional? What made it different?",
                "When did you last feel like you truly belonged somewhere? What was happening in that moment?",
                "What is one relationship in your life that has been energizing you lately? What makes it work?"
            ]),
        WeeklyTopic(name: "Growth Mindset", description: "Embracing challenges as opportunities", icon: "leaf.fill",
            corePrompts: [
                "What is one aspect of your work you have chosen to level up that has not completely clicked yet? What small indicators suggest your efforts are paying off?",
                "Think about something that used to feel hard but is getting easier. What changed in how you approach it?",
                "Where have you been putting in effort lately without seeing big results yet? What keeps you going?",
                "What is a mistake or setback recently that taught you something you would not have learned otherwise?",
                "What is something you are not good at yet but feel curious about getting better at? What draws you to it?"
            ]),
        WeeklyTopic(name: "Strengths", description: "Building on what makes you strong", icon: "star.fill",
            corePrompts: [
                "What is one strength you brought to a recent challenge that felt energizing to use? How did others respond to it?",
                "When have you been in your element lately, doing something that comes naturally to you? What was that like?",
                "What do people tend to come to you for? How does it feel when you get to use that ability?",
                "Think about a time recently when you were firing on all cylinders. What strengths were you leaning into?",
                "What is something you do well that you might be undervaluing? How might you use it more intentionally?"
            ]),
        WeeklyTopic(name: "Resilience", description: "Finding your inner strength", icon: "arrow.counterclockwise",
            corePrompts: [
                "Think about a moment when you found that inner strength and peace in the face of a challenge. How did you show it? What did it feel like?",
                "When did you last surprise yourself with how well you handled something difficult? What did you tap into?",
                "What is a time recently when you stayed calm or centered when you easily could have lost it? What helped you hold steady?",
                "Think about a challenge you navigated with grace. What inner resources did you draw on that you are proud of?",
                "When have you bounced back from something faster or stronger than you expected? What made that possible?"
            ]),
        WeeklyTopic(name: "Purpose", description: "Connecting to what matters most", icon: "compass.drawing",
            corePrompts: [
                "When did you last feel that your work or actions were connected to something larger than yourself? What made that moment meaningful?",
                "What is something you do that feels like it actually matters, beyond just getting it done?",
                "Think about a recent moment when you felt aligned with your values. What were you doing?",
                "What is one thing you contribute that you believe makes a real difference, even if it is not always visible?",
                "When do you feel most like you are living on purpose, not just going through the motions?"
            ]),
        WeeklyTopic(name: "Gratitude", description: "Recognizing the good around you", icon: "heart.fill",
            corePrompts: [
                "What is something in your life right now that you might be taking for granted? How would you feel if it were suddenly gone?",
                "Who is someone you have not thanked lately but probably should? What have they done for you?",
                "What is a small thing that happened recently that made your day a little better?",
                "Think about something that is going well right now. What had to go right for that to happen?",
                "What is one thing about today that you would want to remember if you looked back a year from now?"
            ]),
        WeeklyTopic(name: "Focus", description: "Directing your attention with intention", icon: "scope",
            corePrompts: [
                "When do you feel most focused and present? What conditions or choices help you get into that state?",
                "What is something that tends to pull your attention away from what matters? How have you been managing it?",
                "Think about a time recently when you were fully absorbed in what you were doing. What made that possible?",
                "What is one thing you could let go of or say no to that would free up mental space for what matters more?",
                "When you are at your sharpest, what does your environment look like? What rituals or habits support that?"
            ]),
        WeeklyTopic(name: "Creativity", description: "Unlocking new possibilities", icon: "lightbulb.fill",
            corePrompts: [
                "When did you last approach a problem in an unexpected way? What sparked that creative thinking?",
                "What is something you have been doing the same way for a while that might benefit from a fresh take?",
                "Think about an idea you had recently that surprised you. Where did it come from?",
                "When do you feel most creative? What conditions or mindsets tend to unlock that for you?",
                "What is a constraint or limitation you are working within that has actually pushed you to think differently?"
            ])
    ]
    
    init() {
        loadPrompts()
        loadCurrentTopic()
        loadSimulatedDate()
        loadDraft()
        setupTodaysPrompt()
    }
    
    func loadPrompts() {
        if let data = userDefaults.data(forKey: promptsKey),
           let decoded = try? JSONDecoder().decode([DailyPrompt].self, from: data) {
            prompts = decoded.sorted { $0.date > $1.date }
        }
    }
    
    func savePrompts() {
        if let encoded = try? JSONEncoder().encode(prompts) {
            userDefaults.set(encoded, forKey: promptsKey)
        }
    }
    
    func loadCurrentTopic() {
        if let data = userDefaults.data(forKey: currentTopicKey),
           let decoded = try? JSONDecoder().decode(WeeklyTopic.self, from: data) {
            currentTopic = decoded
        }
        if let date = userDefaults.object(forKey: weekStartKey) as? Date {
            currentWeekStartDate = date
        }
        currentCorePromptIndex = userDefaults.integer(forKey: corePromptIndexKey)
    }
    
    func loadSimulatedDate() {
        if let date = userDefaults.object(forKey: simulatedDateKey) as? Date {
            simulatedDate = date
        }
    }
    
    func saveCurrentTopic() {
        if let topic = currentTopic, let encoded = try? JSONEncoder().encode(topic) {
            userDefaults.set(encoded, forKey: currentTopicKey)
        }
        if let date = currentWeekStartDate {
            userDefaults.set(date, forKey: weekStartKey)
        }
        userDefaults.set(currentCorePromptIndex, forKey: corePromptIndexKey)
    }
    
    func setSimulatedDate(_ date: Date?) {
        simulatedDate = date
        if let date = date {
            userDefaults.set(date, forKey: simulatedDateKey)
        } else {
            userDefaults.removeObject(forKey: simulatedDateKey)
        }
        setupTodaysPrompt()
    }
    
    func advanceSimulatedDay() {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .day, value: 1, to: effectiveToday)!
        setSimulatedDate(newDate)
    }
    
    func selectTopic(_ topic: WeeklyTopic, promptIndex: Int = 0) {
        currentTopic = topic
        currentWeekStartDate = effectiveToday
        currentCorePromptIndex = promptIndex
        saveCurrentTopic()
        
        let calendar = Calendar.current
        prompts.removeAll { calendar.isDate($0.date, inSameDayAs: effectiveToday) }
        currentPrompt = nil
        savePrompts()
        
        setupTodaysPrompt()
    }
    
    func skipToNewTopic() {
        currentTopic = nil
        currentWeekStartDate = nil
        currentCorePromptIndex = 0
        userDefaults.removeObject(forKey: currentTopicKey)
        userDefaults.removeObject(forKey: weekStartKey)
        userDefaults.removeObject(forKey: corePromptIndexKey)
        currentPrompt = nil
    }
    
    func setupTodaysPrompt() {
        let calendar = Calendar.current
        let today = effectiveToday
        
        if let existing = prompts.first(where: { calendar.isDate($0.date, inSameDayAs: today) }) {
            currentPrompt = existing
            return
        }
        
        guard let topic = currentTopic, let weekStart = currentWeekStartDate else {
            currentPrompt = nil
            return
        }
        
        let daysSinceStart = calendar.dateComponents([.day], from: weekStart, to: today).day ?? 0
        let dayInCycle = (daysSinceStart % 7) + 1
        let weekNumber = (daysSinceStart / 7) + 1
        
        let dayCycle = DayCycle.cycle[dayInCycle - 1]
        
        // Day 1 uses topic corePrompts, Days 2-7 use DayCycle promptOptions
        let question: String
        if dayInCycle == 1 {
            let corePrompt = topic.corePrompts[currentCorePromptIndex % topic.corePrompts.count]
            question = corePrompt
        } else {
            question = dayCycle.prompt(for: topic.name, weekNumber: weekNumber)
        }
        
        let newPrompt = DailyPrompt(
            date: today,
            question: question,
            topic: topic.name,
            weekNumber: weekNumber,
            dayNumber: dayInCycle,
            dayLabel: dayCycle.label
        )
        
        currentPrompt = newPrompt
        prompts.insert(newPrompt, at: 0)
        prompts.sort { $0.date > $1.date }
        savePrompts()
    }
    
    func saveResponse(_ response: String) {
        guard var prompt = currentPrompt else { return }
        prompt.response = response
        prompt.respondedAt = effectiveToday
        currentPrompt = prompt
        
        if let index = prompts.firstIndex(where: { $0.id == prompt.id }) {
            prompts[index] = prompt
        }
        savePrompts()
    }
    
    func clearTodaysResponse() {
        guard var prompt = currentPrompt else { return }
        prompt.response = nil
        prompt.respondedAt = nil
        currentPrompt = prompt
        
        if let index = prompts.firstIndex(where: { $0.id == prompt.id }) {
            prompts[index] = prompt
        }
        savePrompts()
    }
    
    func promptsForTopic(_ topic: String) -> [DailyPrompt] {
        prompts.filter { $0.topic == topic && $0.response != nil }
    }
    
    var answeredPrompts: [DailyPrompt] {
        prompts.filter { $0.response != nil }
    }
    
    var currentDayInCycle: Int {
        guard let weekStart = currentWeekStartDate else { return 1 }
        let calendar = Calendar.current
        let daysSinceStart = calendar.dateComponents([.day], from: weekStart, to: effectiveToday).day ?? 0
        return (daysSinceStart % 7) + 1
    }
    
    var yesterdaysPrompt: DailyPrompt? {
        let calendar = Calendar.current
        let yesterday = calendar.date(byAdding: .day, value: -1, to: effectiveToday)!
        return prompts.first { calendar.isDate($0.date, inSameDayAs: yesterday) }
    }
    
    func loadDraft() {
        draftResponse = userDefaults.string(forKey: draftResponseKey) ?? ""
    }
    
    func saveDraft(_ text: String) {
        draftResponse = text
        userDefaults.set(text, forKey: draftResponseKey)
    }
    
    func clearDraft() {
        draftResponse = ""
        userDefaults.removeObject(forKey: draftResponseKey)
    }
}
