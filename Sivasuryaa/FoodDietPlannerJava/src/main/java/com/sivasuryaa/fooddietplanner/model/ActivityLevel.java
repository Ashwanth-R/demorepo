package com.sivasuryaa.fooddietplanner.model;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Enumeration representing different activity levels
 */
public enum ActivityLevel {
    SEDENTARY("Sedentary", "Little to no exercise", 1.2),
    LIGHT("Light", "Light exercise 1-3 days/week", 1.375),
    MODERATE("Moderate", "Moderate exercise 3-5 days/week", 1.55),
    ACTIVE("Active", "Hard exercise 6-7 days/week", 1.725),
    VERY_ACTIVE("Very Active", "Very hard exercise, physical job", 1.9);

    private final String displayName;
    private final String description;
    private final double multiplier;

    ActivityLevel(String displayName, String description, double multiplier) {
        this.displayName = displayName;
        this.description = description;
        this.multiplier = multiplier;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getDescription() {
        return description;
    }

    public double getMultiplier() {
        return multiplier;
    }

    @JsonCreator
    public static ActivityLevel fromString(@JsonProperty("activityLevel") String activityLevel) {
        for (ActivityLevel al : ActivityLevel.values()) {
            if (al.name().equalsIgnoreCase(activityLevel) || 
                al.displayName.equalsIgnoreCase(activityLevel)) {
                return al;
            }
        }
        return MODERATE; // default fallback
    }

    @Override
    public String toString() {
        return displayName;
    }
}
