package com.sivasuryaa.fooddietplanner.util;

import java.text.DecimalFormat;

/**
 * Utility class for formatting numbers and nutrition values
 */
public class FormatUtils {
    
    private static final DecimalFormat WHOLE_NUMBER_FORMAT = new DecimalFormat("#");
    private static final DecimalFormat ONE_DECIMAL_FORMAT = new DecimalFormat("#.#");
    private static final DecimalFormat TWO_DECIMAL_FORMAT = new DecimalFormat("#.##");
    
    /**
     * Format a calorie value to a readable string
     * @param calories the calorie value
     * @return formatted string with "cal" suffix
     */
    public static String formatCalories(double calories) {
        return WHOLE_NUMBER_FORMAT.format(calories) + " cal";
    }
    
    /**
     * Format a macro nutrient value (protein, carbs, fat) to a readable string
     * @param value the macro value in grams
     * @return formatted string with "g" suffix
     */
    public static String formatMacro(double value) {
        return ONE_DECIMAL_FORMAT.format(value) + "g";
    }
    
    /**
     * Format a weight value to a readable string
     * @param weight the weight in kg
     * @return formatted string with "kg" suffix
     */
    public static String formatWeight(double weight) {
        return ONE_DECIMAL_FORMAT.format(weight) + " kg";
    }
    
    /**
     * Format a height value to a readable string
     * @param height the height in cm
     * @return formatted string with "cm" suffix
     */
    public static String formatHeight(double height) {
        return WHOLE_NUMBER_FORMAT.format(height) + " cm";
    }
    
    /**
     * Format a BMI value to a readable string
     * @param bmi the BMI value
     * @return formatted BMI string
     */
    public static String formatBMI(double bmi) {
        return ONE_DECIMAL_FORMAT.format(bmi);
    }
    
    /**
     * Format a percentage value
     * @param percentage the percentage (0.0 to 1.0)
     * @return formatted percentage string
     */
    public static String formatPercentage(double percentage) {
        return WHOLE_NUMBER_FORMAT.format(percentage * 100) + "%";
    }
    
    /**
     * Format a percentage value with one decimal place
     * @param percentage the percentage (0.0 to 1.0)
     * @return formatted percentage string with one decimal
     */
    public static String formatPercentageDetailed(double percentage) {
        return ONE_DECIMAL_FORMAT.format(percentage * 100) + "%";
    }
    
    /**
     * Format a generic double value with appropriate precision
     * @param value the value to format
     * @return formatted string
     */
    public static String formatNumber(double value) {
        if (value == Math.floor(value)) {
            return WHOLE_NUMBER_FORMAT.format(value);
        } else {
            return TWO_DECIMAL_FORMAT.format(value);
        }
    }
    
    /**
     * Format a nutrition summary string
     * @param protein protein in grams
     * @param carbs carbs in grams
     * @param fat fat in grams
     * @return formatted summary like "P: 25g, C: 30g, F: 10g"
     */
    public static String formatNutritionSummary(double protein, double carbs, double fat) {
        return String.format("P: %s, C: %s, F: %s", 
                           formatMacro(protein), 
                           formatMacro(carbs), 
                           formatMacro(fat));
    }
    
    /**
     * Capitalize the first letter of a string
     * @param str the string to capitalize
     * @return capitalized string
     */
    public static String capitalize(String str) {
        if (str == null || str.isEmpty()) {
            return str;
        }
        return str.substring(0, 1).toUpperCase() + str.substring(1).toLowerCase();
    }
    
    /**
     * Truncate a string to a maximum length with ellipsis
     * @param str the string to truncate
     * @param maxLength the maximum length
     * @return truncated string
     */
    public static String truncate(String str, int maxLength) {
        if (str == null || str.length() <= maxLength) {
            return str;
        }
        return str.substring(0, maxLength - 3) + "...";
    }
}
