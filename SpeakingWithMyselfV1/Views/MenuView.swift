import SwiftUI
import UIKit

struct MenuView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var notificationManager: NotificationManager
    @State private var showingAboutApp = false
    @State private var showingAboutMe = false
    @State private var showingContact = false
    @State private var showingSettings = false
    @State private var showingDonateShake = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button(action: { showingAboutApp = true }) {
                        Label("About This App", systemImage: "info.circle")
                    }
                    
                    Button(action: { showingAboutMe = true }) {
                        Label("About Me", systemImage: "person.circle")
                    }
                    
                    Button(action: { showingContact = true }) {
                        Label("Contact / Requests", systemImage: "envelope")
                    }
                    
                    Button(action: { showingSettings = true }) {
                        Label("Settings", systemImage: "gear")
                    }
                }
                
                Section {
                    Button(action: { showingDonateShake = true }) {
                        Label("Donate Bigly", systemImage: "heart.fill")
                            .foregroundStyle(.pink)
                    }
                }
            }
            .navigationTitle("Menu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(isPresented: $showingAboutApp) {
                AboutAppView()
            }
            .sheet(isPresented: $showingAboutMe) {
                AboutMeView()
            }
            .sheet(isPresented: $showingContact) {
                ContactView()
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(notificationManager: notificationManager)
            }
            .fullScreenCover(isPresented: $showingDonateShake) {
                DonateShakeView()
            }
        }
    }
}

struct AboutAppView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingDevTools = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Speaking with Myself")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("The only conversation that matters every day.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Divider()
                    
                    Group {
                        Text("Hi! Thank you for trying out this app.")
                            .fontWeight(.semibold)
                        
                        Text("This is a small passion project, born from years of gathering insights—through reading, therapy, coaching, and quiet reflection—that have genuinely improved my own life. I built it to share those tools with anyone who wants to feel a little better, think a little clearer, or speak to themselves a little more kindly.")
                        
                        Text("At its heart, the app is about reshaping the inner conversation we all have running in the background. Most of us default to a critical or passive voice when life gets hard: \"This is happening to me,\" \"I'm not good enough,\" \"Things will never change.\" Over time, that language becomes the lens through which we experience everything.")
                        
                        Text("This app gently nudges you toward a different lens—one that highlights agency, strengths, small wins, and possibility. It draws from ideas I love: industrial-organizational psychology (how we thrive in work and life), solution-focused coaching (building on what's already working), motivational interviewing (honoring your own reasons for change), and the simple power of positive, active self-talk.")
                        
                        Text("We humans make sense of the world through stories. Some days the story feels heavy, like the world is against us. Other days it feels light, like we're moving with it. This app, and the book I'm writing alongside it, is here to help you author a story that lifts you up more often—one where you're the protagonist with real influence, resilience, and worth.")
                        
                        Text("I won't pretend the shift is instant or effortless. Rewiring decades of habit takes patience and practice. But if you lean into the prompts, reflect honestly (even on the messy days), and notice your small victories, something subtle starts to happen. The words you use about yourself and your life begin to change—and with them, the felt experience of living.")
                        
                        Text("I'm genuinely excited you're here. I'd love to hear how it goes for you—your wins, your struggles, anything you feel like sharing. Thank you for giving it a chance.")
                        
                        Text("Wishing you steady progress and kinder days ahead. God bless.")
                            .fontWeight(.medium)
                            .padding(.top, 8)
                    }
                    .font(.body)
                    
                    Spacer(minLength: 40)
                    
                    Text("Version 1.0")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .onLongPressGesture(minimumDuration: 2.0) {
                            let generator = UIImpactFeedbackGenerator(style: .heavy)
                            generator.impactOccurred()
                            showingDevTools = true
                        }
                }
                .padding()
            }
            .navigationTitle("About This App")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(isPresented: $showingDevTools) {
                DevToolsView()
            }
        }
    }
}

struct AboutMeView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("About the Creator")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Divider()
                    
                    Group {
                        Text("I'm a dad, veteran, and lifelong student of how language shapes our lives. After years in tech (Amazon, Microsoft) and leading disaster response teams with Team Rubicon, I noticed a pattern: the way we talk to ourselves quietly determines what we believe is possible.")
                        
                        Text("This app (and the book behind it) come from that realization. I've spent years testing prompts and frameworks on myself—shifting from self-doubt to agency, from frustration to momentum—and I want to share what actually worked.")
                        
                        Text("My passion is simple: helping people rewrite their inner monologue into something kinder, clearer, and more empowering. If a few minutes of daily reflection can help you feel more capable and less alone, then this project has done its job.")
                        
                        Text("Thanks for being here. Let's grow together.")
                            .fontWeight(.medium)
                            .padding(.top, 8)
                    }
                    .font(.body)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("About Me")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct ContactView: View {
    @Environment(\.dismiss) private var dismiss
    let emailAddress = "citizen.e@gmail.com"
    
    let contactOptions: [(label: String, subject: String, icon: String)] = [
        ("Report a Bug", "BUG:", "ladybug"),
        ("Share Successes", "SUCCESS:", "star.fill"),
        ("Prayer Request", "PRAYER:", "hands.sparkles"),
        ("Request Personal Coaching", "COACHING:", "person.2.fill"),
        ("Business / Corporate Inquiries", "BUSINESS:", "briefcase.fill")
    ]
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(contactOptions, id: \.label) { option in
                        Button(action: { openEmail(subject: option.subject) }) {
                            Label(option.label, systemImage: option.icon)
                        }
                    }
                } footer: {
                    Text("Selecting an option will open your email app with a pre-filled subject line.")
                }
            }
            .navigationTitle("Contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
    
    private func openEmail(subject: String) {
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? subject
        if let url = URL(string: "mailto:\(emailAddress)?subject=\(encodedSubject)") {
            UIApplication.shared.open(url)
        }
    }
}

struct DonateShakeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var shakeOffset: CGFloat = 0
    @State private var showMessage = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9).ignoresSafeArea()
            
            VStack(spacing: 30) {
                if showMessage {
                    VStack(spacing: 20) {
                        Image(systemName: "hand.raised.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.yellow)
                        
                        Text("Please do not do that.")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        Text("There are far better causes than appreciating me.")
                            .font(.body)
                            .foregroundStyle(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button(action: { dismiss() }) {
                            Text("OK, Fair Enough")
                                .font(.headline)
                                .foregroundStyle(.black)
                                .padding()
                                .background(.yellow)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .padding(.top, 20)
                    }
                    .transition(.scale.combined(with: .opacity))
                } else {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(1.5)
                }
            }
            .offset(x: shakeOffset)
        }
        .onAppear {
            performShake()
        }
    }
    
    private func performShake() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        
        withAnimation(.easeInOut(duration: 0.05).repeatCount(10, autoreverses: true)) {
            shakeOffset = 15
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            shakeOffset = 0
            withAnimation(.spring(response: 0.4)) {
                showMessage = true
            }
        }
    }
}

#Preview {
    MenuView()
}
