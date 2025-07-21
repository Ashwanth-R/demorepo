import Foundation
import SwiftUI

@MainActor
class DietPlannerManager: ObservableObject {
    @Published var userProfile = UserProfile()
    @Published var meals: [Meal] = []
    @Published var selectedDate = Date()
    @Published var foodDatabase: [FoodItem] = []
    
    private let userDefaultsKey = "DietPlannerData"
    
    init() {
        loadData()
        setupSampleFoodDatabase()
    }
    
    // MARK: - Sample Food Database
    private func setupSampleFoodDatabase() {
        foodDatabase = [
            // Proteins
            FoodItem(name: "Grilled Chicken Breast", calories: 165, protein: 31, carbs: 0, fat: 3.6, fiber: 0, servingSize: "100g", category: .protein, imageSystemName: "flame.fill"),
            FoodItem(name: "Salmon Fillet", calories: 208, protein: 25.4, carbs: 0, fat: 12.4, fiber: 0, servingSize: "100g", category: .protein, imageSystemName: "flame.fill"),
            FoodItem(name: "Greek Yogurt", calories: 97, protein: 9, carbs: 6, fat: 5, fiber: 0, servingSize: "100g", category: .dairy, imageSystemName: "drop.fill"),
            FoodItem(name: "Eggs", calories: 155, protein: 13, carbs: 1, fat: 11, fiber: 0, servingSize: "2 large", category: .protein, imageSystemName: "flame.fill"),
            
            // Vegetables
            FoodItem(name: "Broccoli", calories: 34, protein: 2.8, carbs: 7, fat: 0.4, fiber: 2.6, servingSize: "100g", category: .vegetables, imageSystemName: "leaf.fill"),
            FoodItem(name: "Spinach", calories: 23, protein: 2.9, carbs: 3.6, fat: 0.4, fiber: 2.2, servingSize: "100g", category: .vegetables, imageSystemName: "leaf.fill"),
            FoodItem(name: "Sweet Potato", calories: 86, protein: 1.6, carbs: 20, fat: 0.1, fiber: 3, servingSize: "100g", category: .vegetables, imageSystemName: "leaf.fill"),
            FoodItem(name: "Avocado", calories: 160, protein: 2, carbs: 9, fat: 15, fiber: 7, servingSize: "100g", category: .vegetables, imageSystemName: "leaf.fill"),
            
            // Fruits
            FoodItem(name: "Apple", calories: 52, protein: 0.3, carbs: 14, fat: 0.2, fiber: 2.4, servingSize: "1 medium", category: .fruits, imageSystemName: "apple.logo"),
            FoodItem(name: "Banana", calories: 89, protein: 1.1, carbs: 23, fat: 0.3, fiber: 2.6, servingSize: "1 medium", category: .fruits, imageSystemName: "apple.logo"),
            FoodItem(name: "Blueberries", calories: 57, protein: 0.7, carbs: 14, fat: 0.3, fiber: 2.4, servingSize: "100g", category: .fruits, imageSystemName: "apple.logo"),
            
            // Grains
            FoodItem(name: "Brown Rice", calories: 112, protein: 2.6, carbs: 23, fat: 0.9, fiber: 1.8, servingSize: "100g cooked", category: .grains, imageSystemName: "grain.fill"),
            FoodItem(name: "Quinoa", calories: 120, protein: 4.4, carbs: 22, fat: 1.9, fiber: 2.8, servingSize: "100g cooked", category: .grains, imageSystemName: "grain.fill"),
            FoodItem(name: "Oatmeal", calories: 68, protein: 2.4, carbs: 12, fat: 1.4, fiber: 1.7, servingSize: "100g cooked", category: .grains, imageSystemName: "grain.fill"),
            
            // Nuts
            FoodItem(name: "Almonds", calories: 576, protein: 21, carbs: 22, fat: 49, fiber: 12, servingSize: "100g", category: .nuts, imageSystemName: "circle.fill"),
            FoodItem(name: "Walnuts", calories: 654, protein: 15, carbs: 14, fat: 65, fiber: 7, servingSize: "100g", category: .nuts, imageSystemName: "circle.fill"),
            
            // Beverages
            FoodItem(name: "Green Tea", calories: 2, protein: 0, carbs: 0, fat: 0, fiber: 0, servingSize: "1 cup", category: .beverages, imageSystemName: "cup.and.saucer.fill"),
            FoodItem(name: "Protein Shake", calories: 120, protein: 25, carbs: 3, fat: 1, fiber: 1, servingSize: "1 scoop", category: .beverages, imageSystemName: "cup.and.saucer.fill"),
        ]
    }
    
