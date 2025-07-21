package com.sivasuryaa.fooddietplanner;

import com.sivasuryaa.fooddietplanner.controller.MainController;
import com.sivasuryaa.fooddietplanner.service.DietPlannerService;
import com.sivasuryaa.fooddietplanner.util.StyleManager;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.stage.Stage;

import java.io.IOException;
import java.util.Objects;

/**
 * Main application class for the Food Diet Planner
 * A comprehensive nutrition tracking and diet management application
 */
public class FoodDietPlannerApplication extends Application {

    private static final String APP_TITLE = "Food Diet Planner";
    private static final String APP_ICON = "/icons/app-icon.png";
    private static final String MAIN_FXML = "/fxml/main.fxml";
    
    private DietPlannerService dietPlannerService;

    @Override
    public void start(Stage primaryStage) {
        try {
            // Initialize services
            dietPlannerService = new DietPlannerService();
            
            // Load FXML
            FXMLLoader loader = new FXMLLoader(getClass().getResource(MAIN_FXML));
            Scene scene = new Scene(loader.load());
            
            // Get controller and inject dependencies
            MainController controller = loader.getController();
            controller.setDietPlannerService(dietPlannerService);
            
            // Apply styling
            StyleManager.applyTheme(scene);
            
            // Configure primary stage
            primaryStage.setTitle(APP_TITLE);
            primaryStage.setScene(scene);
            primaryStage.setMinWidth(1200);
            primaryStage.setMinHeight(800);
            
            // Set application icon
            try {
                Image icon = new Image(Objects.requireNonNull(
                    getClass().getResourceAsStream(APP_ICON)));
                primaryStage.getIcons().add(icon);
            } catch (Exception e) {
                System.err.println("Could not load application icon: " + e.getMessage());
            }
            
            // Center the window
            primaryStage.centerOnScreen();
            
            // Show the window
            primaryStage.show();
            
            // Initialize controller after showing
            controller.initialize();
            
        } catch (IOException e) {
            e.printStackTrace();
            System.err.println("Failed to load the main application window: " + e.getMessage());
            System.exit(1);
        }
    }

    @Override
    public void stop() {
        // Cleanup resources
        if (dietPlannerService != null) {
            dietPlannerService.saveAllData();
        }
        System.out.println("Application stopped gracefully");
    }

    /**
     * Main entry point for the application
     * 
     * @param args command line arguments
     */
    public static void main(String[] args) {
        // Set system properties for better rendering
        System.setProperty("prism.lcdtext", "false");
        System.setProperty("prism.text", "t2k");
        
        launch(args);
    }
}
