//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Виктор on 29.05.2023.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    var bgImageView = {
        let bgImageView = UIImageView()
        bgImageView.layer.masksToBounds = true
        bgImageView.layer.cornerRadius = 16
        return bgImageView
    }()
    var likeButton = {
        let likeButton = UIButton()
        return likeButton
    }()
    var dateLabel = {
        let dateLabel = UILabel()
        dateLabel.textColor = UIColor.ypWhite
        dateLabel.font = UIFont.systemFont(ofSize: 13)
        return dateLabel
    }()
    var bgLabel = {
        let bgLabel = UIView()
        return bgLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .clear
        contentView.addPositioned(bgImageView, top: 4, left: 16, bottom: -4, right: -16)
        bgImageView.addPositioned(likeButton, left: nil, bottom: nil)
        bgImageView.addPositioned(bgLabel, top: nil, h: 30)
        bgLabel.addPositioned(dateLabel, top: nil, left: 8, bottom: -8, right: -8)
        
        bgImageView.backgroundColor = .ypWhiteAlpha50
        bgImageView.contentMode = .center
        bgImageView.kf.indicatorType = .activity
        
        applyLabelGradient()
        
        hideDetails()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        bgImageView.kf.cancelDownloadTask()
        
        bgImageView.contentMode = .center
        hideDetails()
    }
    
    private func applyLabelGradient() {
        clipsToBounds = true
        let gradient = CAGradientLayer()
        let gradientColors = [
            UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0.2).cgColor,
            UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0).cgColor
          ]
        gradient.frame = bgLabel.bounds
        gradient.colors = gradientColors
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.54)
        layer.insertSublayer(gradient, at: 0)
    }
    
    func showDetails() {
        bgImageView.contentMode = .scaleAspectFit
        likeButton.isHidden = false
        bgLabel.isHidden = false
    }
    func hideDetails() {
        likeButton.isHidden = true
        bgLabel.isHidden = true
    }
}
