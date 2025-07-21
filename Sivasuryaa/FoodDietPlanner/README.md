# 🍎 Food Diet Planner for macOS

A comprehensive, native macOS application built with SwiftUI for tracking your daily nutrition, managing meals, and achieving your health goals.

## ✨ Features

### 📊 Dashboard
- **Real-time calorie tracking** with beautiful progress indicators
- **Macronutrient breakdown** with interactive pie charts
- **Today's meals overview** with quick add functionality
- **Personalized recommendations** based on your goals and intake

### 🍽️ Meal Management
- **Intuitive meal logging** with date navigation
- **Meal type categorization** (Breakfast, Lunch, Dinner, Snacks)
- **Detailed meal views** with complete nutrition breakdown
- **Meal duplication** for recurring favorites

### 🥗 Food Database
- **Comprehensive food database** with 18+ pre-loaded items
- **Smart search functionality** with category filtering
- **Detailed nutrition information** for each food item
- **Food categorization** (Protein, Vegetables, Fruits, Grains, etc.)

### 👤 Profile & Goals
- **Personal profile management** (age, weight, height, activity level)
- **Multiple diet goals** (Weight Loss, Weight Gain, Maintenance, Muscle Gain)
- **BMR calculation** using Mifflin-St Jeor Equation
- **Personalized calorie targets** based on goals and activity

### 📈 Analytics & Insights
- **Visual trend analysis** with interactive charts
- **Weekly, monthly, and 3-month views**
- **Nutrition balance tracking**
- **Streak counting** for motivation
- **Top foods identification**

### ⚙️ Advanced Features
- **Data persistence** with automatic saving
- **Data export** functionality
- **Settings management**
- **Attractive HIG-compliant UI** with proper spacing and typography

## 🚀 Getting Started

### Prerequisites

