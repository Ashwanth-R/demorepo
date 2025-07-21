import XCTest
@testable import FoodDietPlanner

final class FoodDietPlannerTests: XCTestCase {
    var dietManager: DietPlannerManager!
    
    override func setUp() {
        super.setUp()
        dietManager = DietPlannerManager()
    }
    
    override func tearDown() {
        dietManager = nil
        super.tearDown()
    }
    
    func testUserProfileBMRCalculation() {
        // Test BMR calculation for a sample user
        let profile = UserProfile(
            name: "Test User",
            age: 30,
            weight: 70.0,
            height: 175.0,
            activityLevel: .moderate,
            dietGoal: .maintenance,
            targetWeight: 70.0
        )
        
        // BMR = 10 * weight + 6.25 * height - 5 * age + 5
        let expectedBMR = 10 * 70 + 6.25 * 175 - 5 * 30 + 5
        XCTAssertEqual(profile.bmr, expectedBMR, accuracy: 0.1)
    }
    
    func testDailyCalorieGoalCalculation() {
        let profile = UserProfile(
            age: 30,
            weight: 70.0,
            height: 175.0,
            activityLevel: .moderate,
            dietGoal: .weightLoss
        )
        
        let expectedBMR = 10 * 70 + 6.25 * 175 - 5 * 30 + 5
        let expectedCalories = expectedBMR * 1.55 - 500 // Weight loss goal
        
        XCTAssertEqual(profile.dailyCalorieGoal, expectedCalories, accuracy: 0.1)
    }
    
    func testMealTotalCalculations() {
        let foodItem1 = FoodItem(
            name: "Test Food 1",
            calories: 100,
            protein: 10,
            carbs: 20,
            fat: 5,
            fiber: 2,
            servingSize: "100g",
            category: .protein,
            imageSystemName: "flame.fill"
        )
        
        let foodItem2 = FoodItem(
            name: "Test Food 2",
            calories: 200,
            protein: 15,
            carbs: 30,
            fat: 8,
            fiber: 3,
            servingSize: "100g",
            category: .vegetables,
            imageSystemName: "leaf.fill"
        )
        
        let meal = Meal(
            name: "Test Meal",
            time: Date(),
            foodItems: [foodItem1, foodItem2],
            type: .lunch
        )
        
        XCTAssertEqual(meal.totalCalories, 300)
        XCTAssertEqual(meal.totalProtein, 25)
        XCTAssertEqual(meal.totalCarbs, 50)
        XCTAssertEqual(meal.totalFat, 13)
    }
    
    func testFoodSearch() {
        let searchResults = dietManager.searchFood("chicken")
        XCTAssertFalse(searchResults.isEmpty)
        
        let emptyResults = dietManager.searchFood("nonexistentfood")
        XCTAssertTrue(emptyResults.isEmpty)
    }
    
    func testMealManagement() {
        let initialMealCount = dietManager.meals.count
        
        let testMeal = Meal(
            name: "Test Meal",
            time: Date(),
            foodItems: [],
            type: .breakfast
        )
        
        dietManager.addMeal(testMeal)
        XCTAssertEqual(dietManager.meals.count, initialMealCount + 1)
        
        dietManager.deleteMeal(testMeal)
        XCTAssertEqual(dietManager.meals.count, initialMealCount)
    }
    
    func testCalorieProgress() {
        // Clear existing meals for clean test
        dietManager.meals.removeAll()
        
        // Set a known calorie goal
        dietManager.userProfile = UserProfile(
            age: 30,
            weight: 70,
            height: 175,
            activityLevel: .moderate,
            dietGoal: .maintenance
        )
        
        let testFood = FoodItem(
            name: "Test Food",
            calories: 500,
            protein: 10,
            carbs: 20,
            fat: 5,
            fiber: 2,
            servingSize: "100g",
            category: .protein,
            imageSystemName: "flame.fill"
        )
        
        let testMeal = Meal(
            name: "Test Meal",
            time: Date(),
            foodItems: [testFood],
            type: .breakfast
        )
        
        dietManager.addMeal(testMeal)
        
        let progress = dietManager.calorieProgress()
        XCTAssertGreaterThan(progress, 0)
        XCTAssertLessThanOrEqual(progress, 1.0)
    }
}
