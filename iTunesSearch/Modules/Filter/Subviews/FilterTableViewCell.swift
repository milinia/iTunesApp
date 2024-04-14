//
//  FilterTableViewCell.swift
//  iTunesSearch
//
//  Created by Evelina on 07.04.2024.
//

import Foundation
import UIKit

class FilterTableViewCell: UITableViewCell {
    
    var text: String = ""
    
    // MARK: - Private constants
    private enum UIConstants {
        static let contentInset: CGFloat = 16
        static let checkBoxWidthHeight: CGFloat = 30
        static let hStackSpacing: CGFloat = 6
    }
    
    // MARK: - Private UI properties
    private lazy var filterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var checkBox: CheckBox = {
        let checkBox = CheckBox(frame: CGRect(x: 0, y: 0,
                                              width: self.bounds.height,
                                              height: self.bounds.height))
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        return checkBox
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override methods
    override func prepareForReuse() {
        filterLabel.text = nil
        text = ""
        checkBox.uncheck()
    }
    
    // MARK: - Public functions
    func configure(with filter: String) {
        filterLabel.text = filter
        text = filter
    }
    func checkBoxTapped() {
        if checkBox.isCheck {
            checkBox.uncheck()
        } else {
            checkBox.check()
        }
    }
    // MARK: - Private functions
    private func initialize() {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.distribution = .fill
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.spacing = UIConstants.hStackSpacing
        [filterLabel, checkBox].forEach({hStack.addArrangedSubview($0)})
        addSubview(hStack)
        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            hStack.heightAnchor.constraint(equalTo: self.heightAnchor),
            hStack.topAnchor.constraint(equalTo: self.topAnchor),
            hStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            filterLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -self.bounds.height - 10)
        ])
    }
}
