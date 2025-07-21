import Foundation
import SwiftUI

// MARK: - Food Item Model
struct FoodItem: Identifiable, Codable, Hashable {
    let id = UUID()
    var name: String
    var calories: Double
    var protein: Double
    var carbs: Double
    var fat: Double
    var fiber: Double
    var servingSize: String
    var category: FoodCategory
    var imageSystemName: String
    
    var totalMacros: Double {
        protein + carbs + fat
    }
}

// MARK: - Food Category
enum FoodCategory: String, CaseIterable, Codable {
    case protein = "Protein"
    case vegetables = "Vegetables"
    case fruits = "Fruits"
    case grains = "Grains"
    case dairy = "Dairy"
    case nuts = "Nuts & Seeds"
    case beverages = "Beverages"
    case snacks = "Snacks"
    
    var color: Color {
        switch self {
        case .protein: return .red
        case .vegetables: return .green
        case .fruits: return .orange
        case .grains: return .brown
        case .dairy: return .blue
        case .nuts: return .purple
        case .beverages: return .cyan
        case .snacks: return .yellow
        }
    }
    
    var icon: String {
        switch self {
        case .protein: return "flame.fill"
        case .vegetables: return "leaf.fill"
        case .fruits: return "apple.logo"
        case .grains: return "grain.fill"
        case .dairy: return "drop.fill"
        case .nuts: return "circle.fill"
        case .beverages: return "cup.and.saucer.fill"
        case .snacks: return "sparkles"
        }
    }
}

// MARK: - Meal Model
struct Meal: Identifiable, Codable {
    let id = UUID()
    var name: String
    var time: Date
    var foodItems: [FoodItem]
    var type: MealType
    
    var totalCalories: Double {
        foodItems.reduce(0) { $0 + $1.calories }
    }
    
    var totalProtein: Double {
        foodItems.reduce(0) { $0 + $1.protein }
    }
    
    var totalCarbs: Double {
        foodItems.reduce(0) { $0 + $1.carbs }
    }
    
    var totalFat: Double {
        foodItems.reduce(0) { $0 + $1.fat }
    }
}

// MARK: - Meal Type
enum MealType: String, CaseIterable, Codable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"
    
    var icon: String {
        switch self {
        case .breakfast: return "sunrise.fill"
        case .lunch: return "sun.max.fill"
        case .dinner: return "moon.fill"
        case .snack: return "star.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .breakfast: return .orange
        case .lunch: return .yellow
        case .dinner: return .purple
        case .snack: return .pink
        }
    }
}

// MARK: - Diet Goal
enum DietGoal: String, CaseIterable, Codable {
    case weightLoss = "Weight Loss"
    case weightGain = "Weight Gain"
    case maintenance = "Maintenance"
    case muscleGain = "Muscle Gain"
    
    var description: String {
        switch self {
        case .weightLoss: return "Reduce calorie intake for sustainable weight loss"
        case .weightGain: return "Increase calorie intake for healthy weight gain"
        case .maintenance: return "Maintain current weight with balanced nutrition"
        case .muscleGain: return "High protein intake for muscle building"
        }
    }
    
    var color: Color {
        switch self {
        case .weightLoss: return .red
        case .weightGain: return .green
        case .maintenance: return .blue
        case .muscleGain: return .orange
        }
    }
}

// MARK: - User Profile
struct UserProfile: Codable {
    var name: String = ""
    var age: Int = 25
    var weight: Double = 70.0
    var height: Double = 170.0
    var activityLevel: ActivityLevel = .moderate
    var dietGoal: DietGoal = .maintenance
    var targetWeight: Double = 70.0
    
    var bmr: Double {
        // Mifflin-St Jeor Equation
        return 10 * weight + 6.25 * height - 5 * Double(age) + 5
    }
    
    var dailyCalorieGoal: Double {
        let activityMultiplier = activityLevel.multiplier
        let bmrWithActivity = bmr * activityMultiplier
        
        switch dietGoal {
        case .weightLoss:
            return bmrWithActivity - 500 // 500 calorie deficit
        case .weightGain:
            return bmrWithActivity + 500 // 500 calorie surplus
        case .maintenance:
            return bmrWithActivity
        case .muscleGain:
            return bmrWithActivity + 300 // 300 calorie surplus
        }
    }
}

// MARK: - Activity Level
enum ActivityLevel: String, CaseIterable, Codable {
    case sedentary = "Sedentary"
    case light = "Light"
    case moderate = "Moderate"
    case active = "Active"
    case veryActive = "Very Active"
    
    var multiplier: Double {
        switch self {
        case .sedentary: return 1.2
        case .light: return 1.375
        case .moderate: return 1.55
        case .active: return 1.725
        case .veryActive: return 1.9
        }
    }
    
    var description: String {
        switch self {
        case .sedentary: return "Little to no exercise"
        case .light: return "Light exercise 1-3 days/week"
        case .moderate: return "Moderate exercise 3-5 days/week"
        case .active: return "Hard exercise 6-7 days/week"
        case .veryActive: return "Very hard exercise, physical job"
        }
    }
}
