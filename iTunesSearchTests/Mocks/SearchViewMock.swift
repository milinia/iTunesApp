//
//  SearchViewMock.swift
//  iTunesSearchTests
//
//  Created by Evelina on 14.04.2024.
//

import Foundation
@testable import iTunesSearch

class SearchViewMock: NSObject, SearchViewProtocol {
    
    var errorWasShown: Bool = false
    var loadingWasStarted: Bool = false
    var loadingWasFinished: Bool = false
    var searchHistoryShowing: Bool = false
    var searchResultShowing: Bool = false
    var filtersWasApplied: Bool = false
    var filter: FilterData?
    
    func showSearchHistory() {
        loadingWasFinished = true
        searchHistoryShowing = true
        searchResultShowing = false
    }
    
    func showSearchResult() {
        loadingWasFinished = true
        searchHistoryShowing = false
        searchResultShowing = true
    }
    
    func showLoading() {
        loadingWasStarted = true
    }
    
    func showError(error: String) {
        errorWasShown = true
    }
    
    func showContent() {}
    
    func userFilterSelected(filter: iTunesSearch.FilterData?) {
        filtersWasApplied = true
        self.filter = filter
    }
}
