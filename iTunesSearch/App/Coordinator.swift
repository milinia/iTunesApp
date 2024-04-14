//
//  Coordinator.swift
//  iTunesSearch
//
//  Created by Evelina on 04.04.2024.
//

import Foundation
import UIKit

final class Coordinator {
    private let navigationController: UINavigationController
    private let assembly: AssemblyProtocol
    
    init(navigationController: UINavigationController, assembly: AssemblyProtocol) {
        self.navigationController = navigationController
        self.assembly = assembly
    }
    
    func start() {
        let presenter = SearchPresenter(coreDataService: assembly.coreDataService,
                                        searchService: assembly.searchService, 
                                        imageService: assembly.imageService)
        let view = SearchViewController(presenter: presenter)
        presenter.view = view
        presenter.didTapToOpenFilters = openFilters
        presenter.didTapToOpenDetail = openDetail
        navigationController.viewControllers = [view]
    }
    
    func openFilters(filters: FilterData?, delegate: FilterViewDelegateProtocol?) {
        let presenter = FilterPresenter()
        presenter.didTapToCloseFilters = {
            self.navigationController.popViewController(animated: true)
        }
        let view = FilterViewController(presenter: presenter)
        view.delegate = delegate
        if let filters = filters {
            view.choosenFilters = filters
        }
        navigationController.pushViewController(view, animated: true)
    }
    
    func openDetail(data: Result, image: UIImage) {
        let presenter = DetailPresenter(lookupService: assembly.lookupService,
                                        imageService: assembly.imageService)
        let view = DetailViewController(presenter: presenter, data: data, image: image)
        presenter.view = view
        navigationController.pushViewController(view, animated: true)
    }
}
