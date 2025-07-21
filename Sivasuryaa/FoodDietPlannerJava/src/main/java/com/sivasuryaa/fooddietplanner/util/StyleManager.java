package com.sivasuryaa.fooddietplanner.util;

import javafx.scene.Scene;

/**
 * Utility class for managing application styles and themes
 */
public class StyleManager {
    
    private static final String MAIN_STYLESHEET = "/styles/main.css";
    
    /**
     * Apply the main theme to a scene
     * @param scene the scene to apply the theme to
     */
    public static void applyTheme(Scene scene) {
        try {
            String stylesheet = StyleManager.class.getResource(MAIN_STYLESHEET).toExternalForm();
            scene.getStylesheets().add(stylesheet);
        } catch (Exception e) {
            System.err.println("Could not load stylesheet: " + e.getMessage());
            // Apply default inline styles if CSS file is not found
            applyDefaultStyles(scene);
        }
    }
    
    /**
     * Apply default inline styles when CSS file is not available
     * @param scene the scene to apply styles to
     */
    private static void applyDefaultStyles(Scene scene) {
        // Set a default background color
        scene.getRoot().setStyle("-fx-background-color: #f5f5f5;");
    }
    
    /**
     * Get color hex string for a food category
     * @param categoryName the category name
     * @return hex color string
     */
    public static String getCategoryColor(String categoryName) {
        return switch (categoryName.toLowerCase()) {
            case "protein" -> "#FF6B6B";
            case "vegetables" -> "#4ECDC4";
            case "fruits" -> "#45B7D1";
            case "grains" -> "#96CEB4";
            case "dairy" -> "#FFEAA7";
            case "nuts & seeds", "nuts" -> "#DDA0DD";
            case "beverages" -> "#74B9FF";
            case "snacks" -> "#FDCB6E";
            default -> "#95A5A6";
        };
    }
    
    /**
     * Get style class for different UI components
     * @param component the component type
     * @return CSS class name
     */
    public static String getComponentStyle(String component) {
        return switch (component.toLowerCase()) {
            case "card" -> "card";
            case "metric-card" -> "metric-card";
            case "nutrition-label" -> "nutrition-label";
            case "progress-bar" -> "custom-progress-bar";
            case "button-primary" -> "button-primary";
            case "button-secondary" -> "button-secondary";
            default -> "";
        };
    }
}
