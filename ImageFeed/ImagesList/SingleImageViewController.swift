//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Виктор on 10.06.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        imageView.image = image
        
        rescaleAndCenterImageInScrollView(image: image)
        
    }
    @IBAction func didTapShareButton(_ sender: UIButton) {
        let sharingController = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        self.present(sharingController, animated: true)
    }
    @IBAction func didTabBackButton(_ sender: Any) {
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
