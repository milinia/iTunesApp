//
//  DetailViewController.swift
//  iTunesSearch
//
//  Created by Evelina on 04.04.2024.
//

import Foundation
import UIKit

protocol DetailViewProtocol: NSObject, BaseViewProtocol {
    func updateAuthorInfo(info: ArtistData)
    func updateAuthorWorkCollectionView()
}

class DetailViewController: UIViewController, DetailViewProtocol {
    
    // MARK: - Private constants
    private enum UIConstants {
        static let contentInset: CGFloat = 16
        static let searchtextFieldCornerRadius: CGFloat = 15
        static let searchTextFieldHeight: CGFloat = 40
        static let searchRequestCellHeight: CGFloat = 30
        static let collectionViewHeight: CGFloat = 270
    }
    
    // MARK: - Private properties
    private var presenter: DetailPresenterProtocol
    private var data: Result
    private var image: UIImage

    // MARK: - Inits
    init(presenter: DetailPresenterProtocol, data: Result, image: UIImage) {
        self.presenter = presenter
        self.data = data
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI properties
    private lazy var previewImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var artistLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var linkButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitle("Узнать подробности", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(linkButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var containerView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var authorView: AuthorView = {
        let view = AuthorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var mediaInfoView: MediaInfoView = {
        let view = MediaInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var authorWorksCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        return collection
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.spacing = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackViewForImage: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.color = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var authorWorksTitle: UILabel = {
        let label = UILabel()
        label.text = "Другие работы автора"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupView()
        showContent()
        if let id = data.artistId {
            showLoading()
            presenter.fetchAuthorInfo(id: id)
            if let entity = data.kind?.artistWorkEntity {
                presenter.fetchAuthorFiveWorks(id: id, entity: entity)
            } else {
                authorWorksTitle.isHidden = true
                authorWorksCollectionView.isHidden = true
            }
        } else {
            authorView.isHidden = true
            authorWorksTitle.isHidden = true
            authorWorksCollectionView.isHidden = true
        }
    }
    
    
    // MARK: - Private methods
    private func setupView() {
        view.backgroundColor = .white
        stackViewForImage.addArrangedSubview(previewImage)
        [stackViewForImage, nameLabel, artistLabel, mediaInfoView, descriptionLabel, linkButton, authorView, authorWorksTitle, authorWorksCollectionView].forEach({stackView.addArrangedSubview($0)})
        containerView.addSubview(stackView)
        [containerView, loadingView, errorLabel].forEach({view.addSubview($0)})
        setupSubview()
        setupConstraints()
    }
    
    @objc private func linkButtonTapped() {
        if let urlString = data.trackViewUrl, let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func setupSubview() {
        previewImage.image = image
        if data.trackName != nil {
            nameLabel.text = data.trackName
        } else {
            nameLabel.text = data.collectionName
        }
        artistLabel.text = data.artistName
        if data.description != nil {
            descriptionLabel.text = data.description
        } else {
            descriptionLabel.text = data.longDescription
        }
        if data.trackViewUrl == nil {
            linkButton.isHidden = true
        }
        mediaInfoView.setData(data: data)
        
        authorWorksCollectionView.delegate = self
        authorWorksCollectionView.dataSource = self
        authorWorksCollectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: SearchResultCollectionViewCell.self))
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.contentInset),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.contentInset),
            
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.contentInset),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.contentInset),
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackViewForImage.widthAnchor.constraint(equalTo: stackView.widthAnchor),
           
            previewImage.widthAnchor.constraint(equalToConstant: 210),
            previewImage.heightAnchor.constraint(equalToConstant: 210),
            
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            authorView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            authorView.heightAnchor.constraint(equalToConstant: 120),
            
            mediaInfoView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            mediaInfoView.heightAnchor.constraint(equalToConstant: 60),
            
            authorWorksCollectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            authorWorksCollectionView.heightAnchor.constraint(equalToConstant: UIConstants.collectionViewHeight)
        ])
        
        let equalWidthConstraint = NSLayoutConstraint(item: stackView,
                                                       attribute: .width,
                                                       relatedBy: .equal,
                                                       toItem: containerView,
                                                       attribute: .width,
                                                       multiplier: 1.0,
                                                       constant: 0)
        equalWidthConstraint.isActive = true
        
        stackView.setCustomSpacing(20, after: authorWorksTitle)
        stackView.setCustomSpacing(12, after: authorView)
        stackView.setCustomSpacing(12, after: descriptionLabel)
    }
    
    func updateAuthorInfo(info: ArtistData) {
        showContent()
        authorView.setAuthor(data: info)
    }
    
    func updateAuthorWorkCollectionView() {
        authorWorksCollectionView.reloadData()
    }
}

// MARK: - Implementation BaseViewProtocol
extension DetailViewController: BaseViewProtocol {

    func showLoading() {
        loadingView.startAnimating()
        errorLabel.isHidden = true
        containerView.isHidden = true
    }
    
    func showError(error: String) {
        loadingView.stopAnimating()
        errorLabel.isHidden = false
        containerView.isHidden = true
    }
    
    func showContent() {
        loadingView.stopAnimating()
        errorLabel.isHidden = true
        containerView.isHidden = false
    }
}

// MARK: - Implementation UICollectionViewDelegateFlowLayout
extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemHeight = UIConstants.collectionViewHeight
        let itemWidth = collectionView.bounds.width / 2
        return CGSize(width: Double(itemWidth), height: Double(itemHeight))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

// MARK: - Implementation SearchViewProtocol
extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getAuthorWorks().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SearchResultCollectionViewCell.self), for: indexPath) as? SearchResultCollectionViewCell else { return SearchResultCollectionViewCell()}
        let result = presenter.getAuthorWorks()[indexPath.row]
        cell.contigure(searchResult: result)
        if let url = result.artworkUrl100 {
            presenter.fetchImage(url: url) { image in
                cell.setImage(image: image)
            }
        }
        return cell
    }
}
