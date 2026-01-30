import Foundation

struct DailyPrompt: Identifiable, Codable {
    let id: UUID
    let date: Date
    let question: String
    let topic: String
    let weekNumber: Int
    let dayNumber: Int
    let dayLabel: String
    var response: String?
    var respondedAt: Date?
    
    init(id: UUID = UUID(), date: Date = Date(), question: String, topic: String, weekNumber: Int, dayNumber: Int, dayLabel: String, response: String? = nil, respondedAt: Date? = nil) {
        self.id = id
        self.date = date
        self.question = question
        self.topic = topic
        self.weekNumber = weekNumber
        self.dayNumber = dayNumber
        self.dayLabel = dayLabel
        self.response = response
        self.respondedAt = respondedAt
    }
}

struct WeeklyTopic: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let icon: String
    let corePrompts: [String]
    
    init(id: UUID = UUID(), name: String, description: String, icon: String, corePrompts: [String]) {
        self.id = id
        self.name = name
        self.description = description
        self.icon = icon
        self.corePrompts = corePrompts
    }
}

struct DayCycle {
    let dayNumber: Int
    let label: String
    let coreIntent: String
    let promptOptions: [String]
    
    // Select prompt based on week number for variety without randomness
    func prompt(for topic: String, weekNumber: Int) -> String {
        let index = (weekNumber - 1) % promptOptions.count
        return promptOptions[index].replacingOccurrences(of: "{topic}", with: topic.lowercased())
    }
    
    static let cycle: [DayCycle] = [
        DayCycle(
            dayNumber: 1,
            label: "Open",
            coreIntent: "Invite the topic in without forcing structure",
            promptOptions: ["{corePrompt}"]  // Day 1 uses topic corePrompts
        ),
        DayCycle(
            dayNumber: 2,
            label: "Deepen",
            coreIntent: "Explore resonance and emotion",
            promptOptions: [
                "Reading what you wrote yesterday—what part surprises you, touches you, or feels most alive?",
                "What emotion shows up as you reread your words about {topic}? Where do you feel it in your body?",
                "If you could respond to yesterday's you with compassion, what would you say?",
                "What question do you now have about {topic} that you did not have before?"
            ]
        ),
        DayCycle(
            dayNumber: 3,
            label: "Distill",
            coreIntent: "Pull out insight in a way that feels personal",
            promptOptions: [
                "What advice would you give a close friend experiencing the same thing with {topic}?",
                "If this week had a headline so far, what would it be?",
                "What is one belief or assumption about {topic} that is starting to shift—even slightly?",
                "Write a short letter from future-you who has fully embodied this {topic} insight."
            ]
        ),
        DayCycle(
            dayNumber: 4,
            label: "Imagine",
            coreIntent: "Bridge to action through vision",
            promptOptions: [
                "Picture a moment this week where {topic} feels strong in you—what is happening? Who is there? How do you feel?",
                "Where in your real life this week do you most want {topic} to show up?",
                "What would it look like if {topic} got just 10% more space in your day-to-day?"
            ]
        ),
        DayCycle(
            dayNumber: 5,
            label: "Begin",
            coreIntent: "Lower the bar to action",
            promptOptions: [
                "What is the tiniest experiment you could run today that would make {topic} feel real?",
                "If you were going to act on this in the next 24 hours, what would feel almost too easy?",
                "What is one small way you could remind yourself of {topic} today—a note, alarm, or object?"
            ]
        ),
        DayCycle(
            dayNumber: 6,
            label: "Notice",
            coreIntent: "Track subtle shifts",
            promptOptions: [
                "What has happened (or not happened) since you set that tiny intention?",
                "What is one small sign—internal or external—that something is moving with {topic}?",
                "How are you relating to {topic} differently this week, even if nothing big has changed?"
            ]
        ),
        DayCycle(
            dayNumber: 7,
            label: "Carry",
            coreIntent: "Integrate and release",
            promptOptions: [
                "What is staying with you from this whole week of {topic}?",
                "How has your inner voice about {topic} changed since Day 1?",
                "Write one sentence you want to keep about {topic}—something you could return to anytime.",
                "If this cycle were a gift to future-you, what did it give?"
            ]
        )
    ]
}
