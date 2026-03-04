import SwiftUI

@main
struct SpeakingWithMyselfV1App: App {
    @StateObject private var dataStore = DataStore()
    @StateObject private var notificationManager = NotificationManager()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("hasSeenNotificationUpdate") private var hasSeenNotificationUpdate = false
    @AppStorage("appVersion") private var appVersion = ""
    @State private var showingSplash = true
    @State private var showingNotificationAlert = false
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if hasCompletedOnboarding {
                    ContentView()
                        .environmentObject(dataStore)
                        .environmentObject(notificationManager)
                        .onAppear {
                            checkForUpdates()
                        }
                        .alert("Notifications Enabled", isPresented: $showingNotificationAlert) {
                            Button("OK") {
                                hasSeenNotificationUpdate = true
                            }
                        } message: {
                            Text("Daily reminders are now enabled by default. You can customize notification times or disable them in Settings.")
                        }
                } else {
                    OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                }
                
                if showingSplash {
                    SplashView()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        showingSplash = false
                    }
                }
            }
        }
    }
    
    private func checkForUpdates() {
        let currentVersion = "1.1"
        
        // First time users or users updating from 1.0
        if appVersion.isEmpty || appVersion == "1.0" {
            // Enable notifications by default for new/updating users
            if !notificationManager.reminderEnabled && !hasSeenNotificationUpdate {
                Task {
                    await notificationManager.enableReminder()
                    // Show alert after splash screen
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                        showingNotificationAlert = true
                    }
                }
            }
            appVersion = currentVersion
        }
    }
}

struct SplashView: View {
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            Color.indigo.ignoresSafeArea()
            
            VStack(spacing: 24) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.white.opacity(0.9))
                
                VStack(spacing: 12) {
                    Text("I'm so happy that you're here.")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Thank you for showing up and aiming to grow personally; a little each day.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 32)
            }
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.easeIn(duration: 0.6)) {
                opacity = 1
            }
        }
    }
}
