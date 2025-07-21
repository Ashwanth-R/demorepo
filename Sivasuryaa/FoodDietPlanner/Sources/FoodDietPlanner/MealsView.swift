import SwiftUI

struct MealsView: View {
    @EnvironmentObject var dietManager: DietPlannerManager
    @State private var showingAddMeal = false
    @State private var selectedMeal: Meal?
    @State private var showingMealDetail = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Date Picker Header
            DatePickerHeader()
            
            // Meals List
            if mealsForSelectedDate.isEmpty {
                EmptyMealsView(showingAddMeal: $showingAddMeal)
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(groupedMeals, id: \.key) { mealType, meals in
                            MealTypeSection(
                                mealType: mealType,
                                meals: meals,
                                onMealTap: { meal in
                                    selectedMeal = meal
                                    showingMealDetail = true
                                }
                            )
                        }
                    }
                    .padding()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Add Meal") {
                    showingAddMeal = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .sheet(isPresented: $showingAddMeal) {
            AddMealView()
        }
        .sheet(isPresented: $showingMealDetail) {
            if let meal = selectedMeal {
                MealDetailView(meal: meal)
            }
        }
    }
    
    private var mealsForSelectedDate: [Meal] {
        dietManager.mealsForDate(dietManager.selectedDate)
    }
    
    private var groupedMeals: [(key: MealType, value: [Meal])] {
        Dictionary(grouping: mealsForSelectedDate) { $0.type }
            .sorted { first, second in
                let order: [MealType] = [.breakfast, .lunch, .dinner, .snack]
                let firstIndex = order.firstIndex(of: first.key) ?? order.count
                let secondIndex = order.firstIndex(of: second.key) ?? order.count
                return firstIndex < secondIndex
            }
    }
}

struct DatePickerHeader: View {
    @EnvironmentObject var dietManager: DietPlannerManager
    
    var body: some View {
        HStack {
            Button(action: previousDay) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.accentColor)
            }
            
            Spacer()
            
            DatePicker(
                "Select Date",
                selection: $dietManager.selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .labelsHidden()
            
            Spacer()
            
            Button(action: nextDay) {
                Image(systemName: "chevron.right")
                    .font(.title2)
                    .foregroundColor(.accentColor)
            }
        }
        .padding()
        .background(Color(.controlBackgroundColor).opacity(0.5))
    }
    
    private func previousDay() {
        dietManager.selectedDate = Calendar.current.date(
            byAdding: .day,
            value: -1,
            to: dietManager.selectedDate
        ) ?? dietManager.selectedDate
    }
    
    private func nextDay() {
        dietManager.selectedDate = Calendar.current.date(
            byAdding: .day,
            value: 1,
            to: dietManager.selectedDate
        ) ?? dietManager.selectedDate
    }
}

struct EmptyMealsView: View {
    @Binding var showingAddMeal: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "fork.knife.circle")
                .font(.system(size: 80))
                .foregroundColor(.gray.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("No meals logged")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("Start tracking your nutrition by adding your first meal")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button("Add Your First Meal") {
                showingAddMeal = true
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
            Spacer()
        }
        .padding()
    }
}

struct MealTypeSection: View {
    let mealType: MealType
    let meals: [Meal]
    let onMealTap: (Meal) -> Void
    
    var totalCalories: Double {
        meals.reduce(0) { $0 + $1.totalCalories }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: mealType.icon)
                    .foregroundColor(mealType.color)
                    .font(.title2)
                
                Text(mealType.rawValue)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(Int(totalCalories)) cal")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text("\(meals.count) meal\(meals.count == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            LazyVStack(spacing: 8) {
                ForEach(meals) { meal in
                    MealCard(meal: meal, onTap: { onMealTap(meal) })
                }
            }
        }
        .padding()
        .background(Color(.controlBackgroundColor))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
    }
}

struct MealCard: View {
    let meal: Meal
    let onTap: () -> Void
    @EnvironmentObject var dietManager: DietPlannerManager
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(meal.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text("\(meal.foodItems.count) items")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(meal.time, style: .time)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(Int(meal.totalCalories)) cal")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 8) {
                        MacroLabel(label: "P", value: meal.totalProtein, color: .red)
                        MacroLabel(label: "C", value: meal.totalCarbs, color: .orange)
                        MacroLabel(label: "F", value: meal.totalFat, color: .yellow)
                    }
                }
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.controlBackgroundColor).opacity(0.5))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button("Edit", systemImage: "pencil") {
                // TODO: Implement edit functionality
            }
            
            Button("Delete", systemImage: "trash", role: .destructive) {
                dietManager.deleteMeal(meal)
            }
        }
    }
}

struct MacroLabel: View {
    let label: String
    let value: Double
    let color: Color
    
    var body: some View {
        VStack(spacing: 1) {
            Text(label)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(color)
            Text("\(Int(value))")
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
    }
}
