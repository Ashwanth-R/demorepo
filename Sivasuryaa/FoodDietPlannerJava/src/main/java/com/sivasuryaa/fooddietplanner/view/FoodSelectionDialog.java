package com.sivasuryaa.fooddietplanner.view;

import com.sivasuryaa.fooddietplanner.model.FoodCategory;
import com.sivasuryaa.fooddietplanner.model.FoodItem;
import com.sivasuryaa.fooddietplanner.service.DietPlannerService;
import com.sivasuryaa.fooddietplanner.util.FormatUtils;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.collections.transformation.FilteredList;
import javafx.collections.transformation.SortedList;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.control.*;
import javafx.scene.control.cell.CheckBoxListCell;
import javafx.scene.layout.HBox;
import javafx.scene.layout.Priority;
import javafx.scene.layout.VBox;
import javafx.stage.Modality;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Dialog for selecting food items from the database
 */
public class FoodSelectionDialog extends Dialog<List<FoodItem>> {
    
    private final DietPlannerService dietPlannerService;
    private final TextField searchField;
    private final ComboBox<FoodCategory> categoryFilter;
    private final ListView<FoodItemSelection> foodListView;
    private final Label selectedCountLabel;
    private final Label nutritionSummaryLabel;
    private final ObservableList<FoodItemSelection> allFoodSelections;
    private final FilteredList<FoodItemSelection> filteredFoodSelections;
    
    public FoodSelectionDialog(DietPlannerService dietPlannerService) {
        this.dietPlannerService = dietPlannerService;
        
        setTitle("Select Food Items");
        setHeaderText("Choose food items for your meal");
        
        // Initialize components
        searchField = new TextField();
        searchField.setPromptText("Search foods...");
        
        categoryFilter = new ComboBox<>();
        categoryFilter.getItems().add(null); // "All Categories" option
        categoryFilter.getItems().addAll(FoodCategory.values());
        categoryFilter.setValue(null);
        categoryFilter.setPromptText("All Categories");
        
        foodListView = new ListView<>();
        foodListView.setPrefHeight(400);
        foodListView.setPrefWidth(500);
        
        selectedCountLabel = new Label();
        nutritionSummaryLabel = new Label();
        
        // Initialize data
        allFoodSelections = FXCollections.observableArrayList(
            foodItem -> new javafx.beans.Observable[] { foodItem.selectedProperty() }
        );
        
        // Load food items from service
        loadFoodItems();
        
        filteredFoodSelections = new FilteredList<>(allFoodSelections);
        SortedList<FoodItemSelection> sortedFoodSelections = new SortedList<>(filteredFoodSelections);
        sortedFoodSelections.comparatorProperty().bind(foodListView.comparatorProperty());
        
        foodListView.setItems(sortedFoodSelections);
        foodListView.setCellFactory(CheckBoxListCell.forListView(
            FoodItemSelection::selectedProperty,
            new FoodItemStringConverter()
        ));
        
        // Set up filtering
        setupFiltering();
        
        // Create content
        VBox content = createDialogContent();
        getDialogPane().setContent(content);
        
        // Add buttons
        getDialogPane().getButtonTypes().addAll(ButtonType.OK, ButtonType.CANCEL);
        
        // Set result converter
        setResultConverter(dialogButton -> {
            if (dialogButton == ButtonType.OK) {
                return getSelectedFoodItems();
            }
            return null;
        });
        
        // Update summary initially
        updateSummary();
        
        // Initialize modality
        initModality(Modality.APPLICATION_MODAL);
    }
    
    private void loadFoodItems() {
        List<FoodItem> foodItems = dietPlannerService.getAllFoodItems();
        
        List<FoodItemSelection> selections = foodItems.stream()
            .map(FoodItemSelection::new)
            .collect(Collectors.toList());
        
        allFoodSelections.setAll(selections);
    }
    
    private VBox createDialogContent() {
        VBox content = new VBox(15);
        content.setPadding(new Insets(20));
        
        // Search and filter section
        HBox searchBox = new HBox(10);
        searchBox.setAlignment(Pos.CENTER_LEFT);
        
        searchField.setPrefWidth(250);
        categoryFilter.setPrefWidth(150);
        
        Button addCustomButton = new Button("Add Custom Food");
        addCustomButton.setOnAction(e -> showAddCustomFoodDialog());
        
        searchBox.getChildren().addAll(
            new Label("Search:"), searchField,
            new Label("Category:"), categoryFilter,
            addCustomButton
        );
        
        // Food list section
        Label foodListLabel = new Label("Available Food Items");
        foodListLabel.getStyleClass().add("section-header");
        
        HBox selectionControls = new HBox(10);
        selectionControls.setAlignment(Pos.CENTER_LEFT);
        
        Button selectAllButton = new Button("Select All");
        selectAllButton.setOnAction(e -> selectAll(true));
        
        Button deselectAllButton = new Button("Deselect All");
        deselectAllButton.setOnAction(e -> selectAll(false));
        
        Button selectVisibleButton = new Button("Select Visible");
        selectVisibleButton.setOnAction(e -> selectVisible(true));
        
        selectionControls.getChildren().addAll(
            selectAllButton, deselectAllButton, selectVisibleButton
        );
        
        // Summary section
        Label summaryLabel = new Label("Selection Summary");
        summaryLabel.getStyleClass().add("section-header");
        
        VBox summaryBox = new VBox(5);
        summaryBox.getChildren().addAll(selectedCountLabel, nutritionSummaryLabel);
        
        content.getChildren().addAll(
            searchBox,
            new Separator(),
            foodListLabel,
            selectionControls,
            foodListView,
            new Separator(),
            summaryLabel,
            summaryBox
        );
        
        VBox.setVgrow(foodListView, Priority.ALWAYS);
        
        return content;
    }
    
