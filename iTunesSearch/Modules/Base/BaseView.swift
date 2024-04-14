//
//  BaseView.swift
//  iTunesSearch
//
//  Created by Evelina on 05.04.2024.
//

protocol BaseViewProtocol {
    func showLoading()
    func showError(error: String)
    func showContent()
}
