//
//  SearchPresenter.swift
//  iTunesSearch
//
//  Created by Evelina on 04.04.2024.
//

import Foundation
import UIKit

protocol SearchPresenterProtocol {
    func viewDidLoaded()
    func userInputedRequest(request: String, filters: FilterData?)
    func getLastFiveRequests() -> [String]
    func getSearchRequestResult() -> SearchResponse
    func inputedTextUpdated(text: String)
    func fetchImage(url: String, competionHandler: @escaping (UIImage) -> Void)
    func goToFilterScreen(filters: FilterData?)
    func goToDetailScreen(data: Result, image: UIImage)
}

final class SearchPresenter: SearchPresenterProtocol {
    // MARK: - Private Properties
    private let coreDataService: SearchRequestCoreDataServiceProtocol
    private let searchService: SearchServiceProtocol
    private let imageService: ImageServiceProtocol
    private var lastRequests: [String] = []
    private var filteredRequests: [String] = []
    private var isFiltered: Bool = false
    private var searchResult: SearchResponse?
    
    // MARK: - Public Properties
    weak var view: SearchViewProtocol?
    var didTapToOpenFilters: ((FilterData?, FilterViewDelegateProtocol?) -> Void)?
    var didTapToOpenDetail: ((Result, UIImage) -> Void)?
    
    // MARK: - Init
    init(coreDataService: SearchRequestCoreDataServiceProtocol, searchService: SearchServiceProtocol, imageService: ImageServiceProtocol) {
        self.coreDataService = coreDataService
        self.searchService = searchService
        self.imageService = imageService
    }
    
    // MARK: - Implementation SearchPresenterProtocol
    func viewDidLoaded() {
        if let requests = coreDataService.fetchSearchRequestData() {
            view?.showSearchHistory()
            self.lastRequests = requests.compactMap({$0.request})
        }
    }
    
    func getLastFiveRequests() -> [String] {
        if isFiltered {
            return filteredRequests
        } else {
            return Array(lastRequests.prefix(5))
        }
    }
    
    func inputedTextUpdated(text: String) {
        if text == "" {
            isFiltered = false
        } else {
            filteredRequests = lastRequests.filter { $0.localizedCaseInsensitiveContains(text) }
            isFiltered = true
        }
        view?.showSearchHistory()
    }
    
    @MainActor
    func userInputedRequest(request: String, filters: FilterData?) {
        saveSearchRequest(request: request)
        Task {
            do {
                if let filtersData = filters {
                    var filterString = ""
                    if filtersData.isExplicitContentIncluded {
                        filterString.append("explicit=No")
                    }
                    if filtersData.choosenLanguage == .jp {
                        filterString.append("&lang=ja_jp")
                    }
                    if filtersData.choosenEntity != .all {
                        filterString.append("&entity=\(filtersData.choosenEntity)")
                    }
                    searchResult = try await searchService.searchWithFilters(text: request, filters: filterString)
                } else {
                    searchResult = try await searchService.search(text: request)
                }
                view?.showSearchResult()
            } catch {
                view?.showError(error: "Ой! Что-то пошло не так")
            }
        }
    }
    
    func getSearchRequestResult() -> SearchResponse {
        return searchResult ?? SearchResponse(results: [])
    }
    
    @MainActor
    func fetchImage(url: String, competionHandler: @escaping (UIImage) -> Void) {
        Task {
            do {
                let image = try await imageService.fetchImage(url: url)
                competionHandler(image)
            } catch {
                view?.showError(error: "Ой! Что-то пошло не так")
            }
        }
    }
    
    func goToFilterScreen(filters: FilterData?) {
        didTapToOpenFilters?(filters, view)
    }
    
    func goToDetailScreen(data: Result, image: UIImage) {
        didTapToOpenDetail?(data, image)
    }
    
    // MARK: - Private functions
    private func saveSearchRequest(request: String) {
        if request != "" && !(lastRequests.contains(request)) {
            coreDataService.saveSearchRequest(request: request)
        }
    }
}