    private void setupFiltering() {
        // Search field filtering
        searchField.textProperty().addListener((observable, oldValue, newValue) -> {
            updateFilter();
        });
        
        // Category filtering
        categoryFilter.valueProperty().addListener((observable, oldValue, newValue) -> {
            updateFilter();
        });
        
        // Listen for selection changes to update summary
        allFoodSelections.forEach(selection -> 
            selection.selectedProperty().addListener((obs, oldVal, newVal) -> updateSummary())
        );
    }
    
    private void updateFilter() {
        String searchText = searchField.getText();
        FoodCategory selectedCategory = categoryFilter.getValue();
        
        filteredFoodSelections.setPredicate(selection -> {
            FoodItem foodItem = selection.getFoodItem();
            
            // Category filter
            if (selectedCategory != null && foodItem.getCategory() != selectedCategory) {
                return false;
            }
            
            // Search filter
            if (searchText != null && !searchText.trim().isEmpty()) {
                String lowerCaseFilter = searchText.toLowerCase().trim();
                return foodItem.getName().toLowerCase().contains(lowerCaseFilter) ||
                       foodItem.getCategory().getDisplayName().toLowerCase().contains(lowerCaseFilter);
            }
            
            return true;
        });
    }
    
    private void selectAll(boolean selected) {
        allFoodSelections.forEach(selection -> selection.setSelected(selected));
        updateSummary();
    }
    
    private void selectVisible(boolean selected) {
        filteredFoodSelections.forEach(selection -> selection.setSelected(selected));
        updateSummary();
    }
    
    private void updateSummary() {
        List<FoodItem> selectedItems = getSelectedFoodItems();
        
        selectedCountLabel.setText(selectedItems.size() + " items selected");
        
        if (selectedItems.isEmpty()) {
            nutritionSummaryLabel.setText("No items selected");
            return;
        }
        
        double totalCalories = selectedItems.stream().mapToDouble(FoodItem::getCalories).sum();
        double totalProtein = selectedItems.stream().mapToDouble(FoodItem::getProtein).sum();
        double totalCarbs = selectedItems.stream().mapToDouble(FoodItem::getCarbs).sum();
        double totalFat = selectedItems.stream().mapToDouble(FoodItem::getFat).sum();
        
        String summary = String.format(
            "Total: %s | %s",
            FormatUtils.formatCalories(totalCalories),
            FormatUtils.formatNutritionSummary(totalProtein, totalCarbs, totalFat)
        );
        
        nutritionSummaryLabel.setText(summary);
    }
    
    private void showAddCustomFoodDialog() {
        // This would show a dialog to add custom food items
        // For now, we'll show a simple alert
        Alert alert = new Alert(Alert.AlertType.INFORMATION);
        alert.setTitle("Add Custom Food");
        alert.setHeaderText("Custom Food Feature");
        alert.setContentText("This feature allows you to add custom food items to the database. Implementation pending.");
        alert.showAndWait();
    }
    
    private List<FoodItem> getSelectedFoodItems() {
        return allFoodSelections.stream()
            .filter(FoodItemSelection::isSelected)
            .map(FoodItemSelection::getFoodItem)
            .collect(Collectors.toList());
    }
    
    /**
     * Pre-select food items that were already selected
     */
    public void setPreSelectedFoods(List<FoodItem> preSelectedFoods) {
        allFoodSelections.forEach(selection -> {
            boolean shouldBeSelected = preSelectedFoods.contains(selection.getFoodItem());
            selection.setSelected(shouldBeSelected);
        });
        updateSummary();
    }
    
    /**
     * Wrapper class for food items with selection state
     */
    public static class FoodItemSelection {
        private final FoodItem foodItem;
        private final javafx.beans.property.BooleanProperty selected;
        
        public FoodItemSelection(FoodItem foodItem) {
            this.foodItem = foodItem;
            this.selected = new javafx.beans.property.SimpleBooleanProperty(false);
        }
        
        public FoodItem getFoodItem() {
            return foodItem;
        }
        
        public javafx.beans.property.BooleanProperty selectedProperty() {
            return selected;
        }
        
        public boolean isSelected() {
            return selected.get();
        }
        
        public void setSelected(boolean selected) {
            this.selected.set(selected);
        }
    }
    
    /**
     * String converter for displaying food items in the list
     */
    private static class FoodItemStringConverter extends StringConverter<FoodItemSelection> {
        @Override
        public String toString(FoodItemSelection selection) {
            if (selection == null) {
                return "";
            }
            
            FoodItem item = selection.getFoodItem();
            return String.format(
                "%s (%s) - %s | %s",
                item.getName(),
                item.getServingSize(),
                FormatUtils.formatCalories(item.getCalories()),
                FormatUtils.formatNutritionSummary(item.getProtein(), item.getCarbs(), item.getFat())
            );
        }
        
        @Override
        public FoodItemSelection fromString(String string) {
            // Not used in this context
            return null;
        }
    }
}
