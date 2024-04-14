//
//  FilterViewController.swift
//  iTunesSearch
//
//  Created by Evelina on 07.04.2024.
//

import Foundation
import UIKit

enum Section: Int, CaseIterable {
    case entity
    case language
    case explicit
    
    var cellCount: Int {
        switch self {
        case .entity:
            return Entity.allCases.count
        case .language:
            return 2
        case .explicit:
            return 2
        }
    }
    
    var header: String {
        switch self {
        case .entity:
            return "Тип контента"
        case .language:
            return "Язык контента"
        case .explicit:
            return "Возрастное ограничение"
        }
    }
    
    var cellTitle: [String] {
        switch self {
        case .entity:
            return Entity.allCases.map { $0.rawValue }
        case .language:
            return ["Английский", "Японский"]
        case .explicit:
            return ["Нет", "Да"]
        }
    }
}

 

protocol FilterViewDelegateProtocol: NSObject {
    func userFilterSelected(filter: FilterData?)
}

class FilterViewController: UIViewController {
    
    // MARK: - Private constants
    private enum UIConstants {
        static let contentInset: CGFloat = 16
        static let tableViewCellHeight: CGFloat = 40
        static let applyButtonCornerRadius: CGFloat = 10
        static let applyButtonWidth: CGFloat = 180
        static let applyButtonHeight: CGFloat = 35
    }
    
    // MARK: - Private properties
    private var presenter: FilterPresenterProtocol
    var choosenFilters: FilterData = FilterData(choosenEntity: .all,
                                                choosenLanguage: Language.en,
                                                isExplicitContentIncluded: true)
    weak var delegate: FilterViewDelegateProtocol? = nil
    
    // MARK: - Inits
    init(presenter: FilterPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI properties
    private lazy var filtersTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Применить", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.layer.cornerRadius = UIConstants.applyButtonCornerRadius
        button.clipsToBounds = true
        return button
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupView()
        showContent()
    }
    
    
    // MARK: - Private methods
    private func setupView() {
        view.backgroundColor = .white
        [filtersTableView, applyButton].forEach({containerView.addSubview($0)})
        [containerView, loadingView, errorLabel].forEach({view.addSubview($0)})
        setupSubview()
        setupConstraints()
    }
    
    private func setupSubview() {
        filtersTableView.delegate = self
        filtersTableView.dataSource = self
        filtersTableView.register(FilterTableViewCell.self, forCellReuseIdentifier: String(describing: FilterTableViewCell.self))
        filtersTableView.separatorStyle = .none
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeFiltersButtonTapped))
        navigationItem.title = "Фильтры"
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
    }
    
    @objc func removeFiltersButtonTapped() {
        choosenFilters = FilterData(choosenEntity: .all,
                                    choosenLanguage: Language.en,
                                    isExplicitContentIncluded: true)
        filtersTableView.reloadData()
    }
    
    @objc func applyButtonTapped() {
        delegate?.userFilterSelected(filter: choosenFilters)
        presenter.closeFilters()
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
            
            applyButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            applyButton.heightAnchor.constraint(equalToConstant: UIConstants.applyButtonHeight),
            applyButton.widthAnchor.constraint(equalToConstant: UIConstants.applyButtonWidth),
            applyButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            filtersTableView.topAnchor.constraint(equalTo: containerView.topAnchor),
            filtersTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            filtersTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            filtersTableView.bottomAnchor.constraint(equalTo: applyButton.topAnchor, constant: -10)
        ])
    }
}

// MARK: - Implementation UITableViewDelegate, UITableViewDataSource
extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Section(rawValue: section)?.cellCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FilterTableViewCell.self), for: indexPath) as? FilterTableViewCell
        else {return FilterTableViewCell()}
        let section = Section(rawValue: indexPath.section)
        let colorView = UIView()
        colorView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = colorView
        cell.configure(with: section?.cellTitle[indexPath.row] ?? "")
        switch section {
        case .entity:
            let entityNum = choosenFilters.choosenEntity.number
            if indexPath.row == entityNum {
                cell.checkBoxTapped()
            }
        case .language:
            let languageNum = choosenFilters.choosenLanguage.number
            if indexPath.row == languageNum {
                cell.checkBoxTapped()
            }
        case .explicit:
            if choosenFilters.isExplicitContentIncluded && indexPath.row == 0 {
                cell.checkBoxTapped()
            } else if !choosenFilters.isExplicitContentIncluded && indexPath.row == 1 {
                cell.checkBoxTapped()
            }
        case nil:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section(rawValue: section)?.header
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIConstants.tableViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FilterTableViewCell else { return }
        switch indexPath.section {
        case 0:
            let choosenEntityNum = Entity(rawValue: cell.text)?.number
            if choosenEntityNum != choosenFilters.choosenEntity.number {
                cell.checkBoxTapped()
                guard let choosenCell = tableView.cellForRow(at: IndexPath(row: choosenFilters.choosenEntity.number, section: indexPath.section)) as? FilterTableViewCell else { return }
                choosenCell.checkBoxTapped()
                choosenFilters.choosenEntity = Entity(rawValue: cell.text) ?? .all
            }
        case 1:
            let choosenLanguageyNum = Language(rawValue: cell.text)?.number
            if choosenLanguageyNum != choosenFilters.choosenLanguage.number {
                cell.checkBoxTapped()
                guard let choosenCell = tableView.cellForRow(at: IndexPath(row: choosenFilters.choosenLanguage.number, section: indexPath.section)) as? FilterTableViewCell else { return }
                choosenCell.checkBoxTapped()
                choosenFilters.choosenLanguage = Language(rawValue: cell.text) ?? .en
            }
        case 2:
            if indexPath.row == 1 && choosenFilters.isExplicitContentIncluded {
                cell.checkBoxTapped()
                guard let choosenCell = tableView.cellForRow(at: IndexPath(row: 0, section: indexPath.section)) as? FilterTableViewCell else { return }
                choosenCell.checkBoxTapped()
                choosenFilters.isExplicitContentIncluded = false
            } else if indexPath.row == 0 && !choosenFilters.isExplicitContentIncluded  {
                cell.checkBoxTapped()
                guard let choosenCell = tableView.cellForRow(at: IndexPath(row: 1, section: indexPath.section)) as? FilterTableViewCell else { return }
                choosenCell.checkBoxTapped()
                choosenFilters.isExplicitContentIncluded = true
            }
        default: break
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
// MARK: - Implementation BaseViewProtocol
extension FilterViewController: BaseViewProtocol {

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
