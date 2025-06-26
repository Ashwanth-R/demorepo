import SwiftUI

struct AppDashboard: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    Text("Welcome Back!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    // Summary Cards
                    HStack(spacing: 16) {
                        DashboardCard(title: "Tasks", count: 12, color: .blue)
                        DashboardCard(title: "Messages", count: 5, color: .green)
                    }
                    .padding(.horizontal)

                    // Navigation Buttons
                    VStack(spacing: 16) {
                        NavigationLink(destination: TaskListView()) {
                            DashboardButton(title: "View Tasks", backgroundColor: .blue)
                        }
                        NavigationLink(destination: MessagesView()) {
                            DashboardButton(title: "View Messages", backgroundColor: .green)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Dashboard")
        }
    }
}

struct DashboardCard: View {
    let title: String
    let count: Int
    let color: Color

    var body: some View {
        VStack {
            Text("\(count)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(width: 150, height: 100)
        .background(color)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

struct DashboardButton: View {
    let title: String
    let backgroundColor: Color

    var body: some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

// Dummy Views for Navigation
struct TaskListView: View {
    var body: some View {
        Text("Task List")
            .font(.largeTitle)
    }
}

struct MessagesView: View {
    var body: some View {
        Text("Messages")
            .font(.largeTitle)
    }
}

#Preview {
    AppDashboard()
}
