import SwiftUI
import Foundation

@main
struct FoodDietPlannerApp: App {
    @StateObject private var dietPlannerManager = DietPlannerManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dietPlannerManager)
                .frame(minWidth: 1000, minHeight: 700)
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified)
        
        Settings {
            SettingsView()
                .environmentObject(dietPlannerManager)
        }
    }
}
