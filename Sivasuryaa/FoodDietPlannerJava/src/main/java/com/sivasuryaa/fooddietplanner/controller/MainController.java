package com.sivasuryaa.fooddietplanner.controller;

import com.sivasuryaa.fooddietplanner.model.*;
import com.sivasuryaa.fooddietplanner.service.DietPlannerService;
import com.sivasuryaa.fooddietplanner.util.DateUtils;
import com.sivasuryaa.fooddietplanner.util.FormatUtils;
import com.sivasuryaa.fooddietplanner.view.*;
import javafx.application.Platform;
import javafx.fxml.FXML;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.chart.PieChart;
import javafx.scene.control.*;
import javafx.scene.layout.*;
import javafx.stage.Modality;
import javafx.stage.Stage;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Main controller for the Food Diet Planner application
 */
public class MainController {

    // FXML Components - Dashboard
    @FXML private TabPane mainTabPane;
    @FXML private Label welcomeLabel;
    @FXML private Label dailyCaloriesLabel;
    @FXML private Label calorieGoalLabel;
    @FXML private ProgressBar calorieProgressBar;
    @FXML private Label progressPercentageLabel;
    @FXML private PieChart macroChart;
    @FXML private VBox todaysMealsBox;
    @FXML private VBox recommendationsBox;

    // FXML Components - Meals
    @FXML private DatePicker mealDatePicker;
    @FXML private VBox mealsContainer;
    @FXML private Button addMealButton;

    // FXML Components - Food Database
    @FXML private TextField foodSearchField;
    @FXML private ComboBox<FoodCategory> categoryFilterCombo;
    @FXML private VBox foodItemsContainer;

    // FXML Components - Profile
    @FXML private TextField nameField;
    @FXML private Spinner<Integer> ageSpinner;
    @FXML private Slider weightSlider;
    @FXML private Label weightLabel;
    @FXML private Slider heightSlider;
    @FXML private Label heightLabel;
    @FXML private ComboBox<ActivityLevel> activityLevelCombo;
    @FXML private ComboBox<DietGoal> dietGoalCombo;
    @FXML private Slider targetWeightSlider;
    @FXML private Label targetWeightLabel;
    @FXML private Label bmrLabel;
    @FXML private Label calorieGoalProfileLabel;
    @FXML private Label bmiLabel;

    // FXML Components - Analytics
    @FXML private ComboBox<String> timeframeCombo;
    @FXML private VBox analyticsContainer;

    private DietPlannerService dietPlannerService;

    /**
     * Set the diet planner service (dependency injection)
     */
    public void setDietPlannerService(DietPlannerService service) {
        this.dietPlannerService = service;
    }

    /**
     * Initialize the controller after FXML loading
     */
    public void initialize() {
        if (dietPlannerService == null) {
            System.err.println("DietPlannerService not injected!");
            return;
        }

        Platform.runLater(() -> {
            initializeDashboard();
            initializeMealsTab();
            initializeFoodDatabaseTab();
            initializeProfileTab();
            initializeAnalyticsTab();
            
            // Set up tab change listener to refresh data
            mainTabPane.getSelectionModel().selectedItemProperty().addListener(
                (obs, oldTab, newTab) -> refreshCurrentTab());
        });
    }

    private void initializeDashboard() {
        updateDashboard();
    }

    private void initializeMealsTab() {
        if (mealDatePicker != null) {
            mealDatePicker.setValue(LocalDate.now());
            mealDatePicker.setOnAction(e -> updateMealsDisplay());
        }
        
        if (addMealButton != null) {
            addMealButton.setOnAction(e -> showAddMealDialog());
        }
        
        updateMealsDisplay();
    }

