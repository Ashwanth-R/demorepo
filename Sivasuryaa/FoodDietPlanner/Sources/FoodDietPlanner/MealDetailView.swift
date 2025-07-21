import SwiftUI

struct MealDetailView: View {
    let meal: Meal
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dietManager: DietPlannerManager
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Meal Header Card
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: meal.type.icon)
                                .font(.largeTitle)
                                .foregroundColor(meal.type.color)
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text(meal.time, style: .time)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text(meal.time, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Text(meal.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(meal.type.rawValue)
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(meal.type.color.opacity(0.2))
                            .foregroundColor(meal.type.color)
                            .cornerRadius(8)
                    }
                    .padding()
                    .background(Color(.controlBackgroundColor))
                    .cornerRadius(16)
                    
                    // Nutrition Summary Card
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Nutrition Summary")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        // Total Calories
                        HStack {
                            Text("Total Calories")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Spacer()
                            Text("\(Int(meal.totalCalories)) cal")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                        }
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(12)
                        
                        // Macros Grid
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            MacroSummaryCard(
                                name: "Protein",
                                value: meal.totalProtein,
                                color: .red,
                                icon: "flame.fill"
                            )
                            
                            MacroSummaryCard(
                                name: "Carbs",
                                value: meal.totalCarbs,
                                color: .orange,
                                icon: "leaf.fill"
                            )
                            
                            MacroSummaryCard(
                                name: "Fat",
                                value: meal.totalFat,
                                color: .yellow,
                                icon: "drop.fill"
                            )
                        }
                    }
                    .padding()
                    .background(Color(.controlBackgroundColor))
                    .cornerRadius(16)
                    
                    // Food Items Card
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Food Items")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text("\(meal.foodItems.count) items")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        LazyVStack(spacing: 12) {
                            ForEach(meal.foodItems, id: \.id) { food in
                                MealFoodItemRow(food: food)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.controlBackgroundColor))
                    .cornerRadius(16)
                }
                .padding()
            }
            .navigationTitle("Meal Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .secondaryAction) {
                    Menu {
                        Button("Edit Meal", systemImage: "pencil") {
                            // TODO: Implement edit functionality
                        }
                        
                        Button("Duplicate Meal", systemImage: "doc.on.doc") {
                            duplicateMeal()
                        }
                        
                        Divider()
                        
                        Button("Delete Meal", systemImage: "trash", role: .destructive) {
                            dietManager.deleteMeal(meal)
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
    }
    
    private func duplicateMeal() {
        let duplicatedMeal = Meal(
            name: "\(meal.name) (Copy)",
            time: Date(),
            foodItems: meal.foodItems,
            type: meal.type
        )
        dietManager.addMeal(duplicatedMeal)
    }
}

struct MacroSummaryCard: View {
    let name: String
    let value: Double
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(name)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Text("\(Int(value))g")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct MealFoodItemRow: View {
    let food: FoodItem
    @State private var showingFoodDetail = false
    
    var body: some View {
        Button(action: { showingFoodDetail = true }) {
            HStack(spacing: 12) {
                // Category Icon
                Image(systemName: food.category.icon)
                    .font(.title3)
                    .foregroundColor(food.category.color)
                    .frame(width: 30)
                
                // Food Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(food.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Text(food.servingSize)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(food.category.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Nutrition Info
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(Int(food.calories)) cal")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                    
                    HStack(spacing: 6) {
                        Text("P:\(Int(food.protein))")
                            .font(.caption2)
                            .foregroundColor(.red)
                        Text("C:\(Int(food.carbs))")
                            .font(.caption2)
                            .foregroundColor(.orange)
                        Text("F:\(Int(food.fat))")
                            .font(.caption2)
                            .foregroundColor(.yellow)
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
        .sheet(isPresented: $showingFoodDetail) {
            FoodDetailView(food: food)
        }
    }
}
