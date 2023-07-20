//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Виктор on 10.06.2023.
//

import UIKit

final class SingleImageViewController: BaseViewController {
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    private var scrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    private var imageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private var backButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = UIColor(named: "YP White")
        return button
    }()
    private var shareButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Sharing"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        
        addSubViews()
        
        shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        imageView.image = image
        
        rescaleAndCenterImageInScrollView(image: image)
    }
    private func addSubViews() {
        view.addPositioned(scrollView)
        view.addPositioned(backButton, topFromSafeArea: true, top: 8, left: 8, bottom: nil, right: nil, w: 24, h: 24)
        scrollView.addPositioned(imageView)
        view.addSubview(shareButton)
        NSLayoutConstraint.activate([
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -51)
        ])
    }
    
    @objc
    func didTapShareButton() {
        let sharingController = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        self.present(sharingController, animated: true)
    }
    @objc
    private func didTapBackButton() {
        dismiss(animated: true)
    }
}

extension SingleImageViewController {
    private func rescaleAndCenterImageInScrollView(image: UIImage?) {
        guard let image = image else { return }
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

//MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