    private void initializeFoodDatabaseTab() {
        if (categoryFilterCombo != null) {
            ObservableList<FoodCategory> categories = FXCollections.observableArrayList();
            categories.add(null); // "All Categories" option
            categories.addAll(FoodCategory.values());
            categoryFilterCombo.setItems(categories);
            categoryFilterCombo.setValue(null);
            categoryFilterCombo.setOnAction(e -> updateFoodDisplay());
        }

        if (foodSearchField != null) {
            foodSearchField.textProperty().addListener((obs, oldText, newText) -> updateFoodDisplay());
        }

        updateFoodDisplay();
    }

    private void initializeProfileTab() {
        UserProfile profile = dietPlannerService.getUserProfile();
        
        if (nameField != null) {
            nameField.setText(profile.getName());
            nameField.textProperty().addListener((obs, oldText, newText) -> updateProfile());
        }

        if (ageSpinner != null) {
            ageSpinner.setValueFactory(new SpinnerValueFactory.IntegerSpinnerValueFactory(13, 100, profile.getAge()));
            ageSpinner.valueProperty().addListener((obs, oldValue, newValue) -> updateProfile());
        }

        if (weightSlider != null) {
            weightSlider.setMin(30);
            weightSlider.setMax(200);
            weightSlider.setValue(profile.getWeight());
            weightSlider.valueProperty().addListener((obs, oldValue, newValue) -> {
                updateWeightLabel();
                updateProfile();
            });
            updateWeightLabel();
        }

        if (heightSlider != null) {
            heightSlider.setMin(120);
            heightSlider.setMax(220);
            heightSlider.setValue(profile.getHeight());
            heightSlider.valueProperty().addListener((obs, oldValue, newValue) -> {
                updateHeightLabel();
                updateProfile();
            });
            updateHeightLabel();
        }

        if (activityLevelCombo != null) {
            activityLevelCombo.setItems(FXCollections.observableArrayList(ActivityLevel.values()));
            activityLevelCombo.setValue(profile.getActivityLevel());
            activityLevelCombo.setOnAction(e -> updateProfile());
        }

        if (dietGoalCombo != null) {
            dietGoalCombo.setItems(FXCollections.observableArrayList(DietGoal.values()));
            dietGoalCombo.setValue(profile.getDietGoal());
            dietGoalCombo.setOnAction(e -> updateProfile());
        }

        if (targetWeightSlider != null) {
            targetWeightSlider.setMin(30);
            targetWeightSlider.setMax(200);
            targetWeightSlider.setValue(profile.getTargetWeight());
            targetWeightSlider.valueProperty().addListener((obs, oldValue, newValue) -> {
                updateTargetWeightLabel();
                updateProfile();
            });
            updateTargetWeightLabel();
        }

        updateProfileCalculations();
    }

    private void initializeAnalyticsTab() {
        if (timeframeCombo != null) {
            timeframeCombo.setItems(FXCollections.observableArrayList("Last 7 Days", "Last 30 Days", "Last 90 Days"));
            timeframeCombo.setValue("Last 7 Days");
            timeframeCombo.setOnAction(e -> updateAnalytics());
        }
        
        updateAnalytics();
    }

    private void updateDashboard() {
        UserProfile profile = dietPlannerService.getUserProfile();
        double dailyCalories = dietPlannerService.getTotalCaloriesToday();
        double calorieGoal = profile.getDailyCalorieGoal();
        double progress = dietPlannerService.getCalorieProgress();

        // Update welcome message
        if (welcomeLabel != null) {
            String name = profile.getName().isEmpty() ? "User" : profile.getName();
            welcomeLabel.setText("Welcome back, " + name + "!");
        }

        // Update calorie information
        if (dailyCaloriesLabel != null) {
            dailyCaloriesLabel.setText(FormatUtils.formatCalories(dailyCalories));
        }

        if (calorieGoalLabel != null) {
            calorieGoalLabel.setText("Goal: " + FormatUtils.formatCalories(calorieGoal));
        }

        if (calorieProgressBar != null) {
            calorieProgressBar.setProgress(progress);
        }

        if (progressPercentageLabel != null) {
            progressPercentageLabel.setText(FormatUtils.formatPercentage(progress));
        }

        // Update macro chart
        updateMacroChart();

        // Update today's meals
        updateTodaysMeals();

        // Update recommendations
        updateRecommendations();
    }

