//
//  SwipeFeedback.swift
//  CovidPalAdmin
//
//  Created by Mac OS on 9/6/20.
//  Copyright © 2020 Mac OS. All rights reserved.
//

import UIKit

final class SwipeFeedback {
    enum Style {
        case light
        case medium
        case heavy
    }
    
    @available(iOS 10.0, *)
    private var feedbackGenerator: UIImpactFeedbackGenerator? {
        get {
            return _feedbackGenerator as? UIImpactFeedbackGenerator
        }
        set {
            _feedbackGenerator = newValue
        }
    }
    
    private var _feedbackGenerator: Any?
    
    init(style: Style) {
        if #available(iOS 10.0, *) {
            switch style {
            case .light:
                feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
            case .medium:
                feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            case .heavy:
                feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
            }
        } else {
            _feedbackGenerator = nil
        }
    }
    
    func prepare() {
        if #available(iOS 10.0, *) {
            feedbackGenerator?.prepare()
        }
    }
    
    func impactOccurred() {
        if #available(iOS 10.0, *) {
            feedbackGenerator?.impactOccurred()
        }
    }
}
