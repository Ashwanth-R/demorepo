package com.sivasuryaa.fooddietplanner.model;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Enumeration representing different diet goals
 */
public enum DietGoal {
    WEIGHT_LOSS("Weight Loss", "Reduce calorie intake for sustainable weight loss", -500),
    WEIGHT_GAIN("Weight Gain", "Increase calorie intake for healthy weight gain", 500),
    MAINTENANCE("Maintenance", "Maintain current weight with balanced nutrition", 0),
    MUSCLE_GAIN("Muscle Gain", "High protein intake for muscle building", 300);

    private final String displayName;
    private final String description;
    private final int calorieAdjustment;

    DietGoal(String displayName, String description, int calorieAdjustment) {
        this.displayName = displayName;
        this.description = description;
        this.calorieAdjustment = calorieAdjustment;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getDescription() {
        return description;
    }

    public int getCalorieAdjustment() {
        return calorieAdjustment;
    }

    @JsonCreator
    public static DietGoal fromString(@JsonProperty("goal") String goal) {
        for (DietGoal dg : DietGoal.values()) {
            if (dg.name().equalsIgnoreCase(goal) || 
                dg.displayName.equalsIgnoreCase(goal)) {
                return dg;
            }
        }
        return MAINTENANCE; // default fallback
    }

    @Override
    public String toString() {
        return displayName;
    }
}
