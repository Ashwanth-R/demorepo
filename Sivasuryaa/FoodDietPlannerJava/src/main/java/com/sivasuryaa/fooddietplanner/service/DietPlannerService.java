package com.sivasuryaa.fooddietplanner.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.sivasuryaa.fooddietplanner.model.*;

import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Main service class for managing diet planning data and operations
 */
public class DietPlannerService {
    private static final String DATA_DIR = System.getProperty("user.home") + "/.fooddietplanner";
    private static final String PROFILE_FILE = DATA_DIR + "/profile.json";
    private static final String MEALS_FILE = DATA_DIR + "/meals.json";
    private static final String FOODS_FILE = DATA_DIR + "/foods.json";

    private final ObjectMapper objectMapper;
    private UserProfile userProfile;
    private List<Meal> meals;
    private List<FoodItem> foodDatabase;

    public DietPlannerService() {
        this.objectMapper = new ObjectMapper();
        this.objectMapper.registerModule(new JavaTimeModule());
        
        // Initialize data directory
        initializeDataDirectory();
        
        // Load existing data or create defaults
        loadAllData();
    }

    private void initializeDataDirectory() {
        File dataDir = new File(DATA_DIR);
        if (!dataDir.exists()) {
            dataDir.mkdirs();
        }
    }

    // User Profile Management
    public UserProfile getUserProfile() {
        return userProfile;
    }

    public void updateUserProfile(UserProfile profile) {
        this.userProfile = profile;
        saveUserProfile();
    }

    // Meal Management
    public List<Meal> getAllMeals() {
        return new ArrayList<>(meals);
    }

    public void addMeal(Meal meal) {
        meals.add(meal);
        saveMeals();
    }

    public void updateMeal(Meal meal) {
        meals.removeIf(m -> m.getId().equals(meal.getId()));
        meals.add(meal);
        saveMeals();
    }

    public void deleteMeal(String mealId) {
        meals.removeIf(m -> m.getId().equals(mealId));
        saveMeals();
    }

    public void deleteMeal(Meal meal) {
        deleteMeal(meal.getId());
    }

    public List<Meal> getMealsForDate(LocalDate date) {
        return meals.stream()
                   .filter(meal -> meal.getDateTime().toLocalDate().equals(date))
                   .collect(Collectors.toList());
    }

    public List<Meal> getMealsForToday() {
        return getMealsForDate(LocalDate.now());
    }

    // Food Database Management
    public List<FoodItem> getFoodDatabase() {
        return new ArrayList<>(foodDatabase);
    }

    public void addFoodItem(FoodItem foodItem) {
        foodDatabase.add(foodItem);
        saveFoodDatabase();
    }

    public void updateFoodItem(FoodItem foodItem) {
        foodDatabase.removeIf(f -> f.getId().equals(foodItem.getId()));
        foodDatabase.add(foodItem);
        saveFoodDatabase();
    }

    public void deleteFoodItem(String foodItemId) {
        foodDatabase.removeIf(f -> f.getId().equals(foodItemId));
        saveFoodDatabase();
    }

    public List<FoodItem> searchFood(String query) {
        if (query == null || query.trim().isEmpty()) {
            return new ArrayList<>(foodDatabase);
        }
        
        String lowercaseQuery = query.toLowerCase().trim();
        return foodDatabase.stream()
                          .filter(food -> 
                              food.getName().toLowerCase().contains(lowercaseQuery) ||
                              food.getCategory().getDisplayName().toLowerCase().contains(lowercaseQuery))
                          .collect(Collectors.toList());
    }

    public List<FoodItem> getFoodsByCategory(FoodCategory category) {
        return foodDatabase.stream()
                          .filter(food -> food.getCategory() == category)
                          .collect(Collectors.toList());
    }

    // Statistics and Analytics
    public double getTotalCaloriesToday() {
        return getMealsForToday().stream()
                                .mapToDouble(Meal::getTotalCalories)
                                .sum();
    }

    public double getTotalProteinToday() {
        return getMealsForToday().stream()
                                .mapToDouble(Meal::getTotalProtein)
                                .sum();
    }

    public double getTotalCarbsToday() {
        return getMealsForToday().stream()
                                .mapToDouble(Meal::getTotalCarbs)
                                .sum();
    }

