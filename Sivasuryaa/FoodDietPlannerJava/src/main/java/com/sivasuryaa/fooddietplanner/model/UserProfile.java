package com.sivasuryaa.fooddietplanner.model;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Model class representing user profile information and diet preferences
 */
public class UserProfile {
    private String name;
    private int age;
    private double weight; // in kg
    private double height; // in cm
    private ActivityLevel activityLevel;
    private DietGoal dietGoal;
    private double targetWeight; // in kg
    private String gender; // for more accurate BMR calculation

    // Default constructor
    public UserProfile() {
        this.name = "";
        this.age = 25;
        this.weight = 70.0;
        this.height = 170.0;
        this.activityLevel = ActivityLevel.MODERATE;
        this.dietGoal = DietGoal.MAINTENANCE;
        this.targetWeight = 70.0;
        this.gender = "Male";
    }

    @JsonCreator
    public UserProfile(@JsonProperty("name") String name,
                      @JsonProperty("age") int age,
                      @JsonProperty("weight") double weight,
                      @JsonProperty("height") double height,
                      @JsonProperty("activityLevel") ActivityLevel activityLevel,
                      @JsonProperty("dietGoal") DietGoal dietGoal,
                      @JsonProperty("targetWeight") double targetWeight,
                      @JsonProperty("gender") String gender) {
        this.name = name != null ? name : "";
        this.age = age;
        this.weight = weight;
        this.height = height;
        this.activityLevel = activityLevel != null ? activityLevel : ActivityLevel.MODERATE;
        this.dietGoal = dietGoal != null ? dietGoal : DietGoal.MAINTENANCE;
        this.targetWeight = targetWeight;
        this.gender = gender != null ? gender : "Male";
    }

    // Getters
    public String getName() { return name; }
    public int getAge() { return age; }
    public double getWeight() { return weight; }
    public double getHeight() { return height; }
    public ActivityLevel getActivityLevel() { return activityLevel; }
    public DietGoal getDietGoal() { return dietGoal; }
    public double getTargetWeight() { return targetWeight; }
    public String getGender() { return gender; }

    // Setters
    public void setName(String name) { this.name = name; }
    public void setAge(int age) { this.age = age; }
    public void setWeight(double weight) { this.weight = weight; }
    public void setHeight(double height) { this.height = height; }
    public void setActivityLevel(ActivityLevel activityLevel) { this.activityLevel = activityLevel; }
    public void setDietGoal(DietGoal dietGoal) { this.dietGoal = dietGoal; }
    public void setTargetWeight(double targetWeight) { this.targetWeight = targetWeight; }
    public void setGender(String gender) { this.gender = gender; }

    // Calculated properties

    /**
     * Calculate BMR (Basal Metabolic Rate) using Mifflin-St Jeor Equation
     * @return BMR in calories per day
     */
    public double getBMR() {
        // Mifflin-St Jeor Equation
        double bmr = 10 * weight + 6.25 * height - 5 * age;
        
        // Add gender-specific adjustment
        if ("Male".equalsIgnoreCase(gender)) {
            bmr += 5;
        } else {
            bmr -= 161;
        }
        
        return bmr;
    }

    /**
     * Calculate daily calorie goal based on BMR, activity level, and diet goal
     * @return daily calorie goal
     */
    public double getDailyCalorieGoal() {
        double bmrWithActivity = getBMR() * activityLevel.getMultiplier();
        return bmrWithActivity + dietGoal.getCalorieAdjustment();
    }

    /**
     * Calculate BMI (Body Mass Index)
     * @return BMI value
     */
    public double getBMI() {
        double heightInMeters = height / 100.0;
        return weight / (heightInMeters * heightInMeters);
    }

    /**
     * Get BMI category description
     * @return BMI category as string
     */
    public String getBMICategory() {
        double bmi = getBMI();
        if (bmi < 18.5) {
            return "Underweight";
        } else if (bmi < 25) {
            return "Normal";
        } else if (bmi < 30) {
            return "Overweight";
        } else {
            return "Obese";
        }
    }

    /**
     * Calculate recommended daily protein intake
     * @return protein in grams
     */
    public double getRecommendedProtein() {
        // 1.6g per kg body weight for general health
        // Adjust based on diet goal
        double baseProtein = weight * 1.6;
        
        if (dietGoal == DietGoal.MUSCLE_GAIN) {
            baseProtein = weight * 2.0; // Higher protein for muscle gain
        }
        
        return baseProtein;
    }

    /**
     * Calculate weight difference from target
     * @return weight difference (positive = need to gain, negative = need to lose)
     */
    public double getWeightDifferenceFromTarget() {
        return targetWeight - weight;
    }

    @Override
    public String toString() {
        return String.format("%s - %d years, %.1f kg, %.0f cm", 
                           name.isEmpty() ? "User" : name, age, weight, height);
    }

    // Builder pattern for easy construction
    public static class Builder {
        private String name = "";
        private int age = 25;
        private double weight = 70.0;
        private double height = 170.0;
        private ActivityLevel activityLevel = ActivityLevel.MODERATE;
        private DietGoal dietGoal = DietGoal.MAINTENANCE;
        private double targetWeight = 70.0;
        private String gender = "Male";

        public Builder name(String name) { this.name = name; return this; }
        public Builder age(int age) { this.age = age; return this; }
        public Builder weight(double weight) { this.weight = weight; return this; }
        public Builder height(double height) { this.height = height; return this; }
        public Builder activityLevel(ActivityLevel activityLevel) { this.activityLevel = activityLevel; return this; }
        public Builder dietGoal(DietGoal dietGoal) { this.dietGoal = dietGoal; return this; }
        public Builder targetWeight(double targetWeight) { this.targetWeight = targetWeight; return this; }
        public Builder gender(String gender) { this.gender = gender; return this; }

        public UserProfile build() {
            return new UserProfile(name, age, weight, height, activityLevel, dietGoal, targetWeight, gender);
        }
    }

    public static Builder builder() {
        return new Builder();
    }
}
