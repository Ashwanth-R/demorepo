import SwiftUI
import Charts

struct ContentView: View {
    @EnvironmentObject var dietManager: DietPlannerManager
    @State private var selectedTab: TabSelection = .dashboard
    
    enum TabSelection {
        case dashboard, meals, foods, profile, analytics
    }
    
    var body: some View {
        NavigationSplitView {
            SidebarView(selectedTab: $selectedTab)
                .navigationSplitViewColumnWidth(min: 200, ideal: 250, max: 300)
        } detail: {
            Group {
                switch selectedTab {
                case .dashboard:
                    DashboardView()
                case .meals:
                    MealsView()
                case .foods:
                    FoodDatabaseView()
                case .profile:
                    ProfileView()
                case .analytics:
                    AnalyticsView()
                }
            }
            .navigationTitle(selectedTab.title)
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationSplitViewStyle(.prominentDetail)
    }
}

extension ContentView.TabSelection {
    var title: String {
        switch self {
        case .dashboard: return "Dashboard"
        case .meals: return "Meals"
        case .foods: return "Food Database"
        case .profile: return "Profile"
        case .analytics: return "Analytics"
        }
    }
    
    var icon: String {
        switch self {
        case .dashboard: return "house.fill"
        case .meals: return "fork.knife"
        case .foods: return "list.bullet"
        case .profile: return "person.fill"
        case .analytics: return "chart.bar.fill"
        }
    }
}

struct SidebarView: View {
    @Binding var selectedTab: ContentView.TabSelection
    @EnvironmentObject var dietManager: DietPlannerManager
    
    var body: some View {
        List(selection: $selectedTab) {
            Section("Navigation") {
                NavigationLink(value: ContentView.TabSelection.dashboard) {
                    Label("Dashboard", systemImage: "house.fill")
                }
                
                NavigationLink(value: ContentView.TabSelection.meals) {
                    Label("Meals", systemImage: "fork.knife")
                }
                
                NavigationLink(value: ContentView.TabSelection.foods) {
                    Label("Food Database", systemImage: "list.bullet")
                }
                
                NavigationLink(value: ContentView.TabSelection.analytics) {
                    Label("Analytics", systemImage: "chart.bar.fill")
                }
                
                NavigationLink(value: ContentView.TabSelection.profile) {
                    Label("Profile", systemImage: "person.fill")
                }
            }
            
            Section("Quick Stats") {
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("Today's Calories")
                    Spacer()
                    Text("\(Int(dietManager.totalCaloriesToday()))")
                        .fontWeight(.semibold)
                }
                .font(.caption)
                
                HStack {
                    Image(systemName: "target")
                        .foregroundColor(.blue)
                    Text("Goal")
                    Spacer()
                    Text("\(Int(dietManager.userProfile.dailyCalorieGoal))")
                        .fontWeight(.semibold)
                }
                .font(.caption)
                
                ProgressView(value: dietManager.calorieProgress())
                    .progressViewStyle(LinearProgressViewStyle(tint: .green))
            }
        }
        .navigationTitle("Diet Planner")
        .listStyle(.sidebar)
    }
}
