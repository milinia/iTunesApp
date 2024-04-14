//
//  DetailPresenter.swift
//  iTunesSearch
//
//  Created by Evelina on 04.04.2024.
//

import Foundation
import UIKit

protocol DetailPresenterProtocol {
    func fetchAuthorInfo(id: Int)
    func getAuthorWorks() -> [Result]
    func fetchImage(url: String, competionHandler: @escaping (UIImage) -> Void)
    func fetchAuthorFiveWorks(id: Int, entity: String)
}

final class DetailPresenter: DetailPresenterProtocol {
    
    private let lookupService: LookupServiceProtocol
    private let imageService: ImageServiceProtocol
    weak var view: DetailViewProtocol?
    var authorWorks: [Result] = []
    
    init(lookupService: LookupServiceProtocol, imageService: ImageServiceProtocol) {
        self.lookupService = lookupService
        self.imageService = imageService
    }
    
    @MainActor
    func fetchAuthorInfo(id: Int) {
        Task {
            do {
                let authorInfo = try await lookupService.lookupForArtist(id: id)
                view?.updateAuthorInfo(info: authorInfo)
            } catch {
                view?.showError(error: error.localizedDescription)
            }
        }
    }
    
    func getAuthorWorks() -> [Result] {
        return authorWorks
    }
    
    @MainActor
    func fetchImage(url: String, competionHandler: @escaping (UIImage) -> Void) {
        Task {
            do {
                let image = try await imageService.fetchImage(url: url)
                competionHandler(image)
            } catch {
                view?.showError(error: "Something went wrong!")
            }
        }
    }
    
    @MainActor
    func fetchAuthorFiveWorks(id: Int, entity: String) {
        Task {
            do {
                authorWorks = try await lookupService.lookupForArtistWorks(id: id,
                                                                           entity: entity).results
                authorWorks.removeFirst()
                view?.updateAuthorWorkCollectionView()
            } catch {
                view?.showError(error: error.localizedDescription)
            }
        }
    }
}
