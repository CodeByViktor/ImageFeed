//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Виктор on 03.07.2023.
//

import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {
    private var webView = {
        let webView = WKWebView()
        return webView
    }()
    private var progressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    private let backButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = UIColor(named: "YP Black")
        return button
    }()
    
    weak var delegate: WebViewViewControllerDelegate?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .ypWhite
        view.addPositioned(webView)
        view.addPositioned(backButton, topFromSafeArea: true, top: 9, left: 9, bottom: nil, right: nil, w: 24, h: 24)
        view.addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 9)
        ])
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        estimatedProgressObservation = webView.observe(\.estimatedProgress, options: [] ) { [weak self] _, _ in
            guard let self = self else { return }
            self.updateProgress()
        }
        
        webView.navigationDelegate = self
        
        var urlComponents = URLComponents(string: gAuthUrl)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: gAccessKey),
            URLQueryItem(name: "redirect_uri", value: gRedirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: gAccessScope)
        ]
        
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        
        webView.load(request)
        updateProgress()
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url,
           let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let queryItems = urlComponents.queryItems,
           let codeItem = queryItems.first(where: { $0.name == "code"})
        {
            return codeItem.value
        }
        
        return nil
    }
    
    @objc
    private func didTapBackButton() {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

