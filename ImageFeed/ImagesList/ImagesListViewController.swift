//
//  ViewController.swift
//  ImageFeed
//
//  Created by Виктор on 28.05.2023.
//

import UIKit

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImageListPresenterProtocol? { get set }
    func updateTableViewAnimated(with indexPaths: [IndexPath])
}

class ImagesListViewController: BaseViewController & ImagesListViewControllerProtocol {
    var presenter: ImageListPresenterProtocol?
    
    private let tableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .ypBlack
        return tableView
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
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
        
        presenter?.viewDidLoad()
    }
    
    func updateTableViewAnimated(with indexPaths: [IndexPath]) {
        tableView.performBatchUpdates {
            self.tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let photo = presenter?.getPhotos()[indexPath.row],
              let imageUrl = URL(string: photo.thumbImageURL) else { return }
        
        cell.bgImageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "Stub")) { result in
            switch result {
            case .success(_):
                cell.showDetails()
            case .failure: break
            }
        }
        
        cell.delegate = self
        
        var dateText = ""
        if let createdDate = photo.createdAt {
            dateText = dateFormatter.string(from: createdDate)
        }
        cell.dateLabel.text = dateText
        cell.setIsLiked(photo.isLiked)
    }
}

//MARK: Show errors
extension ImagesListViewController {
    private func showError() {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Попробуйте еще раз",
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getPhotos().count ?? 0
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
        guard let presenter = presenter else { return }
        if indexPath.row + 1 != presenter.getPhotos().count { return }
        
        presenter.loadNextPage()
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let presenter = presenter else { return }
        let singleImageShowController = SingleImageViewController()
        singleImageShowController.modalPresentationStyle = .overFullScreen
        let imageUrl = URL(string: presenter.getPhotos()[indexPath.row].largeImageURL)
        singleImageShowController.imageUrl = imageUrl
        present(singleImageShowController, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let presenter = presenter else { return 0 }
        let height: CGFloat

        let imageSize = presenter.getPhotos()[indexPath.row].size
        
        let scale = (tableView.bounds.width - 32) / imageSize.width
        height = imageSize.height * scale + 8

        return height
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        UIBlockingProgressHUD.show()
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        guard let photo = presenter?.getPhotos()[indexPath.row] else { return }
        presenter?.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let isLiked):
                print(isLiked)
                cell.setIsLiked(isLiked)
            case .failure(_):
                self.showError()
            }
            UIBlockingProgressHUD.hide()
        }
    }
}
