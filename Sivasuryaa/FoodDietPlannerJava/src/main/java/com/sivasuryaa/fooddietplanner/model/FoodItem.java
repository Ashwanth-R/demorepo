package com.sivasuryaa.fooddietplanner.model;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.Objects;
import java.util.UUID;

/**
 * Model class representing a food item with nutritional information
 */
public class FoodItem {
    private final String id;
    private String name;
    private double calories;
    private double protein;
    private double carbs;
    private double fat;
    private double fiber;
    private String servingSize;
    private FoodCategory category;

    // Default constructor for Jackson
    public FoodItem() {
        this.id = UUID.randomUUID().toString();
    }

    @JsonCreator
    public FoodItem(@JsonProperty("id") String id,
                    @JsonProperty("name") String name,
                    @JsonProperty("calories") double calories,
                    @JsonProperty("protein") double protein,
                    @JsonProperty("carbs") double carbs,
                    @JsonProperty("fat") double fat,
                    @JsonProperty("fiber") double fiber,
                    @JsonProperty("servingSize") String servingSize,
                    @JsonProperty("category") FoodCategory category) {
        this.id = id != null ? id : UUID.randomUUID().toString();
        this.name = name;
        this.calories = calories;
        this.protein = protein;
        this.carbs = carbs;
        this.fat = fat;
        this.fiber = fiber;
        this.servingSize = servingSize;
        this.category = category;
    }

    public FoodItem(String name, double calories, double protein, double carbs, 
                   double fat, double fiber, String servingSize, FoodCategory category) {
        this(null, name, calories, protein, carbs, fat, fiber, servingSize, category);
    }

    // Getters
    public String getId() { return id; }
    public String getName() { return name; }
    public double getCalories() { return calories; }
    public double getProtein() { return protein; }
    public double getCarbs() { return carbs; }
    public double getFat() { return fat; }
    public double getFiber() { return fiber; }
    public String getServingSize() { return servingSize; }
    public FoodCategory getCategory() { return category; }

    // Setters
    public void setName(String name) { this.name = name; }
    public void setCalories(double calories) { this.calories = calories; }
    public void setProtein(double protein) { this.protein = protein; }
    public void setCarbs(double carbs) { this.carbs = carbs; }
    public void setFat(double fat) { this.fat = fat; }
    public void setFiber(double fiber) { this.fiber = fiber; }
    public void setServingSize(String servingSize) { this.servingSize = servingSize; }
    public void setCategory(FoodCategory category) { this.category = category; }

    // Calculated properties
    public double getTotalMacros() {
        return protein + carbs + fat;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        FoodItem foodItem = (FoodItem) o;
        return Objects.equals(id, foodItem.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    @Override
    public String toString() {
        return String.format("%s (%s) - %.0f cal", name, servingSize, calories);
    }

    // Builder pattern for easy construction
    public static class Builder {
        private String name;
        private double calories;
        private double protein;
        private double carbs;
        private double fat;
        private double fiber;
        private String servingSize;
        private FoodCategory category;

        public Builder name(String name) { this.name = name; return this; }
        public Builder calories(double calories) { this.calories = calories; return this; }
        public Builder protein(double protein) { this.protein = protein; return this; }
        public Builder carbs(double carbs) { this.carbs = carbs; return this; }
        public Builder fat(double fat) { this.fat = fat; return this; }
        public Builder fiber(double fiber) { this.fiber = fiber; return this; }
        public Builder servingSize(String servingSize) { this.servingSize = servingSize; return this; }
        public Builder category(FoodCategory category) { this.category = category; return this; }

        public FoodItem build() {
            return new FoodItem(name, calories, protein, carbs, fat, fiber, servingSize, category);
        }
    }

    public static Builder builder() {
        return new Builder();
    }
}
