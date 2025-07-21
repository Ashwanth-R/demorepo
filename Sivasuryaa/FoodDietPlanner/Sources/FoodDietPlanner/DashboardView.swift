import SwiftUI
import Charts

struct DashboardView: View {
    @EnvironmentObject var dietManager: DietPlannerManager
    @State private var showingAddMeal = false
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 20) {
                // Calorie Progress Card
                CalorieProgressCard()
                
                // Macros Breakdown Card
                MacrosBreakdownCard()
                
                // Today's Meals Card
                TodaysMealsCard(showingAddMeal: $showingAddMeal)
                
                // Recommendations Card
                RecommendationsCard()
            }
            .padding()
        }
        .sheet(isPresented: $showingAddMeal) {
            AddMealView()
        }
    }
}

struct CalorieProgressCard: View {
    @EnvironmentObject var dietManager: DietPlannerManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                    .font(.title2)
                Text("Calorie Progress")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            let consumed = dietManager.totalCaloriesToday()
            let goal = dietManager.userProfile.dailyCalorieGoal
            let remaining = goal - consumed
            
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 12)
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .trim(from: 0, to: dietManager.calorieProgress())
                        .stroke(
                            LinearGradient(
                                colors: [.orange, .red],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 12, lineCap: .round)
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 1), value: dietManager.calorieProgress())
                    
                    VStack {
                        Text("\(Int(consumed))")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("/ \(Int(goal))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                VStack(spacing: 4) {
                    Text("Remaining: \(Int(remaining)) cal")
                        .font(.subheadline)
                        .foregroundColor(remaining >= 0 ? .green : .red)
                    
                    Text("\(Int(dietManager.calorieProgress() * 100))% of goal")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.controlBackgroundColor))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct MacrosBreakdownCard: View {
    @EnvironmentObject var dietManager: DietPlannerManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.pie.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                Text("Macros Breakdown")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            let protein = dietManager.totalProteinToday()
            let carbs = dietManager.totalCarbsToday()
            let fat = dietManager.totalFatToday()
            let total = protein + carbs + fat
            
            if total > 0 {
                Chart {
                    SectorMark(
                        angle: .value("Protein", protein),
                        innerRadius: .ratio(0.5),
                        angularInset: 2
                    )
                    .foregroundStyle(.red)
                    .opacity(0.8)
                    
                    SectorMark(
                        angle: .value("Carbs", carbs),
                        innerRadius: .ratio(0.5),
                        angularInset: 2
                    )
                    .foregroundStyle(.orange)
                    .opacity(0.8)
                    
                    SectorMark(
                        angle: .value("Fat", fat),
                        innerRadius: .ratio(0.5),
                        angularInset: 2
                    )
                    .foregroundStyle(.yellow)
                    .opacity(0.8)
                }
                .frame(height: 150)
                
                VStack(spacing: 8) {
                    MacroRow(name: "Protein", value: protein, color: .red, unit: "g")
                    MacroRow(name: "Carbs", value: carbs, color: .orange, unit: "g")
                    MacroRow(name: "Fat", value: fat, color: .yellow, unit: "g")
                }
            } else {
                VStack {
                    Image(systemName: "chart.pie")
                        .font(.system(size: 60))
                        .foregroundColor(.gray.opacity(0.5))
                    Text("No data yet")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                    Text("Add some meals to see your macro breakdown")
                        .foregroundColor(.secondary)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
                .frame(height: 150)
            }
        }
        .padding()
        .background(Color(.controlBackgroundColor))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct MacroRow: View {
    let name: String
    let value: Double
    let color: Color
    let unit: String
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            Text(name)
                .font(.subheadline)
            Spacer()
            Text("\(Int(value))\(unit)")
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

struct TodaysMealsCard: View {
    @EnvironmentObject var dietManager: DietPlannerManager
    @Binding var showingAddMeal: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "fork.knife")
                    .foregroundColor(.green)
                    .font(.title2)
                Text("Today's Meals")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: { showingAddMeal = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.accentColor)
                }
            }
            
            let todaysMeals = dietManager.mealsForToday()
            
            if todaysMeals.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "fork.knife.circle")
                        .font(.system(size: 50))
                        .foregroundColor(.gray.opacity(0.5))
                    Text("No meals logged today")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                    Button("Add your first meal") {
                        showingAddMeal = true
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(todaysMeals) { meal in
                            MealRowView(meal: meal)
                        }
                    }
                }
                .frame(maxHeight: 200)
            }
        }
        .padding()
        .background(Color(.controlBackgroundColor))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct MealRowView: View {
    let meal: Meal
    
    var body: some View {
        HStack {
            Image(systemName: meal.type.icon)
                .foregroundColor(meal.type.color)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(meal.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("\(meal.foodItems.count) items • \(Int(meal.totalCalories)) cal")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(meal.time, style: .time)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.controlBackgroundColor).opacity(0.5))
        .cornerRadius(8)
    }
}

struct RecommendationsCard: View {
    @EnvironmentObject var dietManager: DietPlannerManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                    .font(.title2)
                Text("Recommendations")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            let recommendations = dietManager.getDailyRecommendations()
            
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(Array(recommendations.enumerated()), id: \.offset) { index, recommendation in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.subheadline)
                        
                        Text(recommendation)
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
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