- **macOS 13.0+** (Ventura or later)
- **Xcode 14.0+** 
- **Swift 5.8+**

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd demorepo/Sivasuryaa/FoodDietPlanner
   ```

2. **Build the application:**
   ```bash
   swift build
   ```

3. **Run the application:**
   ```bash
   swift run FoodDietPlanner
   ```

### Alternative: Swift Package Manager

You can also open the `Package.swift` file directly in Xcode and run the application from there.

## 🏗️ Architecture

### Project Structure
```
FoodDietPlanner/
├── Package.swift                 # Swift Package configuration
├── Sources/FoodDietPlanner/      # Main source code
│   ├── FoodDietPlannerApp.swift # App entry point
│   ├── Models.swift             # Data models
│   ├── DietPlannerManager.swift # Data management
│   ├── ContentView.swift        # Main navigation
│   ├── DashboardView.swift      # Dashboard interface
│   ├── MealsView.swift          # Meal management
│   ├── AddMealView.swift        # Add meal interface
│   ├── FoodSearchView.swift     # Food search interface
│   ├── FoodDatabaseView.swift   # Food database browser
│   ├── MealDetailView.swift     # Detailed meal view
│   ├── ProfileView.swift        # User profile
│   ├── EditProfileView.swift    # Profile editing
│   ├── AnalyticsView.swift      # Analytics dashboard
│   └── SettingsView.swift       # App settings
├── Tests/FoodDietPlannerTests/   # Unit tests
└── README.md                     # This file
```

### Data Models

- **FoodItem**: Represents individual food items with nutrition data
- **Meal**: Groups food items by meal type and time
- **UserProfile**: Stores personal information and goals
- **FoodCategory**: Categorizes foods for better organization
- **MealType**: Defines breakfast, lunch, dinner, and snacks

### Key Components

- **DietPlannerManager**: Central data management with persistence
- **NavigationSplitView**: Modern macOS navigation pattern
- **Charts Framework**: Beautiful data visualization
- **UserDefaults**: Local data persistence

## 🎨 Design Philosophy

This application follows Apple's Human Interface Guidelines (HIG) with:

- **Native macOS design patterns**
- **Consistent spacing and typography**
- **Accessible color schemes**
- **Intuitive navigation**
- **Responsive layouts**

### UI Components Used

- ✅ NavigationSplitView for sidebar navigation
- ✅ LazyVGrid for responsive card layouts
- ✅ Charts for data visualization
- ✅ Sheets for modal presentations
- ✅ Context menus for additional actions
- ✅ Progress indicators for goal tracking
- ✅ Search bars with filtering
- ✅ Date pickers with navigation
- ✅ Form inputs with validation
- ✅ Alert dialogs for confirmations

## 📱 Usage Guide

### Setting Up Your Profile

1. Navigate to the **Profile** tab
2. Click **Edit** to configure:
   - Personal information (name, age, weight, height)
   - Activity level (sedentary to very active)
   - Diet goal (weight loss, gain, maintenance, muscle gain)
   - Target weight (if applicable)

### Adding Meals

1. Go to **Dashboard** or **Meals** tab
2. Click **Add Meal**
3. Enter meal details:
   - Meal name and type
   - Date and time
   - Food items from database
4. Review nutrition summary
5. Save the meal

### Tracking Progress

1. Check the **Dashboard** for daily overview
2. View **Analytics** for trends and insights
3. Monitor calorie progress with visual indicators
4. Review recommendations for optimization

### Managing Food Database

1. Browse the **Food Database** tab
2. Search and filter by category
3. View detailed nutrition information
4. Sort by different criteria

## 🧪 Testing

The application includes comprehensive unit tests covering:

- BMR and calorie calculations
- Meal nutrition totals
- Food search functionality
- Data management operations

Run tests with:
```bash
swift test
```

## 🔧 Configuration

### Customizing Food Database

Add new food items by modifying the `setupSampleFoodDatabase()` method in `DietPlannerManager.swift`:

```swift
FoodItem(
    name: "Your Food Name",
    calories: 100,
    protein: 10,
    carbs: 20,
    fat: 5,
    fiber: 3,
    servingSize: "100g",
    category: .protein,
    imageSystemName: "flame.fill"
)
```

### Adding New Food Categories

Extend the `FoodCategory` enum in `Models.swift`:

```swift
enum FoodCategory: String, CaseIterable, Codable {
    case newCategory = "New Category"
    // ... existing cases
    
    var color: Color {
        switch self {
        case .newCategory: return .purple
        // ... existing cases
        }
    }
}
```

## 📊 Data Persistence

The application automatically saves:
- User profile information
- All logged meals
- App preferences

Data is stored using UserDefaults with JSON encoding for reliability and portability.

## 🔒 Privacy

- **All data stays local** on your device
- **No network requests** are made
- **Export functionality** for data portability
- **Complete data reset** option available

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## 📋 Roadmap

Future enhancements could include:

- [ ] Recipe management
- [ ] Barcode scanning
- [ ] Integration with HealthKit
- [ ] Custom food database entries
- [ ] Meal planning calendar
- [ ] Export to CSV/PDF
- [ ] Dark mode optimization
- [ ] Keyboard shortcuts
- [ ] Widget support

## 📄 License

This project is available under the MIT License. See LICENSE file for details.

## 🙋‍♂️ Support

For questions, feature requests, or bug reports:

- Create an issue in the repository
- Email: support@example.com
- Documentation: Check the code comments and this README

## 🎯 Goals Achieved

This Food Diet Planner demonstrates:

✅ **Modern SwiftUI Architecture** with clean separation of concerns  
✅ **Native macOS Design** following Human Interface Guidelines  
✅ **Comprehensive Nutrition Tracking** with detailed analytics  
✅ **Data Persistence** with automatic saving and loading  
✅ **Interactive Charts** for visualizing progress  
✅ **Responsive Layout** adapting to different window sizes  
✅ **Accessibility Support** with proper labeling and navigation  
✅ **Professional Code Quality** with documentation and tests  

---

**Built with ❤️ using SwiftUI for macOS**
