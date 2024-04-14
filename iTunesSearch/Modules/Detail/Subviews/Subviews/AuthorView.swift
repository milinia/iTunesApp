//
//  AuthorView.swift
//  iTunesSearch
//
//  Created by Evelina on 13.04.2024.
//

import Foundation
import UIKit

class AuthorView: UIView {
    
    // MARK: - Private constants
    private enum UIConstants {
        static let personImageDiameter: CGFloat = 50
        static let personIconDiameter: CGFloat = 30
        static let authorLabelFontSize: CGFloat = 13
        static let linkButtonTextFontSize: CGFloat = 15
        static let viewCornerRadius: CGFloat = 5
        static let stackViewSpacing: CGFloat = 6
    }
    
    private var data: ArtistData?
    
    // MARK: - UI properties
    lazy var personImage: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, 
                                                  width: UIConstants.personIconDiameter,
                                                  height: UIConstants.personIconDiameter))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .black
        return imageView
    }()
    
    private lazy var personView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0,
                                        width: UIConstants.personImageDiameter,
                                        height: UIConstants.personImageDiameter))
        view.layer.cornerRadius = view.bounds.width / 2
        view.clipsToBounds = true
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: UIConstants.authorLabelFontSize)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var linkButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIConstants.linkButtonTextFontSize)
        button.setTitle("Подробнее об авторе", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(linkButtonTapped), for: .touchUpInside)
        return button
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
    func setAuthor(data: ArtistData) {
        self.data = data
        authorLabel.text = data.artistName
    }
    
    // MARK: - Button action
    @objc private func linkButtonTapped() {
        if let urlString = data?.artistLinkUrl,  let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    // MARK: - Private functions
    private func initialize() {
        self.layer.cornerRadius = UIConstants.viewCornerRadius
        backgroundColor = UIColor.systemGray5
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        vStack.alignment = .center
        vStack.clipsToBounds = true
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.spacing = UIConstants.stackViewSpacing
        [personView, authorLabel, linkButton].forEach({vStack.addArrangedSubview($0)})
        personView.addSubview(personImage)
        addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            personView.widthAnchor.constraint(equalToConstant: UIConstants.personImageDiameter),
            personView.heightAnchor.constraint(equalToConstant: UIConstants.personImageDiameter),
            
            personImage.centerXAnchor.constraint(equalTo: personView.centerXAnchor),
            personImage.centerYAnchor.constraint(equalTo: personView.centerYAnchor)
        ])
    }
}
