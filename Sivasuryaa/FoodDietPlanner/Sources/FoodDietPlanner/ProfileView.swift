import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var dietManager: DietPlannerManager
    @State private var showingEditProfile = false
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 20) {
                // Basic Info Card
                BasicInfoCard(showingEditProfile: $showingEditProfile)
                
                // Goals Card
                GoalsCard()
                
                // BMR & Calories Card
                BMRCaloriesCard()
                
                // Activity Level Card
                ActivityLevelCard()
                
                // Progress Card
                ProgressCard()
                
                // Health Metrics Card
                HealthMetricsCard()
            }
            .padding()
        }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView()
        }
    }
}

struct BasicInfoCard: View {
    @EnvironmentObject var dietManager: DietPlannerManager
    @Binding var showingEditProfile: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "person.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                Text("Profile")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Button("Edit") {
                    showingEditProfile = true
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                if !dietManager.userProfile.name.isEmpty {
                    ProfileRow(label: "Name", value: dietManager.userProfile.name)
                }
                ProfileRow(label: "Age", value: "\(dietManager.userProfile.age) years")
                ProfileRow(label: "Weight", value: String(format: "%.1f kg", dietManager.userProfile.weight))
                ProfileRow(label: "Height", value: String(format: "%.0f cm", dietManager.userProfile.height))
            }
        }
        .padding()
        .background(Color(.controlBackgroundColor))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct GoalsCard: View {
    @EnvironmentObject var dietManager: DietPlannerManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "target")
                    .font(.title2)
                    .foregroundColor(dietManager.userProfile.dietGoal.color)
                Text("Goals")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text(dietManager.userProfile.dietGoal.rawValue)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(dietManager.userProfile.dietGoal.color)
                
                Text(dietManager.userProfile.dietGoal.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                
                if dietManager.userProfile.dietGoal != .maintenance {
                    ProfileRow(
                        label: "Target Weight",
                        value: String(format: "%.1f kg", dietManager.userProfile.targetWeight)
                    )
                }
            }
        }
        .padding()
        .background(Color(.controlBackgroundColor))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct BMRCaloriesCard: View {
    @EnvironmentObject var dietManager: DietPlannerManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "flame.fill")
                    .font(.title2)
                    .foregroundColor(.orange)
                Text("Metabolism")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("BMR (Basal Metabolic Rate)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(Int(dietManager.userProfile.bmr)) cal/day")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Daily Calorie Goal")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(Int(dietManager.userProfile.dailyCalorieGoal)) cal/day")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(Color(.controlBackgroundColor))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct ActivityLevelCard: View {
    @EnvironmentObject var dietManager: DietPlannerManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "figure.run")
                    .font(.title2)
                    .foregroundColor(.green)
                Text("Activity Level")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(dietManager.userProfile.activityLevel.rawValue)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                
                Text(dietManager.userProfile.activityLevel.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                
                Text("Multiplier: \(dietManager.userProfile.activityLevel.multiplier, specifier: "%.2f")x")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.controlBackgroundColor))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct ProgressCard: View {
    @EnvironmentObject var dietManager: DietPlannerManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.title2)
                    .foregroundColor(.blue)
                Text("Today's Progress")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            let consumed = dietManager.totalCaloriesToday()
            let goal = dietManager.userProfile.dailyCalorieGoal
            let remaining = goal - consumed
            
            VStack(alignment: .leading, spacing: 12) {
                ProgressRow(
                    label: "Calories",
                    current: consumed,
                    goal: goal,
                    unit: "cal",
                    color: .orange
                )
                
                ProgressRow(
                    label: "Protein",
                    current: dietManager.totalProteinToday(),
                    goal: dietManager.userProfile.weight * 1.6,
                    unit: "g",
                    color: .red
                )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Remaining Today")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(Int(max(0, remaining))) cal")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(remaining >= 0 ? .green : .red)
                }
            }
        }
        .padding()
        .background(Color(.controlBackgroundColor))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct HealthMetricsCard: View {
    @EnvironmentObject var dietManager: DietPlannerManager
    
    private var bmi: Double {
        let heightInMeters = dietManager.userProfile.height / 100
        return dietManager.userProfile.weight / (heightInMeters * heightInMeters)
    }
    
    private var bmiCategory: String {
        switch bmi {
        case ..<18.5:
            return "Underweight"
        case 18.5..<25:
            return "Normal"
        case 25..<30:
            return "Overweight"
        default:
            return "Obese"
        }
    }
    
    private var bmiColor: Color {
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "heart.fill")
                    .font(.title2)
                    .foregroundColor(.red)
                Text("Health Metrics")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("BMI (Body Mass Index)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    HStack {
                        Text("\(bmi, specifier: "%.1f")")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(bmiColor)
                        Text("(\(bmiCategory))")
                            .font(.subheadline)
                            .foregroundColor(bmiColor)
                    }
                }
                
                if dietManager.userProfile.dietGoal != .maintenance {
                    let weightDifference = dietManager.userProfile.targetWeight - dietManager.userProfile.weight
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Weight Goal Progress")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(weightDifference >= 0 ? "+" : "")\(weightDifference, specifier: "%.1f") kg to goal")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(weightDifference == 0 ? .green : .blue)
                    }
                }
            }
        }
        .padding()
        .background(Color(.controlBackgroundColor))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct ProfileRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

struct ProgressRow: View {
    let label: String
    let current: Double
    let goal: Double
    let unit: String
    let color: Color
    
    private var progress: Double {
        min(current / goal, 1.0)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(Int(current))/\(Int(goal)) \(unit)")
                    .font(.caption)
                    .fontWeight(.medium)
            }
            
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: color))
        }
    }
}
