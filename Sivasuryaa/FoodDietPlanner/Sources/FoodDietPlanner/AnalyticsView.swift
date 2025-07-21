import SwiftUI
import Charts

struct AnalyticsView: View {
    @EnvironmentObject var dietManager: DietPlannerManager
    @State private var selectedTimeframe: Timeframe = .week
    @State private var selectedMetric: Metric = .calories
    
    enum Timeframe: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case threeMonths = "3 Months"
    }
    
    enum Metric: String, CaseIterable {
        case calories = "Calories"
        case protein = "Protein"
        case carbs = "Carbohydrates"
        case fat = "Fat"
        case meals = "Meals"
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Controls
                VStack(spacing: 16) {
                    HStack {
                        Text("Analytics")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    
                    HStack {
                        Picker("Timeframe", selection: $selectedTimeframe) {
                            ForEach(Timeframe.allCases, id: \.self) { timeframe in
                                Text(timeframe.rawValue).tag(timeframe)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        Spacer()
                        
                        Picker("Metric", selection: $selectedMetric) {
                            ForEach(Metric.allCases, id: \.self) { metric in
                                Text(metric.rawValue).tag(metric)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
                .padding()
                .background(Color(.controlBackgroundColor))
                .cornerRadius(16)
                
                // Chart Card
                ChartCard(
                    timeframe: selectedTimeframe,
                    metric: selectedMetric
                )
                
                // Statistics Cards
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    StatisticsCard(title: "Average Daily Intake", timeframe: selectedTimeframe)
                    StreakCard(timeframe: selectedTimeframe)
                    TopFoodsCard(timeframe: selectedTimeframe)
                    NutritionBalanceCard(timeframe: selectedTimeframe)
                }
            }
            .padding()
        }
    }
}

struct ChartCard: View {
    @EnvironmentObject var dietManager: DietPlannerManager
    let timeframe: AnalyticsView.Timeframe
    let metric: AnalyticsView.Metric
    
    private var chartData: [DayData] {
        let days = daysForTimeframe()
        return days.map { date in
            let mealsForDay = dietManager.mealsForDate(date)
            
            let value: Double
            switch metric {
            case .calories:
                value = mealsForDay.reduce(0) { $0 + $1.totalCalories }
            case .protein:
                value = mealsForDay.reduce(0) { $0 + $1.totalProtein }
            case .carbs:
                value = mealsForDay.reduce(0) { $0 + $1.totalCarbs }
            case .fat:
                value = mealsForDay.reduce(0) { $0 + $1.totalFat }
            case .meals:
                value = Double(mealsForDay.count)
            }
            
            return DayData(date: date, value: value)
        }
    }
    
    private var chartColor: Color {
        switch metric {
        case .calories: return .orange
        case .protein: return .red
        case .carbs: return .blue
        case .fat: return .yellow
        case .meals: return .green
        }
    }
    
    private var unit: String {
        switch metric {
        case .calories: return "cal"
        case .protein, .carbs, .fat: return "g"
        case .meals: return ""
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.title2)
                    .foregroundColor(chartColor)
                Text("\(metric.rawValue) Trend")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            if chartData.allSatisfy({ $0.value == 0 }) {
                VStack {
                    Image(systemName: "chart.line.downtrend.xyaxis")
                        .font(.system(size: 60))
                        .foregroundColor(.gray.opacity(0.5))
                    Text("No data available")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                    Text("Start logging meals to see trends")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .frame(height: 200)
                .frame(maxWidth: .infinity)
            } else {
                Chart(chartData) { dayData in
                    LineMark(
                        x: .value("Date", dayData.date),
                        y: .value(metric.rawValue, dayData.value)
                    )
                    .foregroundStyle(chartColor)
                    .lineStyle(StrokeStyle(lineWidth: 3))
                    
                    AreaMark(
                        x: .value("Date", dayData.date),
                        y: .value(metric.rawValue, dayData.value)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [chartColor.opacity(0.3), chartColor.opacity(0.1)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                .frame(height: 200)
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisValueLabel("\(Int(value.as(Double.self) ?? 0))\(unit)")
                            .font(.caption)
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day, count: timeframe == .week ? 1 : 7)) { value in
                        AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                            .font(.caption)
                    }
                }
            }
        }
        .padding()
        .background(Color(.controlBackgroundColor))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private func daysForTimeframe() -> [Date] {
        let calendar = Calendar.current
        let endDate = Date()
        
        let numberOfDays: Int
        switch timeframe {
        case .week:
            numberOfDays = 7
        case .month:
            numberOfDays = 30
        case .threeMonths:
            numberOfDays = 90
        }
        
        return (0..<numberOfDays).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: -dayOffset, to: endDate)
        }.reversed()
    }
}

struct DayData: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

struct StatisticsCard: View {
    @EnvironmentObject var dietManager: DietPlannerManager
    let title: String
    let timeframe: AnalyticsView.Timeframe
    
    private var averageCalories: Double {
        let days = getDaysForTimeframe()
        let totalCalories = days.reduce(0) { total, date in
            total + dietManager.mealsForDate(date).reduce(0) { $0 + $1.totalCalories }
        }
        return days.isEmpty ? 0 : totalCalories / Double(days.count)
    }
    
    private var averageMeals: Double {
        let days = getDaysForTimeframe()
        let totalMeals = days.reduce(0) { total, date in
            total + dietManager.mealsForDate(date).count
        }
        return days.isEmpty ? 0 : Double(totalMeals) / Double(days.count)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .font(.title3)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Calories")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(averageCalories))")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                }
                
                HStack {
                    Text("Meals")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(averageMeals, specifier: "%.1f")")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(Color(.controlBackgroundColor))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
    }
    
    private func getDaysForTimeframe() -> [Date] {
        let calendar = Calendar.current
        let endDate = Date()
        
        let numberOfDays: Int
        switch timeframe {
        case .week:
            numberOfDays = 7
        case .month:
            numberOfDays = 30
        case .threeMonths:
            numberOfDays = 90
        }
        
        return (0..<numberOfDays).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: -dayOffset, to: endDate)
        }
    }
}

