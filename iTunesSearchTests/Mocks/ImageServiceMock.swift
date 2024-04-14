//
//  ImageServiceMock.swift
//  iTunesSearchTests
//
//  Created by Evelina on 14.04.2024.
//

import Foundation
import UIKit
@testable import iTunesSearch

final class ImageServiceMock: ImageServiceProtocol {
    
    var isFailureResponse: Bool = false
    
    func fetchImage(url: String) async throws -> UIImage {
        if isFailureResponse  {
            throw AppError.errorWhileDownloadingImage
        } else {
            return UIImage()
        }
    }
}