    // MARK: - Meal Management
    func addMeal(_ meal: Meal) {
        meals.append(meal)
        saveData()
    }
    
    func deleteMeal(_ meal: Meal) {
        meals.removeAll { $0.id == meal.id }
        saveData()
    }
    
    func updateMeal(_ meal: Meal) {
        if let index = meals.firstIndex(where: { $0.id == meal.id }) {
            meals[index] = meal
            saveData()
        }
    }
    
    func mealsForDate(_ date: Date) -> [Meal] {
        let calendar = Calendar.current
        return meals.filter { calendar.isDate($0.time, inSameDayAs: date) }
    }
    
    func mealsForToday() -> [Meal] {
        mealsForDate(Date())
    }
    
    // MARK: - Statistics
    func totalCaloriesToday() -> Double {
        mealsForToday().reduce(0) { $0 + $1.totalCalories }
    }
    
    func totalProteinToday() -> Double {
        mealsForToday().reduce(0) { $0 + $1.totalProtein }
    }
    
    func totalCarbsToday() -> Double {
        mealsForToday().reduce(0) { $0 + $1.totalCarbs }
    }
    
    func totalFatToday() -> Double {
        mealsForToday().reduce(0) { $0 + $1.totalFat }
    }
    
    func calorieProgress() -> Double {
        let consumed = totalCaloriesToday()
        let goal = userProfile.dailyCalorieGoal
        return min(consumed / goal, 1.0)
    }
    
    // MARK: - Data Persistence
    private func saveData() {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            
            let profileData = try encoder.encode(userProfile)
            let mealsData = try encoder.encode(meals)
            
            UserDefaults.standard.set(profileData, forKey: "\(userDefaultsKey)_profile")
            UserDefaults.standard.set(mealsData, forKey: "\(userDefaultsKey)_meals")
        } catch {
            print("Failed to save data: \(error)")
        }
    }
    
    private func loadData() {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            if let profileData = UserDefaults.standard.data(forKey: "\(userDefaultsKey)_profile") {
                userProfile = try decoder.decode(UserProfile.self, from: profileData)
            }
            
            if let mealsData = UserDefaults.standard.data(forKey: "\(userDefaultsKey)_meals") {
                meals = try decoder.decode([Meal].self, from: mealsData)
            }
        } catch {
            print("Failed to load data: \(error)")
        }
    }
    
    // MARK: - Food Search
    func searchFood(_ query: String) -> [FoodItem] {
        if query.isEmpty {
            return foodDatabase
        }
        return foodDatabase.filter { 
            $0.name.localizedCaseInsensitiveContains(query) ||
            $0.category.rawValue.localizedCaseInsensitiveContains(query)
        }
    }
    
    // MARK: - Recommendations
    func getDailyRecommendations() -> [String] {
        let consumed = totalCaloriesToday()
        let goal = userProfile.dailyCalorieGoal
        let remaining = goal - consumed
        
        var recommendations: [String] = []
        
        if remaining > 200 {
            recommendations.append("You have \(Int(remaining)) calories remaining for today")
        } else if remaining < -200 {
            recommendations.append("You've exceeded your daily calorie goal by \(Int(abs(remaining))) calories")
        } else {
            recommendations.append("You're on track with your calorie goal!")
        }
        
        let proteinGoal = userProfile.weight * 1.6 // 1.6g per kg body weight
        let proteinConsumed = totalProteinToday()
        
        if proteinConsumed < proteinGoal {
            recommendations.append("Consider adding more protein - aim for \(Int(proteinGoal))g daily")
        }
        
        let mealsToday = mealsForToday().count
        if mealsToday < 3 {
            recommendations.append("Try to have at least 3 balanced meals today")
        }
        
        return recommendations
    }
}