    private void updateMacroChart() {
        if (macroChart == null) return;

        double protein = dietPlannerService.getTotalProteinToday();
        double carbs = dietPlannerService.getTotalCarbsToday();
        double fat = dietPlannerService.getTotalFatToday();

        macroChart.getData().clear();

        if (protein + carbs + fat > 0) {
            macroChart.getData().addAll(
                new PieChart.Data("Protein " + FormatUtils.formatMacro(protein), protein),
                new PieChart.Data("Carbs " + FormatUtils.formatMacro(carbs), carbs),
                new PieChart.Data("Fat " + FormatUtils.formatMacro(fat), fat)
            );
        } else {
            macroChart.getData().add(new PieChart.Data("No data", 1));
        }
    }

    private void updateTodaysMeals() {
        if (todaysMealsBox == null) return;

        todaysMealsBox.getChildren().clear();
        List<Meal> todaysMeals = dietPlannerService.getMealsForToday();

        if (todaysMeals.isEmpty()) {
            Label noMealsLabel = new Label("No meals logged today");
            noMealsLabel.getStyleClass().add("muted-text");
            todaysMealsBox.getChildren().add(noMealsLabel);
        } else {
            for (Meal meal : todaysMeals) {
                VBox mealCard = createMealCard(meal);
                todaysMealsBox.getChildren().add(mealCard);
            }
        }
    }

    private void updateRecommendations() {
        if (recommendationsBox == null) return;

        recommendationsBox.getChildren().clear();
        List<String> recommendations = dietPlannerService.getDailyRecommendations();

        for (String recommendation : recommendations) {
            HBox recBox = new HBox(10);
            recBox.setAlignment(Pos.CENTER_LEFT);
            
            Label bulletLabel = new Label("•");
            bulletLabel.getStyleClass().add("bullet-point");
            
            Label recLabel = new Label(recommendation);
            recLabel.setWrapText(true);
            
            recBox.getChildren().addAll(bulletLabel, recLabel);
            recommendationsBox.getChildren().add(recBox);
        }
    }

    private void updateMealsDisplay() {
        if (mealsContainer == null || mealDatePicker == null) return;

        mealsContainer.getChildren().clear();
        LocalDate selectedDate = mealDatePicker.getValue();
        List<Meal> meals = dietPlannerService.getMealsForDate(selectedDate);

        if (meals.isEmpty()) {
            Label noMealsLabel = new Label("No meals found for " + DateUtils.formatDate(selectedDate));
            noMealsLabel.getStyleClass().add("muted-text");
            mealsContainer.getChildren().add(noMealsLabel);
        } else {
            for (Meal meal : meals) {
                VBox mealCard = createDetailedMealCard(meal);
                mealsContainer.getChildren().add(mealCard);
            }
        }
    }

    private void updateFoodDisplay() {
        if (foodItemsContainer == null) return;

        foodItemsContainer.getChildren().clear();
        
        String searchQuery = foodSearchField != null ? foodSearchField.getText() : "";
        FoodCategory selectedCategory = categoryFilterCombo != null ? categoryFilterCombo.getValue() : null;
        
        List<FoodItem> foods = dietPlannerService.searchFood(searchQuery);
        
        if (selectedCategory != null) {
            foods = foods.stream()
                        .filter(food -> food.getCategory() == selectedCategory)
                        .toList();
        }

        if (foods.isEmpty()) {
            Label noFoodsLabel = new Label("No food items found");
            noFoodsLabel.getStyleClass().add("muted-text");
            foodItemsContainer.getChildren().add(noFoodsLabel);
        } else {
            for (FoodItem food : foods) {
                VBox foodCard = createFoodCard(food);
                foodItemsContainer.getChildren().add(foodCard);
            }
        }
    }

