//
//  ViewController.swift
//  ImageFeed
//
//  Created by Виктор on 28.05.2023.
//

import UIKit

class ImagesListViewController: BaseViewController {

    private let imageListService = ImageListService()
    private var showedPhotoCount = 0
    
    private let tableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .ypBlack
        return tableView
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        view.addPositioned(tableView)
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 215
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        
        NotificationCenter.default.addObserver(forName: ImageListService.DidChangeNotification,
                                               object: nil, queue: .main) { [weak self] _ in
            guard let self = self else {return}
            self.updateTableViewAnimated()
        }
        
        imageListService.fetchPhotosNextPage()
    }
    
    private func updateTableViewAnimated() {
        tableView.performBatchUpdates {
            let newPhotoCount = imageListService.photos.count
            if showedPhotoCount != newPhotoCount {
                let indexPaths = (showedPhotoCount..<newPhotoCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                showedPhotoCount = newPhotoCount
                self.tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = imageListService.photos[indexPath.row]
        guard let imageUrl = URL(string: photo.thumbImageURL) else {
            return
        }
        
        cell.bgImageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "Stub")) { result in
            switch result {
            case .success(_):
                cell.showDetails()
            case .failure: break
            }
        }
        
        cell.delegate = self
        cell.dateLabel.text = dateFormatter.string(from: photo.createdAt ?? Date())
        cell.setIsLiked(photo.isLiked)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageListService.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }

        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 != imageListService.photos.count { return }
        
        imageListService.fetchPhotosNextPage()
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleImageShowController = SingleImageViewController()
        singleImageShowController.modalPresentationStyle = .overFullScreen
        let imageUrl = URL(string: imageListService.photos[indexPath.row].largeImageURL)
        singleImageShowController.imageUrl = imageUrl
        present(singleImageShowController, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat

        let imageSize = imageListService.photos[indexPath.row].size
        
        let scale = (tableView.bounds.width - 32) / imageSize.width
        height = imageSize.height * scale + 8

        return height
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = imageListService.photos[indexPath.row]
        imageListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
            switch result {
            case .success(let isLiked):
                cell.setIsLiked(isLiked)
            case .failure(_): break
            }
        }
    }
}
