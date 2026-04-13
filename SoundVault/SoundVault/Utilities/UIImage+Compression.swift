//
//  UIImage+Compression.swift
//  SoundVault
//
//  Created by Marco Celestino on 13/04/26.
//

import UIKit

extension UIImage {
    func compressed(maxDimension: CGFloat = 1024, quality: CGFloat = 0.8) -> Data? {
        let scale = min(maxDimension / size.width, maxDimension / size.height, 1.0)
        let targetSize = CGSize(width: size.width * scale, height: size.height * scale)

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let resized = renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: targetSize))
        }
        return resized.jpegData(compressionQuality: quality)
    }
}