    private void updateProfile() {
        if (dietPlannerService == null) return;

        UserProfile.Builder builder = UserProfile.builder();
        
        if (nameField != null) builder.name(nameField.getText());
        if (ageSpinner != null) builder.age(ageSpinner.getValue());
        if (weightSlider != null) builder.weight(weightSlider.getValue());
        if (heightSlider != null) builder.height(heightSlider.getValue());
        if (activityLevelCombo != null) builder.activityLevel(activityLevelCombo.getValue());
        if (dietGoalCombo != null) builder.dietGoal(dietGoalCombo.getValue());
        if (targetWeightSlider != null) builder.targetWeight(targetWeightSlider.getValue());

        UserProfile updatedProfile = builder.build();
        dietPlannerService.updateUserProfile(updatedProfile);
        
        updateProfileCalculations();
    }

    private void updateWeightLabel() {
        if (weightLabel != null && weightSlider != null) {
            weightLabel.setText(FormatUtils.formatWeight(weightSlider.getValue()));
        }
    }

    private void updateHeightLabel() {
        if (heightLabel != null && heightSlider != null) {
            heightLabel.setText(FormatUtils.formatHeight(heightSlider.getValue()));
        }
    }

    private void updateTargetWeightLabel() {
        if (targetWeightLabel != null && targetWeightSlider != null) {
            targetWeightLabel.setText(FormatUtils.formatWeight(targetWeightSlider.getValue()));
        }
    }

    private void updateProfileCalculations() {
        UserProfile profile = dietPlannerService.getUserProfile();
        
        if (bmrLabel != null) {
            bmrLabel.setText("BMR: " + FormatUtils.formatCalories(profile.getBMR()));
        }
        
        if (calorieGoalProfileLabel != null) {
            calorieGoalProfileLabel.setText("Daily Goal: " + FormatUtils.formatCalories(profile.getDailyCalorieGoal()));
        }
        
        if (bmiLabel != null) {
            bmiLabel.setText("BMI: " + FormatUtils.formatBMI(profile.getBMI()) + " (" + profile.getBMICategory() + ")");
        }
    }

    private void updateAnalytics() {
        if (analyticsContainer == null) return;
        
        analyticsContainer.getChildren().clear();
        
        // Add placeholder analytics content
        Label analyticsLabel = new Label("Analytics Dashboard");
        analyticsLabel.getStyleClass().add("section-header");
        
        Label placeholderLabel = new Label("Detailed analytics charts and trends will be displayed here");
        placeholderLabel.getStyleClass().add("muted-text");
        
        analyticsContainer.getChildren().addAll(analyticsLabel, placeholderLabel);
    }

    private VBox createMealCard(Meal meal) {
        VBox card = new VBox(5);
        card.getStyleClass().add("meal-card");
        card.setPadding(new Insets(10));

        Label nameLabel = new Label(meal.getName());
        nameLabel.getStyleClass().add("meal-name");

        Label typeLabel = new Label(meal.getType().getDisplayName());
        typeLabel.getStyleClass().add("meal-type");

        Label timeLabel = new Label(DateUtils.formatTime(meal.getDateTime()));
        timeLabel.getStyleClass().add("meal-time");

        Label caloriesLabel = new Label(FormatUtils.formatCalories(meal.getTotalCalories()));
        caloriesLabel.getStyleClass().add("meal-calories");

        card.getChildren().addAll(nameLabel, typeLabel, timeLabel, caloriesLabel);
        return card;
    }

