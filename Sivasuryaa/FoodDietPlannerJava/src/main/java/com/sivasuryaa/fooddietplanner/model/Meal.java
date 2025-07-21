package com.sivasuryaa.fooddietplanner.model;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.UUID;

/**
 * Model class representing a meal containing multiple food items
 */
public class Meal {
    private final String id;
    private String name;
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime dateTime;
    private List<FoodItem> foodItems;
    private MealType type;

    // Default constructor for Jackson
    public Meal() {
        this.id = UUID.randomUUID().toString();
        this.foodItems = new ArrayList<>();
    }

    @JsonCreator
    public Meal(@JsonProperty("id") String id,
                @JsonProperty("name") String name,
                @JsonProperty("dateTime") LocalDateTime dateTime,
                @JsonProperty("foodItems") List<FoodItem> foodItems,
                @JsonProperty("type") MealType type) {
        this.id = id != null ? id : UUID.randomUUID().toString();
        this.name = name;
        this.dateTime = dateTime;
        this.foodItems = foodItems != null ? new ArrayList<>(foodItems) : new ArrayList<>();
        this.type = type;
    }

    public Meal(String name, LocalDateTime dateTime, MealType type) {
        this(null, name, dateTime, new ArrayList<>(), type);
    }

    // Getters
    public String getId() { return id; }
    public String getName() { return name; }
    public LocalDateTime getDateTime() { return dateTime; }
    public List<FoodItem> getFoodItems() { return new ArrayList<>(foodItems); }
    public MealType getType() { return type; }

    // Setters
    public void setName(String name) { this.name = name; }
    public void setDateTime(LocalDateTime dateTime) { this.dateTime = dateTime; }
    public void setFoodItems(List<FoodItem> foodItems) { 
        this.foodItems = foodItems != null ? new ArrayList<>(foodItems) : new ArrayList<>(); 
    }
    public void setType(MealType type) { this.type = type; }

    // Food item management
    public void addFoodItem(FoodItem foodItem) {
        if (foodItem != null) {
            this.foodItems.add(foodItem);
        }
    }

    public void removeFoodItem(FoodItem foodItem) {
        this.foodItems.remove(foodItem);
    }

    public void removeFoodItem(String foodItemId) {
        this.foodItems.removeIf(item -> item.getId().equals(foodItemId));
    }

    // Calculated nutrition totals
    public double getTotalCalories() {
        return foodItems.stream().mapToDouble(FoodItem::getCalories).sum();
    }

    public double getTotalProtein() {
        return foodItems.stream().mapToDouble(FoodItem::getProtein).sum();
    }

    public double getTotalCarbs() {
        return foodItems.stream().mapToDouble(FoodItem::getCarbs).sum();
    }

    public double getTotalFat() {
        return foodItems.stream().mapToDouble(FoodItem::getFat).sum();
    }

    public double getTotalFiber() {
        return foodItems.stream().mapToDouble(FoodItem::getFiber).sum();
    }

    public int getFoodItemCount() {
        return foodItems.size();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Meal meal = (Meal) o;
        return Objects.equals(id, meal.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    @Override
    public String toString() {
        return String.format("%s (%s) - %d items, %.0f cal", 
                           name, type.getDisplayName(), foodItems.size(), getTotalCalories());
    }

    // Builder pattern for easy construction
    public static class Builder {
        private String name;
        private LocalDateTime dateTime;
        private List<FoodItem> foodItems = new ArrayList<>();
        private MealType type;

        public Builder name(String name) { this.name = name; return this; }
        public Builder dateTime(LocalDateTime dateTime) { this.dateTime = dateTime; return this; }
        public Builder foodItems(List<FoodItem> foodItems) { 
            this.foodItems = new ArrayList<>(foodItems); 
            return this; 
        }
        public Builder addFoodItem(FoodItem foodItem) { 
            this.foodItems.add(foodItem); 
            return this; 
        }
        public Builder type(MealType type) { this.type = type; return this; }

        public Meal build() {
            return new Meal(null, name, dateTime, foodItems, type);
        }
    }

    public static Builder builder() {
        return new Builder();
    }
}
