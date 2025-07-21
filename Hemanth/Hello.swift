import SwiftUI

struct ContentView: View {
    @State private var message = "Hello, SwiftUI!"

    var body: some View {
        VStack(spacing: 20) {
            Text(message)
                .font(.largeTitle)
                .padding()
            Button("Change Message") {
                message = "You tapped the button!"
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}