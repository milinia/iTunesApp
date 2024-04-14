//
//  SearchHistoryCollectionViewCell.swift
//  iTunesSearch
//
//  Created by Evelina on 05.04.2024.
//

import Foundation
import UIKit
 
final class SearchHistoryCollectionViewCell: UICollectionViewCell {
    
    var requestText: String = ""
    
    // MARK: - Private constants
    private enum UIConstants {
        static let hStackSpacing: CGFloat = 6
    }
    
    // MARK: - UI properties
    private lazy var clockIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "clock.arrow.circlepath")
        imageView.tintColor = UIColor.lightGray
        return imageView
    }()
    
    private lazy var searchRequestLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
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
    
    // MARK: - Override methods
    override func prepareForReuse() {
        searchRequestLabel.text = nil
    }
    
    // MARK: - Public functions
    func contigure(searchRequest: String) {
        searchRequestLabel.text = searchRequest
        requestText = searchRequest
    }
       
       // MARK: - Private functions
    private func initialize() {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.distribution = .fill
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.spacing = UIConstants.hStackSpacing
        [clockIcon, searchRequestLabel].forEach({hStack.addArrangedSubview($0)})
        addSubview(hStack)
        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            hStack.heightAnchor.constraint(equalTo: self.heightAnchor),
            hStack.topAnchor.constraint(equalTo: self.topAnchor),
            hStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
