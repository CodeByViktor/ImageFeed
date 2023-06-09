//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Виктор on 10.06.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage!
    
    @IBOutlet private var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
