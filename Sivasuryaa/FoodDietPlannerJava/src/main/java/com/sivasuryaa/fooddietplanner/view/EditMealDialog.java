package com.sivasuryaa.fooddietplanner.view;

import com.sivasuryaa.fooddietplanner.model.*;
import com.sivasuryaa.fooddietplanner.service.DietPlannerService;
import com.sivasuryaa.fooddietplanner.util.FormatUtils;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.control.*;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.stage.Modality;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Dialog for editing an existing meal
 */
public class EditMealDialog extends Dialog<Meal> {
    
    private final DietPlannerService dietPlannerService;
    private final Meal originalMeal;
    private final TextField mealNameField;
    private final ComboBox<MealType> mealTypeCombo;
    private final DatePicker datePicker;
    private final Spinner<Integer> hourSpinner;
    private final Spinner<Integer> minuteSpinner;
    private final ListView<FoodItem> selectedFoodsListView;
    private final Label nutritionSummaryLabel;
    private final List<FoodItem> selectedFoods;

    public EditMealDialog(DietPlannerService dietPlannerService, Meal meal) {
        this.dietPlannerService = dietPlannerService;
        this.originalMeal = meal;
        this.selectedFoods = new ArrayList<>(meal.getFoodItems());
        
        setTitle("Edit Meal");
        setHeaderText("Edit meal: " + meal.getName());
        
        // Initialize components with existing values
        mealNameField = new TextField(meal.getName());
        
        mealTypeCombo = new ComboBox<>(FXCollections.observableArrayList(MealType.values()));
        mealTypeCombo.setValue(meal.getType());
        
        datePicker = new DatePicker(meal.getDateTime().toLocalDate());
        
        hourSpinner = new Spinner<>(0, 23, meal.getDateTime().getHour());
        hourSpinner.setPrefWidth(60);
        
        minuteSpinner = new Spinner<>(0, 59, meal.getDateTime().getMinute());
        minuteSpinner.setPrefWidth(60);
        
        selectedFoodsListView = new ListView<>();
        selectedFoodsListView.setPrefHeight(200);
        selectedFoodsListView.setCellFactory(listView -> new FoodItemListCell());
        
        nutritionSummaryLabel = new Label();
        
        // Create the dialog content
        VBox content = createDialogContent();
        getDialogPane().setContent(content);
        
        // Add buttons
        getDialogPane().getButtonTypes().addAll(ButtonType.OK, ButtonType.CANCEL);
        
        // Enable/disable OK button based on input
        Button okButton = (Button) getDialogPane().lookupButton(ButtonType.OK);
        okButton.disableProperty().bind(
            mealNameField.textProperty().isEmpty()
        );
        
        // Set result converter
        setResultConverter(dialogButton -> {
            if (dialogButton == ButtonType.OK) {
                return createUpdatedMeal();
            }
            return null;
        });
        
        // Initialize data
        updateFoodListView();
        updateNutritionSummary();
        
        // Initialize modality
        initModality(Modality.APPLICATION_MODAL);
    }
    
    private VBox createDialogContent() {
        VBox content = new VBox(15);
        content.setPadding(new Insets(20));
        content.setPrefWidth(500);
        
        // Meal basic info
        GridPane basicInfoGrid = new GridPane();
        basicInfoGrid.setHgap(10);
        basicInfoGrid.setVgap(10);
        
        basicInfoGrid.add(new Label("Meal Name:"), 0, 0);
        basicInfoGrid.add(mealNameField, 1, 0);
        
        basicInfoGrid.add(new Label("Meal Type:"), 0, 1);
        basicInfoGrid.add(mealTypeCombo, 1, 1);
        
        basicInfoGrid.add(new Label("Date:"), 0, 2);
        basicInfoGrid.add(datePicker, 1, 2);
        
        HBox timeBox = new HBox(5);
        timeBox.setAlignment(Pos.CENTER_LEFT);
        timeBox.getChildren().addAll(
            hourSpinner, 
            new Label(":"), 
            minuteSpinner
        );
        basicInfoGrid.add(new Label("Time:"), 0, 3);
        basicInfoGrid.add(timeBox, 1, 3);
        
        // Food selection section
        Label foodSectionLabel = new Label("Food Items");
        foodSectionLabel.getStyleClass().add("section-header");
        
        Button editFoodButton = new Button("Edit Food Items");
        editFoodButton.setOnAction(e -> showFoodSelectionDialog());
        
        HBox foodHeaderBox = new HBox(10);
        foodHeaderBox.setAlignment(Pos.CENTER_LEFT);
        foodHeaderBox.getChildren().addAll(foodSectionLabel, editFoodButton);
        
        Button removeFoodButton = new Button("Remove Selected");
        removeFoodButton.setOnAction(e -> removeSelectedFood());
        removeFoodButton.disableProperty().bind(
            selectedFoodsListView.getSelectionModel().selectedItemProperty().isNull()
        );
        
        // Nutrition summary
        Label nutritionLabel = new Label("Nutrition Summary");
        nutritionLabel.getStyleClass().add("section-header");
        
        content.getChildren().addAll(
            basicInfoGrid,
            new Separator(),
            foodHeaderBox,
            selectedFoodsListView,
            removeFoodButton,
            new Separator(),
            nutritionLabel,
            nutritionSummaryLabel
        );
        
        return content;
    }
    
