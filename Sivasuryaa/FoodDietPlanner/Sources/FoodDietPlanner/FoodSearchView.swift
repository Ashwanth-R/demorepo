import SwiftUI

struct FoodSearchView: View {
    @EnvironmentObject var dietManager: DietPlannerManager
    @Environment(\.dismiss) var dismiss
    @Binding var selectedFoodItems: [FoodItem]
    
    @State private var searchText = ""
    @State private var selectedCategory: FoodCategory?
    @State private var localSelectedItems: Set<UUID> = []
    
    var filteredFoods: [FoodItem] {
        let searchResults = dietManager.searchFood(searchText)
        
        if let category = selectedCategory {
            return searchResults.filter { $0.category == category }
        }
        
        return searchResults
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $searchText)
                    .padding()
                
                // Category Filter
                CategoryFilter(selectedCategory: $selectedCategory)
                    .padding(.horizontal)
                
                Divider()
                
                // Food Items List
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(filteredFoods) { food in
                            FoodSearchRow(
                                food: food,
                                isSelected: localSelectedItems.contains(food.id)
                            ) {
                                toggleFoodSelection(food)
                            }
                            
                            if food.id != filteredFoods.last?.id {
                                Divider()
                                    .padding(.leading, 60)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Food Items")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add (\(localSelectedItems.count))") {
                        addSelectedItems()
                    }
                    .disabled(localSelectedItems.isEmpty)
                }
            }
        }
        .onAppear {
            // Pre-select items that are already in the meal
            localSelectedItems = Set(selectedFoodItems.map { $0.id })
        }
    }
    
    private func toggleFoodSelection(_ food: FoodItem) {
        if localSelectedItems.contains(food.id) {
            localSelectedItems.remove(food.id)
        } else {
            localSelectedItems.insert(food.id)
        }
    }
    
    private func addSelectedItems() {
        let newItems = dietManager.foodDatabase.filter { localSelectedItems.contains($0.id) }
        selectedFoodItems = newItems
        dismiss()
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search foods...", text: $text)
                .textFieldStyle(.plain)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.controlBackgroundColor))
        .cornerRadius(10)
    }
}

struct CategoryFilter: View {
    @Binding var selectedCategory: FoodCategory?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                CategoryChip(
                    title: "All",
                    isSelected: selectedCategory == nil,
                    color: .accentColor
                ) {
                    selectedCategory = nil
                }
                
                ForEach(FoodCategory.allCases, id: \.self) { category in
                    CategoryChip(
                        title: category.rawValue,
                        isSelected: selectedCategory == category,
                        color: category.color
                    ) {
                        selectedCategory = selectedCategory == category ? nil : category
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : color)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? color : color.opacity(0.2))
                )
        }
        .buttonStyle(.plain)
    }
}

struct FoodSearchRow: View {
    let food: FoodItem
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Category Icon
                Image(systemName: food.category.icon)
                    .font(.title2)
                    .foregroundColor(food.category.color)
                    .frame(width: 30)
                
                // Food Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(food.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Text(food.category.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(food.servingSize)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Nutrition Info
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(Int(food.calories)) cal")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 6) {
                        NutrientBadge(label: "P", value: food.protein, color: .red)
                        NutrientBadge(label: "C", value: food.carbs, color: .orange)
                        NutrientBadge(label: "F", value: food.fat, color: .yellow)
                    }
                }
                
                // Selection Indicator
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isSelected ? .green : .secondary)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
        }
        .buttonStyle(.plain)
    }
}

struct NutrientBadge: View {
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
        .frame(minWidth: 20)
    }
}
