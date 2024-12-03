//
//  HomeNewsViewModel.swift
//  RavenNews
//
//  Created by MaurZac on 29/11/24.
//
import Combine

final class HomeNewsViewModel: ObservableObject {
    
    @Published var articles: [Articles] = []
    @Published var isLoading: Bool = false
    
    private var apiService: ApiService
    private var cancellables = Set<AnyCancellable>()
    
    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    func fetchNews() {
        isLoading = true
        
        let endpoint = "https://api.nytimes.com/svc/mostpopular/v2/viewed/1.json?api-key=qTl6HA9lEk9bHwEMNSrdjRAceMnSqQEZ"
        
        apiService.request(url: endpoint)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error)")
                case .finished:
                    break
                }
                self?.isLoading = false
            } receiveValue: { [weak self] (news: News) in
                self?.articles = news.results
            }
            .store(in: &cancellables) 
    }
}