    private void showFoodSelectionDialog() {
        FoodSelectionDialog foodDialog = new FoodSelectionDialog(dietPlannerService);
        
        // Pre-select existing foods
        foodDialog.setPreSelectedFoods(selectedFoods);
        
        Optional<List<FoodItem>> result = foodDialog.showAndWait();
        
        if (result.isPresent()) {
            selectedFoods.clear();
            selectedFoods.addAll(result.get());
            updateFoodListView();
            updateNutritionSummary();
        }
    }
    
    private void removeSelectedFood() {
        FoodItem selectedFood = selectedFoodsListView.getSelectionModel().getSelectedItem();
        if (selectedFood != null) {
            selectedFoods.remove(selectedFood);
            updateFoodListView();
            updateNutritionSummary();
        }
    }
    
    private void updateFoodListView() {
        ObservableList<FoodItem> observableList = FXCollections.observableArrayList(selectedFoods);
        selectedFoodsListView.setItems(observableList);
    }
    
    private void updateNutritionSummary() {
        if (selectedFoods.isEmpty()) {
            nutritionSummaryLabel.setText("No items selected");
            return;
        }
        
        double totalCalories = selectedFoods.stream().mapToDouble(FoodItem::getCalories).sum();
        double totalProtein = selectedFoods.stream().mapToDouble(FoodItem::getProtein).sum();
        double totalCarbs = selectedFoods.stream().mapToDouble(FoodItem::getCarbs).sum();
        double totalFat = selectedFoods.stream().mapToDouble(FoodItem::getFat).sum();
        
        String summary = String.format(
            "Total: %s | %s",
            FormatUtils.formatCalories(totalCalories),
            FormatUtils.formatNutritionSummary(totalProtein, totalCarbs, totalFat)
        );
        
        nutritionSummaryLabel.setText(summary);
    }
    
    private Meal createUpdatedMeal() {
        String mealName = mealNameField.getText().trim();
        MealType mealType = mealTypeCombo.getValue();
        
        LocalDateTime dateTime = datePicker.getValue().atTime(
            hourSpinner.getValue(), 
            minuteSpinner.getValue()
        );
        
        // Create new meal with the original ID
        return new Meal(
            originalMeal.getId(),
            mealName,
            dateTime,
            new ArrayList<>(selectedFoods),
            mealType
        );
    }
    
    /**
     * Custom list cell for displaying food items
     */
    private static class FoodItemListCell extends ListCell<FoodItem> {
        @Override
        protected void updateItem(FoodItem item, boolean empty) {
            super.updateItem(item, empty);
            
            if (empty || item == null) {
                setText(null);
                setGraphic(null);
            } else {
                VBox cellContent = new VBox(3);
                
                Label nameLabel = new Label(item.getName());
                nameLabel.setStyle("-fx-font-weight: bold;");
                
                Label detailsLabel = new Label(String.format(
                    "%s | %s | %s",
                    item.getServingSize(),
                    FormatUtils.formatCalories(item.getCalories()),
                    FormatUtils.formatNutritionSummary(item.getProtein(), item.getCarbs(), item.getFat())
                ));
                detailsLabel.setStyle("-fx-text-fill: #666666; -fx-font-size: 11px;");
                
                cellContent.getChildren().addAll(nameLabel, detailsLabel);
                setGraphic(cellContent);
                setText(null);
            }
        }
    }
}
