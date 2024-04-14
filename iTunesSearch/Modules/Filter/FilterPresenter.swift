//
//  FilterPresenter.swift
//  iTunesSearch
//
//  Created by Evelina on 07.04.2024.
//

import Foundation

protocol FilterPresenterProtocol {
    func closeFilters()
}

final class FilterPresenter: FilterPresenterProtocol {
    // MARK: - Public Properties
    var didTapToCloseFilters: (() -> Void)?
    
    // MARK: - Implementation FilterPresenterProtocol
    func closeFilters() {
        didTapToCloseFilters?()
    }
}
