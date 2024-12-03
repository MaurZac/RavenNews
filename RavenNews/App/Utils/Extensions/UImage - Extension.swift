//
//  UImage - Extension.swift
//  RavenNews
//
//  Created by MaurZac on 02/12/24.
//
import UIKit

extension UIImageView {
    func loadImage(from url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}