    public double getTotalFatToday() {
        return getMealsForToday().stream()
                                .mapToDouble(Meal::getTotalFat)
                                .sum();
    }

    public double getCalorieProgress() {
        double consumed = getTotalCaloriesToday();
        double goal = userProfile.getDailyCalorieGoal();
        return Math.min(consumed / goal, 1.0);
    }

    public List<String> getDailyRecommendations() {
        List<String> recommendations = new ArrayList<>();
        
        double consumed = getTotalCaloriesToday();
        double goal = userProfile.getDailyCalorieGoal();
        double remaining = goal - consumed;
        
        if (remaining > 200) {
            recommendations.add(String.format("You have %.0f calories remaining for today", remaining));
        } else if (remaining < -200) {
            recommendations.add(String.format("You've exceeded your daily calorie goal by %.0f calories", Math.abs(remaining)));
        } else {
            recommendations.add("You're on track with your calorie goal!");
        }
        
        double proteinGoal = userProfile.getRecommendedProtein();
        double proteinConsumed = getTotalProteinToday();
        
        if (proteinConsumed < proteinGoal) {
            recommendations.add(String.format("Consider adding more protein - aim for %.0fg daily", proteinGoal));
        }
        
        int mealsToday = getMealsForToday().size();
        if (mealsToday < 3) {
            recommendations.add("Try to have at least 3 balanced meals today");
        }
        
        return recommendations;
    }

    // Data Persistence
    public void saveAllData() {
        saveUserProfile();
        saveMeals();
        saveFoodDatabase();
    }

    private void saveUserProfile() {
        try {
            objectMapper.writeValue(new File(PROFILE_FILE), userProfile);
        } catch (IOException e) {
            System.err.println("Failed to save user profile: " + e.getMessage());
        }
    }

    private void saveMeals() {
        try {
            objectMapper.writeValue(new File(MEALS_FILE), meals);
        } catch (IOException e) {
            System.err.println("Failed to save meals: " + e.getMessage());
        }
    }

    private void saveFoodDatabase() {
        try {
            objectMapper.writeValue(new File(FOODS_FILE), foodDatabase);
        } catch (IOException e) {
            System.err.println("Failed to save food database: " + e.getMessage());
        }
    }

    private void loadAllData() {
        loadUserProfile();
        loadMeals();
        loadFoodDatabase();
    }

    private void loadUserProfile() {
        try {
            File profileFile = new File(PROFILE_FILE);
            if (profileFile.exists()) {
                userProfile = objectMapper.readValue(profileFile, UserProfile.class);
            } else {
                userProfile = new UserProfile();
                saveUserProfile();
            }
        } catch (IOException e) {
            System.err.println("Failed to load user profile: " + e.getMessage());
            userProfile = new UserProfile();
        }
    }

    private void loadMeals() {
        try {
            File mealsFile = new File(MEALS_FILE);
            if (mealsFile.exists()) {
                meals = objectMapper.readValue(mealsFile, new TypeReference<List<Meal>>() {});
            } else {
                meals = new ArrayList<>();
                saveMeals();
            }
        } catch (IOException e) {
            System.err.println("Failed to load meals: " + e.getMessage());
            meals = new ArrayList<>();
        }
    }

    private void loadFoodDatabase() {
        try {
            File foodsFile = new File(FOODS_FILE);
            if (foodsFile.exists()) {
                foodDatabase = objectMapper.readValue(foodsFile, new TypeReference<List<FoodItem>>() {});
            } else {
                foodDatabase = createSampleFoodDatabase();
                saveFoodDatabase();
            }
        } catch (IOException e) {
            System.err.println("Failed to load food database: " + e.getMessage());
            foodDatabase = createSampleFoodDatabase();
        }
    }

