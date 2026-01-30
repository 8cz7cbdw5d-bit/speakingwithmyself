import SwiftUI

@main
struct SpeakingWithMyselfV1App: App {
    @StateObject private var dataStore = DataStore()
    @StateObject private var notificationManager = NotificationManager()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var showingSplash = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if hasCompletedOnboarding {
                    ContentView()
                        .environmentObject(dataStore)
                        .environmentObject(notificationManager)
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