struct StreakCard: View {
    @EnvironmentObject var dietManager: DietPlannerManager
    let timeframe: AnalyticsView.Timeframe
    
    private var currentStreak: Int {
        let calendar = Calendar.current
        var streak = 0
        var currentDate = Date()
        
        while streak < 365 { // Max reasonable streak
            let mealsForDay = dietManager.mealsForDate(currentDate)
            if mealsForDay.isEmpty {
                break
            }
            streak += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDate) else {
                break
            }
            currentDate = previousDay
        }
        
        return streak
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "flame.fill")
                    .font(.title3)
                    .foregroundColor(.orange)
                Text("Current Streak")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(currentStreak)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                
                Text("days of logging")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if currentStreak > 0 {
                Text("Keep it up! 🔥")
                    .font(.caption)
                    .foregroundColor(.orange)
                    .fontWeight(.medium)
            }
        }
        .padding()
        .background(Color(.controlBackgroundColor))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
    }
}

struct TopFoodsCard: View {
    @EnvironmentObject var dietManager: DietPlannerManager
    let timeframe: AnalyticsView.Timeframe
    
    private var topFoods: [(name: String, count: Int)] {
        let days = getDaysForTimeframe()
        var foodCounts: [String: Int] = [:]
        
        for day in days {
            let mealsForDay = dietManager.mealsForDate(day)
            for meal in mealsForDay {
                for food in meal.foodItems {
                    foodCounts[food.name] = (foodCounts[food.name] ?? 0) + 1
                }
            }
        }
        
        return foodCounts.sorted { $0.value > $1.value }
            .prefix(3)
            .map { (name: $0.key, count: $0.value) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "star.fill")
                    .font(.title3)
                    .foregroundColor(.yellow)
                Text("Top Foods")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            if topFoods.isEmpty {
                Text("No data yet")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(Array(topFoods.enumerated()), id: \.offset) { index, food in
                        HStack {
                            Text("\(index + 1).")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(width: 20, alignment: .leading)
                            
                            Text(food.name)
                                .font(.caption)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Text("\(food.count)x")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.yellow)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.controlBackgroundColor))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
    }
    
    private func getDaysForTimeframe() -> [Date] {
        let calendar = Calendar.current
        let endDate = Date()
        
        let numberOfDays: Int
        switch timeframe {
        case .week:
            numberOfDays = 7
        case .month:
            numberOfDays = 30
        case .threeMonths:
            numberOfDays = 90
        }
        
        return (0..<numberOfDays).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: -dayOffset, to: endDate)
        }
    }
}

struct NutritionBalanceCard: View {
    @EnvironmentObject var dietManager: DietPlannerManager
    let timeframe: AnalyticsView.Timeframe
    
    private var nutritionData: (protein: Double, carbs: Double, fat: Double) {
        let days = getDaysForTimeframe()
        var totalProtein: Double = 0
        var totalCarbs: Double = 0
        var totalFat: Double = 0
        
        for day in days {
            let mealsForDay = dietManager.mealsForDate(day)
            totalProtein += mealsForDay.reduce(0) { $0 + $1.totalProtein }
            totalCarbs += mealsForDay.reduce(0) { $0 + $1.totalCarbs }
            totalFat += mealsForDay.reduce(0) { $0 + $1.totalFat }
        }
        
        return (protein: totalProtein, carbs: totalCarbs, fat: totalFat)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.pie.fill")
                    .font(.title3)
                    .foregroundColor(.purple)
                Text("Nutrition Balance")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            let data = nutritionData
            let total = data.protein + data.carbs + data.fat
            
            if total > 0 {
                VStack(spacing: 6) {
                    MacroBalanceRow(
                        name: "Protein",
                        value: data.protein,
                        percentage: data.protein / total,
                        color: .red
                    )
                    MacroBalanceRow(
                        name: "Carbs",
                        value: data.carbs,
                        percentage: data.carbs / total,
                        color: .orange
                    )
                    MacroBalanceRow(
                        name: "Fat",
                        value: data.fat,
                        percentage: data.fat / total,
                        color: .yellow
                    )
                }
            } else {
                Text("No nutrition data")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.controlBackgroundColor))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
    }
    
    private func getDaysForTimeframe() -> [Date] {
        let calendar = Calendar.current
        let endDate = Date()
        
        let numberOfDays: Int
        switch timeframe {
        case .week:
            numberOfDays = 7
        case .month:
            numberOfDays = 30
        case .threeMonths:
            numberOfDays = 90
        }
        
        return (0..<numberOfDays).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: -dayOffset, to: endDate)
        }
    }
}

struct MacroBalanceRow: View {
    let name: String
    let value: Double
    let percentage: Double
    let color: Color
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            
            Text(name)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text("\(Int(percentage * 100))%")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(color)
        }
    }
}
