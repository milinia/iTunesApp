//
//  SearchViewController.swift
//  iTunesSearch
//
//  Created by Evelina on 04.04.2024.
//

import UIKit

protocol SearchViewProtocol: NSObject, BaseViewProtocol, FilterViewDelegateProtocol {
    func showSearchHistory()
    func showSearchResult()
}

class SearchViewController: UIViewController {
    
    // MARK: - Private constants
    private enum UIConstants {
        static let contentInset: CGFloat = 16
        static let searchtextFieldCornerRadius: CGFloat = 15
        static let searchTextFieldHeight: CGFloat = 40
        static let searchRequestCellHeight: CGFloat = 30
    }
    
    // MARK: - Private properties
    private var presenter: SearchPresenterProtocol
    private var filters: FilterData?
    
    // MARK: - Inits
    init(presenter: SearchPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI properties
    private lazy var searchTextField: UITextField = {
        let textField = SearchTextField()
        textField.placeholder = "Search"
        textField.layer.cornerRadius = UIConstants.searchtextFieldCornerRadius
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemGray6
        return textField
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "line.horizontal.3.decrease.circle"), for: .normal)
        button.tintColor = UIColor.black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var searchHistoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        return collection
    }()
    
    private lazy var searchRequestResultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        return collection
    }()
    
    private lazy var blackDoteView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 13, height: 13))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = view.bounds.width / 2
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
       
        presenter.viewDidLoaded()
        setupView()
        showLoading()
    }
    
    // MARK: - Private methods
    private func setupView() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        view.backgroundColor = .white
        [searchTextField, filterButton, searchHistoryCollectionView, searchRequestResultCollectionView].forEach({containerView.addSubview($0)})
        [containerView, loadingView, errorLabel].forEach({view.addSubview($0)})
        containerView.addSubview(blackDoteView)
        setupSubview()
        setupConstraints()
    }
    
    private func setupSubview() {
        searchHistoryCollectionView.delegate = self
        searchHistoryCollectionView.dataSource = self
        searchHistoryCollectionView.register(SearchHistoryCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: SearchHistoryCollectionViewCell.self))
        
        searchTextField.delegate = self
        
        searchRequestResultCollectionView.delegate = self
        searchRequestResultCollectionView.dataSource = self
        searchRequestResultCollectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: SearchResultCollectionViewCell.self))
        
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
    }
    
    @objc func filterButtonTapped() {
        presenter.goToFilterScreen(filters: filters)
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
            
            filterButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -UIConstants.contentInset),
            filterButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: 40),
            filterButton.heightAnchor.constraint(equalToConstant: 40),
            
            blackDoteView.topAnchor.constraint(equalTo: filterButton.topAnchor, constant: -5),
            blackDoteView.trailingAnchor.constraint(equalTo: filterButton.trailingAnchor, constant: 3),
            blackDoteView.widthAnchor.constraint(equalToConstant: 13),
            blackDoteView.heightAnchor.constraint(equalToConstant: 13),
            
            searchTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: UIConstants.contentInset),
            searchTextField.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor, constant: -6),
            searchTextField.heightAnchor.constraint(equalToConstant: UIConstants.searchTextFieldHeight),
            searchTextField.topAnchor.constraint(equalTo: containerView.topAnchor),
            
            searchHistoryCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: UIConstants.contentInset),
            searchHistoryCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -UIConstants.contentInset),
            searchHistoryCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: UIConstants.contentInset),
            searchHistoryCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            searchRequestResultCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: UIConstants.contentInset),
            searchRequestResultCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -UIConstants.contentInset),
            searchRequestResultCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: UIConstants.contentInset),
            searchRequestResultCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            
        ])
    }
}
// MARK: - Implementation SearchViewProtocol
extension SearchViewController: SearchViewProtocol {
    func showSearchHistory() {
        DispatchQueue.main.async {
            self.searchHistoryCollectionView.reloadData()
            self.showContent()
            self.searchRequestResultCollectionView.isHidden = true
            self.searchHistoryCollectionView.isHidden = false
        }
    }
    
    func showSearchResult() {
        DispatchQueue.main.async {
            self.errorLabel.isHidden = true
            self.containerView.isHidden = false
            self.searchRequestResultCollectionView.isHidden = false
            self.searchHistoryCollectionView.isHidden = true
            self.searchRequestResultCollectionView.reloadData()
        }
    }
}
// MARK: - Implementation SearchViewProtocol
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == searchHistoryCollectionView {
            return presenter.getLastFiveRequests().count
        } else {
            return presenter.getSearchRequestResult().results.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == searchHistoryCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SearchHistoryCollectionViewCell.self), for: indexPath) as? SearchHistoryCollectionViewCell else { return SearchHistoryCollectionViewCell()}
            cell.contigure(searchRequest: presenter.getLastFiveRequests()[indexPath.row])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SearchResultCollectionViewCell.self), for: indexPath) as? SearchResultCollectionViewCell else { return SearchResultCollectionViewCell()}
            let result = presenter.getSearchRequestResult().results[indexPath.row]
            cell.contigure(searchResult: result)
            if let url = result.artworkUrl100 {
                presenter.fetchImage(url: url) { image in
                    cell.setImage(image: image)
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == searchHistoryCollectionView {
            guard let selectedCell = collectionView.cellForItem(at: indexPath) as? SearchHistoryCollectionViewCell else { return }
            searchTextField.text = selectedCell.requestText
            presenter.userInputedRequest(request: selectedCell.requestText, filters: filters)
        } else {
            guard let selectedCell = collectionView.cellForItem(at: indexPath) as? SearchResultCollectionViewCell else { return }
            presenter.goToDetailScreen(data: presenter.getSearchRequestResult().results[indexPath.row], 
                                       image: selectedCell.previewImage.image ?? UIImage())
        }
    }
}
// MARK: - Implementation BaseViewProtocol
extension SearchViewController: BaseViewProtocol {

    func showLoading() {
        loadingView.startAnimating()
        errorLabel.isHidden = true
        containerView.isHidden = true
    }
    
    func showError(error: String) {
        loadingView.stopAnimating()
        errorLabel.isHidden = false
        containerView.isHidden = true
        errorLabel.text = error
    }
    
    func showContent() {
        loadingView.stopAnimating()
        errorLabel.isHidden = true
        containerView.isHidden = false
    }
}

// MARK: - Implementation UICollectionViewDelegateFlowLayout
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        presenter.userInputedRequest(request: textField.text ?? "", filters: filters)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        if !searchHistoryCollectionView.isHidden {
            presenter.inputedTextUpdated(text: text)
        } else {
            if text == "" {
                searchHistoryCollectionView.isHidden = false
                searchRequestResultCollectionView.isHidden = true
            }
        }
        return true
    }
}

// MARK: - Implementation UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == searchHistoryCollectionView {
            let itemHeight = UIConstants.searchRequestCellHeight
            let itemWidth = collectionView.bounds.width
            return CGSize(width: Double(itemWidth), height: Double(itemHeight))
        } else {
            let itemHeight = 250
            let itemWidth = (collectionView.bounds.width - 10) / 2
            return CGSize(width: Double(itemWidth), height: Double(itemHeight))
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension SearchViewController: FilterViewDelegateProtocol {
    func userFilterSelected(filter: FilterData?) {
        if let filter = filter {
            filters = filter
            blackDoteView.isHidden = false
        } else {
            filters = nil
            blackDoteView.isHidden = true
        }
    }
}
