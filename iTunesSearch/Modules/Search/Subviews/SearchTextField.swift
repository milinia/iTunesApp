//
//  SearchTextField.swift
//  iTunesSearch
//
//  Created by Evelina on 05.04.2024.
//

import Foundation
import UIKit

class SearchTextField: UITextField {
    
    // MARK: - Private properies
    private let textFieldInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 10)
    
    // MARK: - Override inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImagetoLeft(image: UIImage(systemName: "magnifyingglass") ?? UIImage(),
                       pointX: 8,
                       pointY: 12,
                       width: 15,
                       height: 15)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override functions
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textFieldInset)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textFieldInset)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textFieldInset)
    }
    
    // MARK: - Private functions
    private func setImagetoLeft(image: UIImage, pointX: Int, pointY: Int, width: Int, height: Int) {
        self.leftViewMode = .always
        let imageView = UIImageView(frame: CGRect(x: pointX, y: pointY, width: width, height: height))
        imageView.image = image
        imageView.tintColor = .black
        self.addSubview(imageView)
    }
}
