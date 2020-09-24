//
//  Swipeable.swift
//  CovidPalAdmin
//
//  Created by Mac OS on 9/6/20.
//  Copyright © 2020 Mac OS. All rights reserved.
//

import UIKit

// MARK: - Internal
protocol Swipeable {
    var actionsView: SwipeActionsView? { get }
    
    var state: SwipeState { get }
    
    var frame: CGRect { get }
}

extension SwipeTableViewCell: Swipeable {}

enum SwipeState: Int {
    case center = 0
    case left
    case right
    case dragging
    case animatingToCenter
    
    init(orientation: SwipeActionsOrientation) {
        self = orientation == .left ? .left : .right
    }
    
    var isActive: Bool { return self != .center }
}
