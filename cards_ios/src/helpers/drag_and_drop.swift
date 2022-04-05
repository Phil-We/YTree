//
//  drag_and_drop.swift
//  cards_ios
//
//  Created by Phil Weckenmann on 4/3/22.
//

import SwiftUI

struct DropViewDelegate: DropDelegate{
    var onDropEntered: (() -> Void)?
    var onDropExited: (() -> Void)?
    var didDrop: (() -> Void)?
//    init(onDropEntered: @escaping () -> Void = {}, onDropExited: @escaping () -> Void = {}, didDrop: @escaping () -> Void = {}) {
//        self.onDropEntered = onDropEntered
//        self.onDropExited = onDropExited
//        self.didDrop = didDrop
//    }
    func performDrop(info: DropInfo) -> Bool {
        didDrop?()
        return true
    }
    func dropEntered(info: DropInfo) {
        onDropEntered?()
    }
    func dropExited(info: DropInfo) {
        onDropExited?()
    }
}
