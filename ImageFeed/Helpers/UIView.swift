//
//  UIView.swift
//  ImageFeed
//
//  Created by Виктор on 18.07.2023.
//

import UIKit

extension UIView {
    enum ExtCenterPosition {
        case X, Y
    }
    func addPositioned(_ subview: UIView,
                       topFromSafeArea: Bool = false,
                       bottomFromSafeArea: Bool = false,
                       top: CGFloat? = 0,
                       left: CGFloat? = 0,
                       bottom: CGFloat? = 0,
                       right: CGFloat? = 0,
                       w: CGFloat? = nil,
                       h: CGFloat? = nil) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        
        if let w = w {
            setWidth(for: subview, w)
        }
        
        if let h = h {
            setHeight(for: subview, h)
        }
        
        if let top = top {
            if topFromSafeArea {
                subview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: top).isActive = true
            } else {
                subview.topAnchor.constraint(equalTo: topAnchor, constant: top).isActive = true
            }
        }
        if let left = left {
            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: left).isActive = true
        }
        if let bottom = bottom {
            if bottomFromSafeArea {
                subview.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: bottom).isActive = true
            } else {
                subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottom).isActive = true
            }
        }
        if let right = right {
            subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: right).isActive = true
        }
    }
    func addCentered(_ subview: UIView,
                     type: ExtCenterPosition? = nil,
                     w: CGFloat? = nil,
                     h: CGFloat? = nil) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        
        if let w = w {
            setWidth(for: subview, w)
        }
        
        if let h = h {
            setHeight(for: subview, h)
        }
        
        switch type {
        case .X: subview.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        case .Y: subview.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        case .none:
            subview.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            subview.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
    }
    fileprivate func setWidth(for view: UIView, _ w: CGFloat) {
        view.widthAnchor.constraint(equalToConstant: w).isActive = true
    }
    fileprivate func setHeight(for view: UIView, _ h: CGFloat) {
        view.heightAnchor.constraint(equalToConstant: h).isActive = true
    }
}
