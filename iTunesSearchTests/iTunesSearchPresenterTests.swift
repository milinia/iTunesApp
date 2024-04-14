//
//  iTunesSearchPresenterTests.swift
//  iTunesSearchTests
//
//  Created by Evelina on 04.04.2024.
//

import XCTest
@testable import iTunesSearch

final class iTunesSearchPresenterTests: XCTestCase {
    
    private var presenter: SearchPresenter!
    private var imageServiceMock: ImageServiceMock!
    private var searchServiceMock: SearchServiceMock!
    private var searchViewMock: SearchViewMock!
    private var coreDataService: CoreDataServiceMock!

    override func setUpWithError() throws {
        try super.setUpWithError()
        imageServiceMock = ImageServiceMock()
        searchServiceMock = SearchServiceMock()
        searchViewMock = SearchViewMock()
        coreDataService = CoreDataServiceMock()
        presenter = SearchPresenter(coreDataService: coreDataService,
                                    searchService: searchServiceMock,
                                    imageService: imageServiceMock)
        presenter.view = searchViewMock
    }

    override func tearDownWithError() throws {
        imageServiceMock = nil
        searchServiceMock = nil
        searchViewMock = nil
        presenter = nil
    }

    @MainActor
    func testNetworkError() throws {
        //given
        searchServiceMock.isFailureResponse = true
        //when
        presenter.userInputedRequest(request: "", filters: nil)
        let expectation = XCTestExpectation(description: "Search request completion")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 5.0)
        //then
        XCTAssertTrue(searchViewMock.errorWasShown)
    }
    
    @MainActor
    func testNetworkCorrect() throws {
        //given
        searchServiceMock.isFailureResponse = false
        //when
        presenter.userInputedRequest(request: "", filters: nil)
        let expectation = XCTestExpectation(description: "Search request completion")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 5.0)
        //then
        XCTAssertFalse(searchViewMock.errorWasShown)
    }
}
