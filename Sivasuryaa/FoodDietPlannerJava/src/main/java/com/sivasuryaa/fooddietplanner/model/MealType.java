package com.sivasuryaa.fooddietplanner.model;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Enumeration representing different meal types
 */
public enum MealType {
    BREAKFAST("Breakfast", "🌅", "#FF9F43"),
    LUNCH("Lunch", "☀️", "#FDD835"), 
    DINNER("Dinner", "🌙", "#8E44AD"),
    SNACK("Snack", "⭐", "#E91E63");

    private final String displayName;
    private final String icon;
    private final String colorHex;

    MealType(String displayName, String icon, String colorHex) {
        this.displayName = displayName;
        this.icon = icon;
        this.colorHex = colorHex;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getIcon() {
        return icon;
    }

    public String getColorHex() {
        return colorHex;
    }

    @JsonCreator
    public static MealType fromString(@JsonProperty("mealType") String mealType) {
        for (MealType mt : MealType.values()) {
            if (mt.name().equalsIgnoreCase(mealType) || 
                mt.displayName.equalsIgnoreCase(mealType)) {
                return mt;
            }
        }
        return SNACK; // default fallback
    }

    @Override
    public String toString() {
        return displayName;
    }
}
