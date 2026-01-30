import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataStore: DataStore
    
    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "sun.max.fill")
                }
            
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
            
            InsightsView()
                .tabItem {
                    Label("Insights", systemImage: "chart.line.uptrend.xyaxis")
                }
        }
        .tint(.indigo)
    }
}

#Preview {
    ContentView()
        .environmentObject(DataStore())
}
