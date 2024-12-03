//
//  RavenNewsTests.swift
//  RavenNewsTests
//
//  Created by MaurZac on 28/11/24.
//

import XCTest
import Combine
@testable import RavenNews

final class RavenNewsTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
        private var mockRepository: MockHomeNewsRepository!
        private var viewModel: HomeNewsViewModel!
        
        override func setUpWithError() throws {
            try super.setUpWithError()
            cancellables = []
        }

        override func tearDownWithError() throws {
            cancellables = nil
            mockRepository = nil
            viewModel = nil
            try super.tearDownWithError()
        }
        
        
    func testFetchNewsSuccess() throws {
        let mockArticles = [
            Articles(
                uri: "uri1",
                url: "url1",
                id: 1,
                assetID: 1001,
                source: .newYorkTimes,
                publishedDate: "2024-12-01",
                updated: "2024-12-02",
                section: "World",
                subsection: "Politics",
                nytdsection: "World",
                adxKeywords: "news,world",
                column: nil,
                byline: "John Doe",
                type: .article,
                title: "Breaking News 1",
                abstract: "Description 1",
                desFacet: [],
                orgFacet: [],
                perFacet: [],
                geoFacet: [],
                media: [],
                etaID: 123
            ),
            Articles(
                uri: "uri2",
                url: "url2",
                id: 2,
                assetID: 1002,
                source: .newYorkTimes,
                publishedDate: "2024-12-02",
                updated: "2024-12-03",
                section: "Business",
                subsection: "Economy",
                nytdsection: "Business",
                adxKeywords: "economy,finance",
                column: nil,
                byline: "Jane Smith",
                type: .article,
                title: "Breaking News 2",
                abstract: "Description 2",
                desFacet: [],
                orgFacet: [],
                perFacet: [],
                geoFacet: [],
                media: [],
                etaID: 456
            )
        ]

        mockRepository = MockNewsRepository(mockData: .success(mockArticles))
        viewModel = HomeNewsViewModel(apiService: mockRepository)

        // Configurar la expectativa
        let expectation = XCTestExpectation(description: "Fetch popular news succeeds")

        viewModel.$articles
            .dropFirst()
            .sink { articles in
                XCTAssertEqual(articles.count, 2)
                XCTAssertEqual(articles.first?.title, "Breaking News 1")
                XCTAssertEqual(articles.last?.title, "Breaking News 2")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.fetchNews()

        wait(for: [expectation], timeout: 2.0)
    }



        
        // Test for loading state
        func testLoadingState() throws {
            mockRepository = MockNewsRepository(mockData: .success([]))
            viewModel = HomeNewsViewModel(repository: mockRepository)
            
            let expectation = XCTestExpectation(description: "Loading state updates correctly")
            var states: [Bool] = []
            
            viewModel.$isLoading
                .sink { isLoading in
                    states.append(isLoading)
                    if states.count == 2 {
                        expectation.fulfill()
                    }
                }
                .store(in: &cancellables)
            
            viewModel.fetchNews()
            wait(for: [expectation], timeout: 1.0)
            XCTAssertEqual(states, [true, false])
        }
        
        func testFetchNewsFailure() throws {
            mockRepository = MockHomeNewsRepository(mockData: .failure(NSError(domain: "TestError", code: 1, userInfo: nil)))
            viewModel = HomeNewsViewModel(apiService: mockRepository)
            
            let expectation = XCTestExpectation(description: "Error state updates correctly")
            
            viewModel.$error
                .dropFirst()
                .sink { error in
                    XCTAssertNotNil(error)
                    XCTAssertEqual(error?.localizedDescription, "The operation couldn’t be completed. (TestError error 1.)")
                    expectation.fulfill()
                }
                .store(in: &cancellables)
            
            viewModel.fetchNews()
            wait(for: [expectation], timeout: 1.0)
        }

}
