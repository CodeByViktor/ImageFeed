//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Виктор on 29.05.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var bgImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var bgLabel: UIView!
    let gradient = CAGradientLayer()
    let gradientColors = [
        UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0.2).cgColor,
        UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0).cgColor
      ]
}
