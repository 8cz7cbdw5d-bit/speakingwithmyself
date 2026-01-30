import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            Color.indigo.ignoresSafeArea()
            
            VStack {
                TabView(selection: $currentPage) {
                    OnboardingPage(
                        icon: "bubble.left.and.bubble.right.fill",
                        title: "Welcome",
                        subtitle: "Speaking with Myself",
                        description: "The only conversation that matters every day.\n\nThis app helps you build a kinder, clearer inner voice through daily reflection."
                    )
                    .tag(0)
                    
                    OnboardingPage(
                        icon: "7.circle.fill",
                        title: "7-Day Momentum",
                        subtitle: "One topic, one week",
                        description: "Pick a focus area—like Autonomy, Strengths, or Growth Mindset.\n\nEach day builds on the last, creating real momentum through guided reflection."
                    )
                    .tag(1)
                    
                    OnboardingPage(
                        icon: "arrow.triangle.2.circlepath",
                        title: "The Daily Rhythm",
                        subtitle: "Open → Deepen → Distill → Imagine → Begin → Notice → Carry",
                        description: "Day 1 opens the topic. Days 2-7 help you deepen, extract insights, imagine applications, and carry them forward.\n\nSmall steps, big shifts."
                    )
                    .tag(2)
                    
                    OnboardingPage(
                        icon: "heart.fill",
                        title: "Show Up for Yourself",
                        subtitle: "A few minutes each day",
                        description: "There's no right or wrong answer. Just honest reflection.\n\nThe goal isn't perfection—it's presence. Let's begin."
                    )
                    .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                VStack(spacing: 20) {
                    HStack(spacing: 8) {
                        ForEach(0..<4) { index in
                            Circle()
                                .fill(index == currentPage ? Color.white : Color.white.opacity(0.4))
                                .frame(width: 8, height: 8)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < 3 {
                            withAnimation { currentPage += 1 }
                        } else {
                            hasCompletedOnboarding = true
                        }
                    }) {
                        Text(currentPage < 3 ? "Next" : "Get Started")
                            .font(.headline)
                            .foregroundStyle(.indigo)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.horizontal, 40)
                    
                    if currentPage < 3 {
                        Button(action: { hasCompletedOnboarding = true }) {
                            Text("Skip")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.7))
                        }
                    }
                }
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage: View {
    let icon: String
    let title: String
    let subtitle: String
    let description: String
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 70))
                .foregroundStyle(.white)
            
            VStack(spacing: 12) {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Text(subtitle)
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.8))
            }
            
            Text(description)
                .font(.body)
                .foregroundStyle(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(hasCompletedOnboarding: .constant(false))
}
