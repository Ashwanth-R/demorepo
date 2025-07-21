import SwiftUI

struct Song: Identifiable {
    let id = UUID()
    let title: String
    let artist: String
}

struct MusicPickerView: View {
    @State private var songs: [Song] = [
        Song(title: "Shape of You", artist: "Ed Sheeran"),
        Song(title: "Blinding Lights", artist: "The Weeknd"),
        Song(title: "Levitating", artist: "Dua Lipa"),
        Song(title: "Bad Guy", artist: "Billie Eilish"),
        Song(title: "Uptown Funk", artist: "Mark Ronson ft. Bruno Mars")
    ]
    @State private var selectedSong: Song?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Pick a Song")
                    .font(.headline)
                List(songs) { song in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(song.title)
                                .font(.body)
                            Text(song.artist)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        if selectedSong?.id == song.id {
                            Image(systemName: "music.note")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedSong = song
                    }
                }
                if let song = selectedSong {
                    Text("Selected: \(song.title) by \(song.artist)")
                        .font(.title3)
                        .padding()
                }
            }
            .navigationTitle("Music Picker")
        }
    }
}

struct MusicPickerView_Previews: PreviewProvider {
    static var previews: some View {
        MusicPickerView()
    }
}
