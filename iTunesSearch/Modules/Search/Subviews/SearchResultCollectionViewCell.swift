//
//  SearchResultCollectionViewCell.swift
//  iTunesSearch
//
//  Created by Evelina on 06.04.2024.
//

import Foundation
import UIKit

final class SearchResultCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private constants
    private enum UIConstants {
        static let vStackSpacing: CGFloat = 6
        static let typeImageRadius: CGFloat = 40
    }
    
    // MARK: - UI properties
    lazy var previewImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var typeImage: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, 
                                                  width: UIConstants.typeImageRadius,
                                                  height: UIConstants.typeImageRadius))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        imageView.tintColor = .black
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var artistLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .white
        label.textAlignment = .center
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.0
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        previewImage.image = nil
        nameLabel.text = nil
        artistLabel.text = nil
    }
    // MARK: - Public functions
    func contigure(searchResult: Result) {
        artistLabel.text = searchResult.artistName
        if let price = searchResult.trackPrice {
            priceLabel.text = String(format: "%.2f", price) + " " + (searchResult.currency ?? "")
        } else {
            priceLabel.isHidden = true
        }
        if searchResult.trackName != nil {
            nameLabel.text = searchResult.trackName
        } else {
            nameLabel.text = searchResult.collectionName
        }
        typeImage.image = searchResult.wrapperType?.icon
    }
    
    func setImage(image: UIImage) {
        previewImage.image = image
    }
       
       // MARK: - Private functions
    private func initialize() {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        vStack.alignment = .leading
        vStack.clipsToBounds = true
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.spacing = UIConstants.vStackSpacing
        clipsToBounds = true
        [previewImage, nameLabel, artistLabel, priceLabel].forEach({vStack.addArrangedSubview($0)})
        previewImage.addSubview(typeImage)
        addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            vStack.topAnchor.constraint(equalTo: self.topAnchor),
            vStack.widthAnchor.constraint(equalTo: self.widthAnchor),
            
            previewImage.widthAnchor.constraint(equalTo: vStack.widthAnchor),
            previewImage.heightAnchor.constraint(equalTo: vStack.widthAnchor),
            
            artistLabel.widthAnchor.constraint(equalTo: vStack.widthAnchor),
            nameLabel.widthAnchor.constraint(equalTo: vStack.widthAnchor),
            
            priceLabel.widthAnchor.constraint(equalToConstant: 100),
            priceLabel.heightAnchor.constraint(equalToConstant: 20),
            
            typeImage.widthAnchor.constraint(equalToConstant: UIConstants.typeImageRadius),
            typeImage.heightAnchor.constraint(equalToConstant: UIConstants.typeImageRadius),
            typeImage.bottomAnchor.constraint(equalTo: previewImage.bottomAnchor, constant: -10),
            typeImage.trailingAnchor.constraint(equalTo: previewImage.trailingAnchor, constant: -10),
        ])
    }
}
