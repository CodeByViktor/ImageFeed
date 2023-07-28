//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Виктор on 29.05.2023.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
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
        
        bgImageView.isUserInteractionEnabled = true
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        
        hideDetails()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        applyLabelGradient()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        bgImageView.kf.cancelDownloadTask()
        
        bgImageView.contentMode = .center
        hideDetails()
    }
    
    private func applyLabelGradient() {
        let gradient = CAGradientLayer()
        let gradientColors = [
            UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0.15).cgColor,
            UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0).cgColor
          ]
        gradient.frame = bgLabel.bounds
        gradient.colors = gradientColors
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 0, y: 0)
        bgLabel.layer.insertSublayer(gradient, at: 0)
    }
    
    @objc
    private func didTapLikeButton(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "Active") : UIImage(named: "No Active")
        likeButton.setImage(likeImage, for: .normal)
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
