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
        return presenter?.getPhotosCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell,
              let cellModel = presenter?.getCellInfo(by: indexPath)
        else {
            return UITableViewCell()
        }
        
        imageListCell.delegate = self
        imageListCell.setup(from: cellModel)
        
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let presenter = presenter else { return }
        if indexPath.row + 1 != presenter.getPhotosCount() { return }
        
        presenter.loadNextPage()
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let presenter = presenter else { return }
        let singleImageShowController = SingleImageViewController()
        singleImageShowController.modalPresentationStyle = .overFullScreen
        let imageUrl = URL(string: presenter.getPhoto(by: indexPath).largeImageURL)
        singleImageShowController.imageUrl = imageUrl
        present(singleImageShowController, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let presenter = presenter else { return 0 }
        let height: CGFloat

        let imageSize = presenter.getPhoto(by: indexPath).size
        
        let scale = (tableView.bounds.width - 32) / imageSize.width
        height = imageSize.height * scale + 8

        return height
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        UIBlockingProgressHUD.show()
        guard let indexPath = tableView.indexPath(for: cell),
              let photo = presenter?.getPhoto(by: indexPath)
        else { return }
        presenter?.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let isLiked):
                cell.setIsLiked(isLiked)
            case .failure(_):
                self.showError()
            }
            UIBlockingProgressHUD.hide()
        }
    }
}
