import SwiftUI

struct AddMealView: View {
    @EnvironmentObject var dietManager: DietPlannerManager
    @Environment(\.dismiss) var dismiss
    
    @State private var mealName = ""
    @State private var selectedMealType = MealType.breakfast
    @State private var selectedDate = Date()
    @State private var selectedFoodItems: [FoodItem] = []
    @State private var showingFoodSearch = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Meal Information") {
                    TextField("Meal Name", text: $mealName)
                        .textFieldStyle(.roundedBorder)
                    
                    Picker("Meal Type", selection: $selectedMealType) {
                        ForEach(MealType.allCases, id: \.self) { type in
                            HStack {
                                Image(systemName: type.icon)
                                    .foregroundColor(type.color)
                                Text(type.rawValue)
                            }
                            .tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    DatePicker("Time", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                }
                
                Section("Food Items") {
                    if selectedFoodItems.isEmpty {
                        Button("Add Food Items") {
                            showingFoodSearch = true
                        }
                        .foregroundColor(.accentColor)
                    } else {
                        ForEach(selectedFoodItems, id: \.id) { food in
                            FoodItemRow(food: food)
                        }
                        .onDelete(perform: removeFoodItems)
                        
                        Button("Add More Items") {
                            showingFoodSearch = true
                        }
                        .foregroundColor(.accentColor)
                    }
                }
                
                if !selectedFoodItems.isEmpty {
                    Section("Nutrition Summary") {
                        NutritionSummaryView(foodItems: selectedFoodItems)
                    }
                }
            }
            .navigationTitle("Add Meal")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveMeal()
                    }
                    .disabled(mealName.isEmpty || selectedFoodItems.isEmpty)
                }
            }
            .sheet(isPresented: $showingFoodSearch) {
                FoodSearchView(selectedFoodItems: $selectedFoodItems)
            }
        }
    }
    
    private func removeFoodItems(at offsets: IndexSet) {
        selectedFoodItems.remove(atOffsets: offsets)
    }
    
    private func saveMeal() {
        let meal = Meal(
            name: mealName,
            time: selectedDate,
            foodItems: selectedFoodItems,
            type: selectedMealType
        )
        
        dietManager.addMeal(meal)
        dismiss()
    }
}

struct FoodItemRow: View {
    let food: FoodItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(food.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(food.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(food.servingSize)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(food.calories)) cal")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                HStack(spacing: 6) {
                    Text("P: \(Int(food.protein))g")
                        .font(.caption2)
                        .foregroundColor(.red)
                    Text("C: \(Int(food.carbs))g")
                        .font(.caption2)
                        .foregroundColor(.orange)
                    Text("F: \(Int(food.fat))g")
                        .font(.caption2)
                        .foregroundColor(.yellow)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct NutritionSummaryView: View {
    let foodItems: [FoodItem]
    
    private var totalCalories: Double {
        foodItems.reduce(0) { $0 + $1.calories }
    }
    
    private var totalProtein: Double {
        foodItems.reduce(0) { $0 + $1.protein }
    }
    
    private var totalCarbs: Double {
        foodItems.reduce(0) { $0 + $1.carbs }
    }
    
    private var totalFat: Double {
        foodItems.reduce(0) { $0 + $1.fat }
    }
    
    private var totalFiber: Double {
        foodItems.reduce(0) { $0 + $1.fiber }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Total Calories")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Text("\(Int(totalCalories)) cal")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            
            Divider()
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                MacroSummaryItem(
                    title: "Protein",
                    value: totalProtein,
                    unit: "g",
                    color: .red
                )
                
                MacroSummaryItem(
                    title: "Carbs",
                    value: totalCarbs,
                    unit: "g",
                    color: .orange
                )
                
                MacroSummaryItem(
                    title: "Fat",
                    value: totalFat,
                    unit: "g",
                    color: .yellow
                )
                
                MacroSummaryItem(
                    title: "Fiber",
                    value: totalFiber,
                    unit: "g",
                    color: .green
                )
            }
        }
        .padding()
        .background(Color(.controlBackgroundColor).opacity(0.5))
        .cornerRadius(12)
    }
}

struct MacroSummaryItem: View {
    let title: String
    let value: Double
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack(spacing: 2) {
                Text("\(Int(value))")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
                Text(unit)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}
