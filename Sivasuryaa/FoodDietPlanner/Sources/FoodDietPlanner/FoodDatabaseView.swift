import SwiftUI

struct FoodDatabaseView: View {
    @EnvironmentObject var dietManager: DietPlannerManager
    @State private var searchText = ""
    @State private var selectedCategory: FoodCategory?
    @State private var sortOption: SortOption = .name
    
    enum SortOption: String, CaseIterable {
        case name = "Name"
        case calories = "Calories"
        case protein = "Protein"
        case category = "Category"
    }
    
    var filteredAndSortedFoods: [FoodItem] {
        let searchResults = dietManager.searchFood(searchText)
        
        let categoryFiltered = if let category = selectedCategory {
            searchResults.filter { $0.category == category }
        } else {
            searchResults
        }
        
        return categoryFiltered.sorted { first, second in
            switch sortOption {
            case .name:
                return first.name < second.name
            case .calories:
                return first.calories > second.calories
            case .protein:
                return first.protein > second.protein
            case .category:
                return first.category.rawValue < second.category.rawValue
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search and Filter Header
            VStack(spacing: 12) {
                SearchBar(text: $searchText)
                
                HStack {
                    CategoryFilter(selectedCategory: $selectedCategory)
                    
                    Spacer()
                    
                    Menu {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Button(option.rawValue) {
                                sortOption = option
                            }
                        }
                    } label: {
                        HStack {
                            Text("Sort by \(sortOption.rawValue)")
                                .font(.subheadline)
                            Image(systemName: "chevron.down")
                                .font(.caption)
                        }
                        .foregroundColor(.accentColor)
                    }
                }
            }
            .padding()
            .background(Color(.controlBackgroundColor).opacity(0.5))
            
            Divider()
            
            // Food Items Grid
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(filteredAndSortedFoods) { food in
                        FoodCard(food: food)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Food Database")
    }
}

struct FoodCard: View {
    let food: FoodItem
    @State private var showingDetail = false
    
    var body: some View {
        Button(action: { showingDetail = true }) {
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    Image(systemName: food.category.icon)
                        .font(.title2)
                        .foregroundColor(food.category.color)
                    
                    Spacer()
                    
                    Text(food.category.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(food.category.color.opacity(0.2))
                        .foregroundColor(food.category.color)
                        .cornerRadius(6)
                }
                
                // Food Name
                Text(food.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                // Serving Size
                Text(food.servingSize)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Divider()
                
                // Nutrition Info
                VStack(spacing: 8) {
                    HStack {
                        Text("Calories")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(Int(food.calories))")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.orange)
                    }
                    
                    HStack {
                        MacroIndicator(label: "P", value: food.protein, color: .red)
                        MacroIndicator(label: "C", value: food.carbs, color: .orange)
                        MacroIndicator(label: "F", value: food.fat, color: .yellow)
                        if food.fiber > 0 {
                            MacroIndicator(label: "Fiber", value: food.fiber, color: .green)
                        }
                    }
                }
            }
            .padding()
            .background(Color(.controlBackgroundColor))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showingDetail) {
            FoodDetailView(food: food)
        }
    }
}

struct MacroIndicator: View {
    let label: String
    let value: Double
    let color: Color
    
    var body: some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(color)
            Text("\(value, specifier: "%.1f")g")
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct FoodDetailView: View {
    let food: FoodItem
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header Card
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: food.category.icon)
                                .font(.largeTitle)
                                .foregroundColor(food.category.color)
                            
                            Spacer()
                            
                            Text(food.category.rawValue)
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(food.category.color.opacity(0.2))
                                .foregroundColor(food.category.color)
                                .cornerRadius(8)
                        }
                        
                        Text(food.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Per \(food.servingSize)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.controlBackgroundColor))
                    .cornerRadius(16)
                    
                    // Calories Card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Calories")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        HStack {
                            Text("\(Int(food.calories))")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.orange)
                            Text("cal")
                                .font(.title3)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color(.controlBackgroundColor))
                    .cornerRadius(16)
                    
                    // Macronutrients Card
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Macronutrients")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            MacroDetailCard(name: "Protein", value: food.protein, unit: "g", color: .red, icon: "flame.fill")
                            MacroDetailCard(name: "Carbs", value: food.carbs, unit: "g", color: .orange, icon: "leaf.fill")
                            MacroDetailCard(name: "Fat", value: food.fat, unit: "g", color: .yellow, icon: "drop.fill")
                            MacroDetailCard(name: "Fiber", value: food.fiber, unit: "g", color: .green, icon: "scissors")
                        }
                    }
                    .padding()
                    .background(Color(.controlBackgroundColor))
                    .cornerRadius(16)
                }
                .padding()
            }
            .navigationTitle("Food Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct MacroDetailCard: View {
    let name: String
    let value: Double
    let unit: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(name)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            HStack(spacing: 2) {
                Text("\(value, specifier: "%.1f")")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                Text(unit)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}
