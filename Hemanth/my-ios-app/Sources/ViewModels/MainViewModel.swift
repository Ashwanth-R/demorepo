// filepath: /my-ios-app/my-ios-app/Sources/ViewModels/MainViewModel.swift
import Combine

class MainViewModel: ObservableObject {
    @Published var data: [String] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        // Simulate a data fetch with Combine
        Just(["Item 1", "Item 2", "Item 3"])
            .delay(for: .seconds(1), scheduler: RunLoop.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] fetchedData in
                self?.data = fetchedData
            })
            .store(in: &cancellables)
    }
}