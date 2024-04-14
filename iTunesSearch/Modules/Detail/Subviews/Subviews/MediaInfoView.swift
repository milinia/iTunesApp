//
//  MediaInfoView.swift
//  iTunesSearch
//
//  Created by Evelina on 14.04.2024.
//

import Foundation
import UIKit

class MediaInfoView: UIView {
    // MARK: - Private constants
    private enum UIConstants {
        static let titlesFontSize: CGFloat = 20
        static let dataFontSize: CGFloat = 16
        static let viewCornerRadius: CGFloat = 40
        static let contentInset: CGFloat = 16
        static let lineHeightMultiplier: CGFloat = 0.6
        static let lineWidth: CGFloat = 2
        static let vStackViewSpacing: CGFloat = 6
    }
        
    // MARK: - Private UI properties
    private lazy var genreTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Жанр"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: UIConstants.titlesFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    private lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: UIConstants.dataFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var genreStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fill
        view.spacing = UIConstants.vStackViewSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    private lazy var durationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Длительность"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: UIConstants.titlesFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: UIConstants.dataFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var durationStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fill
        view.spacing = UIConstants.vStackViewSpacing
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var priceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Цена"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: UIConstants.titlesFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: UIConstants.dataFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fill
        view.spacing = UIConstants.vStackViewSpacing
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: CGRect())
        initialize()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Public functions
    func setData(data: Result) {
        if let duration = data.trackTimeMillis {
            durationLabel.text = TimeConverter.convertToMin(millis: duration)
        } else {
            durationStackView.isHidden = true
        }
        if let price = data.trackPrice {
            priceLabel.text = String(price)
        } else {
            if let price = data.collectionPrice {
                priceLabel.text = String(price)
            } else {
                priceStackView.isHidden = true
            }
        }
        if let genre = data.primaryGenreName {
            genreLabel.text = genre
        } else {
            genreStackView.isHidden = true
        }
    }
    
    // MARK: - Private functions
    private func initialize() {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.distribution = .fillEqually
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.clipsToBounds = true
        [genreStackView, durationStackView, priceStackView].forEach({hStack.addArrangedSubview($0)})
        [genreTitleLabel, genreLabel].forEach({genreStackView.addArrangedSubview($0)})
        [durationTitleLabel, durationLabel].forEach({durationStackView.addArrangedSubview($0)})
        [priceTitleLabel, priceLabel].forEach({priceStackView.addArrangedSubview($0)})
        addSubview(hStack)
        NSLayoutConstraint.activate([
            hStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            hStack.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
