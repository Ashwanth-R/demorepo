import SwiftUI

struct CounterView: View {
    @State private var count = 0

    var body: some View {
        VStack(spacing: 20) {
            Text("Count: \(count)")
                .font(.largeTitle)
            HStack {
                Button(action: { count -= 1 }) {
                    Text("-")
                        .font(.title)
                        .frame(width: 50, height: 50)
                        .background(Color.red.opacity(0.7))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                Button(action: { count += 1 }) {
                    Text("+")
                        .font(.title)
                        .frame(width: 50, height: 50)
                        .background(Color.green.opacity(0.7))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
        }
        .padding()
    }
}

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView()
    }
}