    private VBox createDetailedMealCard(Meal meal) {
        VBox card = createMealCard(meal);
        
        // Add more details
        Label itemsLabel = new Label(meal.getFoodItemCount() + " items");
        itemsLabel.getStyleClass().add("meal-items");
        
        Label macrosLabel = new Label(FormatUtils.formatNutritionSummary(
            meal.getTotalProtein(), meal.getTotalCarbs(), meal.getTotalFat()));
        macrosLabel.getStyleClass().add("meal-macros");
        
        Button editButton = new Button("Edit");
        editButton.setOnAction(e -> showEditMealDialog(meal));
        
        Button deleteButton = new Button("Delete");
        deleteButton.setOnAction(e -> deleteMeal(meal));
        deleteButton.getStyleClass().add("danger-button");
        
        HBox buttonBox = new HBox(10, editButton, deleteButton);
        
        card.getChildren().addAll(itemsLabel, macrosLabel, buttonBox);
        return card;
    }

    private VBox createFoodCard(FoodItem food) {
        VBox card = new VBox(5);
        card.getStyleClass().add("food-card");
        card.setPadding(new Insets(10));

        Label nameLabel = new Label(food.getName());
        nameLabel.getStyleClass().add("food-name");

        Label categoryLabel = new Label(food.getCategory().getDisplayName());
        categoryLabel.getStyleClass().add("food-category");

        Label servingLabel = new Label(food.getServingSize());
        servingLabel.getStyleClass().add("food-serving");

        Label caloriesLabel = new Label(FormatUtils.formatCalories(food.getCalories()));
        caloriesLabel.getStyleClass().add("food-calories");

        Label macrosLabel = new Label(FormatUtils.formatNutritionSummary(
            food.getProtein(), food.getCarbs(), food.getFat()));
        macrosLabel.getStyleClass().add("food-macros");

        card.getChildren().addAll(nameLabel, categoryLabel, servingLabel, caloriesLabel, macrosLabel);
        return card;
    }

    private void showAddMealDialog() {
        try {
            AddMealDialog dialog = new AddMealDialog(dietPlannerService);
            Optional<Meal> result = dialog.showAndWait();
            
            if (result.isPresent()) {
                dietPlannerService.addMeal(result.get());
                refreshCurrentTab();
            }
        } catch (Exception e) {
            showErrorDialog("Add Meal", "Failed to open add meal dialog: " + e.getMessage());
        }
    }

    private void showEditMealDialog(Meal meal) {
        try {
            EditMealDialog dialog = new EditMealDialog(dietPlannerService, meal);
            Optional<Meal> result = dialog.showAndWait();
            
            if (result.isPresent()) {
                dietPlannerService.updateMeal(result.get());
                refreshCurrentTab();
            }
        } catch (Exception e) {
            showErrorDialog("Edit Meal", "Failed to open edit meal dialog: " + e.getMessage());
        }
    }

    private void deleteMeal(Meal meal) {
        Alert alert = new Alert(Alert.AlertType.CONFIRMATION);
        alert.setTitle("Delete Meal");
        alert.setHeaderText("Are you sure you want to delete this meal?");
        alert.setContentText(meal.getName() + " - " + FormatUtils.formatCalories(meal.getTotalCalories()));

        Optional<ButtonType> result = alert.showAndWait();
        if (result.isPresent() && result.get() == ButtonType.OK) {
            dietPlannerService.deleteMeal(meal);
            refreshCurrentTab();
        }
    }

    private void refreshCurrentTab() {
        Tab selectedTab = mainTabPane.getSelectionModel().getSelectedItem();
        if (selectedTab == null) return;

        String tabId = selectedTab.getId();
        switch (tabId != null ? tabId : "") {
            case "dashboardTab" -> updateDashboard();
            case "mealsTab" -> updateMealsDisplay();
            case "foodTab" -> updateFoodDisplay();
            case "profileTab" -> {
                // Profile tab doesn't need refresh, it's always up to date
            }
            case "analyticsTab" -> updateAnalytics();
        }
    }

    private void showErrorDialog(String title, String message) {
        Alert alert = new Alert(Alert.AlertType.ERROR);
        alert.setTitle(title);
        alert.setHeaderText("An error occurred");
        alert.setContentText(message);
        alert.showAndWait();
    }
}
