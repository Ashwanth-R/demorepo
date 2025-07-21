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
        Song(title: "Uptown Funk", artist: "Mark Ronson ft. Bruno Mars"),
        Song(title: "Peaches", artist: "Justin Bieber"),
        Song(title: "Sunflower", artist: "Post Malone"),
        Song(title: "Happier", artist: "Marshmello"),
        Song(title: "Memories", artist: "Maroon 5")
    ]
    @State private var selectedSong: Song?
    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Music Picker")
                    .font(.largeTitle)
                    .bold()
                TextField("Search songs or artists", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                List(filteredSongs) { song in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(song.title)
                                .font(.headline)
                            Text(song.artist)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        if selectedSong?.id == song.id {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedSong = song
                    }
                }
                .listStyle(InsetGroupedListStyle())
                if let song = selectedSong {
                    VStack(spacing: 8) {
                        Text("Selected Song")
                            .font(.headline)
                        Text("\(song.title) by \(song.artist)")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
            }
            .padding(.vertical)
            .navigationTitle("Music Picker")
        }
    var filteredSongs: [Song] {
        if searchText.isEmpty {
            return songs
        } else {
            return songs.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.artist.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    }
}

struct MusicPickerView_Previews: PreviewProvider {
    static var previews: some View {
        MusicPickerView()
    }
}
