//
//  Array+Extensions.swift
//  ImageFeed
//
//  Created by Виктор on 18.08.2023.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