    private List<FoodItem> createSampleFoodDatabase() {
        List<FoodItem> foods = new ArrayList<>();
        
        // Proteins
        foods.add(FoodItem.builder()
            .name("Grilled Chicken Breast")
            .calories(165).protein(31).carbs(0).fat(3.6).fiber(0)
            .servingSize("100g").category(FoodCategory.PROTEIN).build());
        
        foods.add(FoodItem.builder()
            .name("Salmon Fillet")
            .calories(208).protein(25.4).carbs(0).fat(12.4).fiber(0)
            .servingSize("100g").category(FoodCategory.PROTEIN).build());
        
        foods.add(FoodItem.builder()
            .name("Eggs")
            .calories(155).protein(13).carbs(1).fat(11).fiber(0)
            .servingSize("2 large").category(FoodCategory.PROTEIN).build());
        
        // Vegetables
        foods.add(FoodItem.builder()
            .name("Broccoli")
            .calories(34).protein(2.8).carbs(7).fat(0.4).fiber(2.6)
            .servingSize("100g").category(FoodCategory.VEGETABLES).build());
        
        foods.add(FoodItem.builder()
            .name("Spinach")
            .calories(23).protein(2.9).carbs(3.6).fat(0.4).fiber(2.2)
            .servingSize("100g").category(FoodCategory.VEGETABLES).build());
        
        foods.add(FoodItem.builder()
            .name("Sweet Potato")
            .calories(86).protein(1.6).carbs(20).fat(0.1).fiber(3)
            .servingSize("100g").category(FoodCategory.VEGETABLES).build());
        
        // Fruits
        foods.add(FoodItem.builder()
            .name("Apple")
            .calories(52).protein(0.3).carbs(14).fat(0.2).fiber(2.4)
            .servingSize("1 medium").category(FoodCategory.FRUITS).build());
        
        foods.add(FoodItem.builder()
            .name("Banana")
            .calories(89).protein(1.1).carbs(23).fat(0.3).fiber(2.6)
            .servingSize("1 medium").category(FoodCategory.FRUITS).build());
        
        foods.add(FoodItem.builder()
            .name("Blueberries")
            .calories(57).protein(0.7).carbs(14).fat(0.3).fiber(2.4)
            .servingSize("100g").category(FoodCategory.FRUITS).build());
        
        // Grains
        foods.add(FoodItem.builder()
            .name("Brown Rice")
            .calories(112).protein(2.6).carbs(23).fat(0.9).fiber(1.8)
            .servingSize("100g cooked").category(FoodCategory.GRAINS).build());
        
        foods.add(FoodItem.builder()
            .name("Quinoa")
            .calories(120).protein(4.4).carbs(22).fat(1.9).fiber(2.8)
            .servingSize("100g cooked").category(FoodCategory.GRAINS).build());
        
        foods.add(FoodItem.builder()
            .name("Oatmeal")
            .calories(68).protein(2.4).carbs(12).fat(1.4).fiber(1.7)
            .servingSize("100g cooked").category(FoodCategory.GRAINS).build());
        
        // Dairy
        foods.add(FoodItem.builder()
            .name("Greek Yogurt")
            .calories(97).protein(9).carbs(6).fat(5).fiber(0)
            .servingSize("100g").category(FoodCategory.DAIRY).build());
        
        foods.add(FoodItem.builder()
            .name("Milk (2%)")
            .calories(50).protein(3.3).carbs(5).fat(2).fiber(0)
            .servingSize("100ml").category(FoodCategory.DAIRY).build());
        
        // Nuts
        foods.add(FoodItem.builder()
            .name("Almonds")
            .calories(576).protein(21).carbs(22).fat(49).fiber(12)
            .servingSize("100g").category(FoodCategory.NUTS).build());
        
        foods.add(FoodItem.builder()
            .name("Walnuts")
            .calories(654).protein(15).carbs(14).fat(65).fiber(7)
            .servingSize("100g").category(FoodCategory.NUTS).build());
        
        // Beverages
        foods.add(FoodItem.builder()
            .name("Green Tea")
            .calories(2).protein(0).carbs(0).fat(0).fiber(0)
            .servingSize("1 cup").category(FoodCategory.BEVERAGES).build());
        
        foods.add(FoodItem.builder()
            .name("Protein Shake")
            .calories(120).protein(25).carbs(3).fat(1).fiber(1)
            .servingSize("1 scoop").category(FoodCategory.BEVERAGES).build());
        
        return foods;
    }

    // Reset all data
    public void resetAllData() {
        meals.clear();
        userProfile = new UserProfile();
        foodDatabase = createSampleFoodDatabase();
        saveAllData();
    }
}
