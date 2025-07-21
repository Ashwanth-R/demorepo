import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var dietManager: DietPlannerManager
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var age: Int = 25
    @State private var weight: Double = 70.0
    @State private var height: Double = 170.0
    @State private var activityLevel: ActivityLevel = .moderate
    @State private var dietGoal: DietGoal = .maintenance
    @State private var targetWeight: Double = 70.0
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Personal Information") {
                    TextField("Name (Optional)", text: $name)
                        .textFieldStyle(.roundedBorder)
                    
                    HStack {
                        Text("Age")
                        Spacer()
                        Stepper("\(age) years", value: $age, in: 13...100)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Weight: \(weight, specifier: "%.1f") kg")
                            .font(.subheadline)
                        Slider(value: $weight, in: 30...200, step: 0.1)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Height: \(height, specifier: "%.0f") cm")
                            .font(.subheadline)
                        Slider(value: $height, in: 120...220, step: 1)
                    }
                }
                
                Section("Activity Level") {
                    Picker("Activity Level", selection: $activityLevel) {
                        ForEach(ActivityLevel.allCases, id: \.self) { level in
                            VStack(alignment: .leading) {
                                Text(level.rawValue)
                                    .font(.subheadline)
                                Text(level.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .tag(level)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Text("Multiplier: \(activityLevel.multiplier, specifier: "%.2f")x BMR")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Section("Diet Goal") {
                    Picker("Goal", selection: $dietGoal) {
                        ForEach(DietGoal.allCases, id: \.self) { goal in
                            VStack(alignment: .leading) {
                                Text(goal.rawValue)
                                    .font(.subheadline)
                                Text(goal.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .tag(goal)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    if dietGoal != .maintenance {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Target Weight: \(targetWeight, specifier: "%.1f") kg")
                                .font(.subheadline)
                            Slider(value: $targetWeight, in: 30...200, step: 0.1)
                        }
                    }
                }
                
                Section("Calculated Values") {
                    let bmr = calculateBMR()
                    let dailyCalories = calculateDailyCalories(bmr: bmr)
                    
                    HStack {
                        Text("BMR")
                        Spacer()
                        Text("\(Int(bmr)) cal/day")
                            .fontWeight(.medium)
                    }
                    
                    HStack {
                        Text("Daily Calorie Goal")
                        Spacer()
                        Text("\(Int(dailyCalories)) cal/day")
                            .fontWeight(.medium)
                            .foregroundColor(.green)
                    }
                    
                    let bmi = calculateBMI()
                    HStack {
                        Text("BMI")
                        Spacer()
                        Text("\(bmi, specifier: "%.1f")")
                            .fontWeight(.medium)
                            .foregroundColor(bmiColor(bmi))
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveProfile()
                    }
                }
            }
            .onAppear {
                loadCurrentProfile()
            }
        }
    }
    
    private func loadCurrentProfile() {
        let profile = dietManager.userProfile
        name = profile.name
        age = profile.age
        weight = profile.weight
        height = profile.height
        activityLevel = profile.activityLevel
        dietGoal = profile.dietGoal
        targetWeight = profile.targetWeight
    }
    
    private func saveProfile() {
        dietManager.userProfile = UserProfile(
            name: name,
            age: age,
            weight: weight,
            height: height,
            activityLevel: activityLevel,
            dietGoal: dietGoal,
            targetWeight: targetWeight
        )
        dismiss()
    }
    
    private func calculateBMR() -> Double {
        return 10 * weight + 6.25 * height - 5 * Double(age) + 5
    }
    
    private func calculateDailyCalories(bmr: Double) -> Double {
        let bmrWithActivity = bmr * activityLevel.multiplier
        
        switch dietGoal {
        case .weightLoss:
            return bmrWithActivity - 500
        case .weightGain:
            return bmrWithActivity + 500
        case .maintenance:
            return bmrWithActivity
        case .muscleGain:
            return bmrWithActivity + 300
        }
    }
    
    private func calculateBMI() -> Double {
        let heightInMeters = height / 100
        return weight / (heightInMeters * heightInMeters)
    }
    
    private func bmiColor(_ bmi: Double) -> Color {
        switch bmi {
        case ..<18.5:
            return .blue
        case 18.5..<25:
            return .green
        case 25..<30:
            return .orange
        default:
            return .red
        }
    }
}
