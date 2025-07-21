import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var dietManager: DietPlannerManager
    @State private var showingResetConfirmation = false
    @State private var showingExportData = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Data Management") {
                    Button("Export Data") {
                        showingExportData = true
                    }
                    .foregroundColor(.blue)
                    
                    Button("Reset All Data") {
                        showingResetConfirmation = true
                    }
                    .foregroundColor(.red)
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Build")
                        Spacer()
                        Text("2024.1")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Support") {
                    Link("Privacy Policy", destination: URL(string: "https://example.com/privacy")!)
                        .foregroundColor(.blue)
                    
                    Link("Terms of Service", destination: URL(string: "https://example.com/terms")!)
                        .foregroundColor(.blue)
                    
                    Link("Contact Support", destination: URL(string: "mailto:support@example.com")!)
                        .foregroundColor(.blue)
                }
            }
            .navigationTitle("Settings")
            .alert("Reset All Data", isPresented: $showingResetConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    resetAllData()
                }
            } message: {
                Text("This will permanently delete all your meals, profile data, and settings. This action cannot be undone.")
            }
            .sheet(isPresented: $showingExportData) {
                ExportDataView()
            }
        }
    }
    
    private func resetAllData() {
        dietManager.meals.removeAll()
        dietManager.userProfile = UserProfile()
        
        // Clear UserDefaults
        UserDefaults.standard.removeObject(forKey: "DietPlannerData_profile")
        UserDefaults.standard.removeObject(forKey: "DietPlannerData_meals")
    }
}

struct ExportDataView: View {
    @EnvironmentObject var dietManager: DietPlannerManager
    @Environment(\.dismiss) var dismiss
    @State private var exportText = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Export Your Data")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Your data has been formatted for export. You can copy this text and save it to a file.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                ScrollView {
                    Text(exportText)
                        .font(.system(.caption, design: .monospaced))
                        .textSelection(.enabled)
                        .padding()
                        .background(Color(.controlBackgroundColor))
                        .cornerRadius(8)
                }
                
                HStack {
                    Button("Copy to Clipboard") {
                        #if os(macOS)
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(exportText, forType: .string)
                        #endif
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Spacer()
                    
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .padding()
            .onAppear {
                generateExportData()
            }
            .navigationTitle("Export Data")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func generateExportData() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let profileData = try encoder.encode(dietManager.userProfile)
            let mealsData = try encoder.encode(dietManager.meals)
            
            let profileString = String(data: profileData, encoding: .utf8) ?? ""
            let mealsString = String(data: mealsData, encoding: .utf8) ?? ""
            
            exportText = """
            Food Diet Planner - Data Export
            Generated: \(Date().formatted())
            
            === USER PROFILE ===
            \(profileString)
            
            === MEALS DATA ===
            \(mealsString)
            """
        } catch {
            exportText = "Error generating export data: \(error.localizedDescription)"
        }
    }
}
