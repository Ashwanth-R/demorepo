package com.sivasuryaa.fooddietplanner.model;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import javafx.scene.paint.Color;

/**
 * Enumeration representing different food categories
 */
public enum FoodCategory {
    PROTEIN("Protein", "#FF6B6B"),
    VEGETABLES("Vegetables", "#4ECDC4"), 
    FRUITS("Fruits", "#45B7D1"),
    GRAINS("Grains", "#96CEB4"),
    DAIRY("Dairy", "#FFEAA7"),
    NUTS("Nuts & Seeds", "#DDA0DD"),
    BEVERAGES("Beverages", "#74B9FF"),
    SNACKS("Snacks", "#FDCB6E");

    private final String displayName;
    private final String colorHex;

    FoodCategory(String displayName, String colorHex) {
        this.displayName = displayName;
        this.colorHex = colorHex;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getColorHex() {
        return colorHex;
    }

    public Color getColor() {
        return Color.web(colorHex);
    }

    public String getIcon() {
        return switch (this) {
            case PROTEIN -> "🥩";
            case VEGETABLES -> "🥬";
            case FRUITS -> "🍎";
            case GRAINS -> "🌾";
            case DAIRY -> "🥛";
            case NUTS -> "🥜";
            case BEVERAGES -> "☕";
            case SNACKS -> "🍿";
        };
    }

    @JsonCreator
    public static FoodCategory fromString(@JsonProperty("category") String category) {
        for (FoodCategory fc : FoodCategory.values()) {
            if (fc.name().equalsIgnoreCase(category) || 
                fc.displayName.equalsIgnoreCase(category)) {
                return fc;
            }
        }
        return SNACKS; // default fallback
    }

    @Override
    public String toString() {
        return displayName;
    }
}
