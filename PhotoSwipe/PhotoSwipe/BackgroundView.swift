//
//  BackgroundView.swift
//  PhotoSwipe
//
//  Created by matheo rose on 22/01/2025.
//

import SwiftUI
import UIKit

class BackgroundView: UIViewController, CAAnimationDelegate {
    let color1: CGColor = UIColor(red: 18/255, green: 14/255, blue: 255/255, alpha: 1).cgColor
    let color2: CGColor = UIColor(red: 204/255, green: 38/255, blue: 255/255, alpha: 1).cgColor
    let color3: CGColor = UIColor(red: 255/255, green: 14/255, blue: 138/255, alpha: 1).cgColor
    
    let gradient: CAGradientLayer = CAGradientLayer()
    var gradientColorSet: [[CGColor]] = []
    var colorIndex: Int = 0
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        setupGradient()
        animateGradient()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
            if flag {
                animateGradient()
            }
        }
        
        func setupGradient(){
            gradientColorSet = [
                [color1, color2],
                [color2, color3],
                [color3, color1]
            ]
            
            gradient.frame = self.view.bounds
            gradient.colors = gradientColorSet[colorIndex]
            
            gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
            
            self.view.layer.addSublayer(gradient)
        }
        
        func animateGradient() {
            gradient.colors = gradientColorSet[colorIndex]
            
            let gradientAnimation = CABasicAnimation(keyPath: "colors")
            gradientAnimation.delegate = self
            gradientAnimation.duration = 2.0
            
            updateColorIndex()
            gradientAnimation.toValue = gradientColorSet[colorIndex]
            
            gradientAnimation.fillMode = .forwards
            gradientAnimation.isRemovedOnCompletion = false
            
            gradient.add(gradientAnimation, forKey: "colors")
        }
        
        func updateColorIndex(){
            if colorIndex < gradientColorSet.count - 1 {
                colorIndex += 1
            } else {
                colorIndex = 0
            }
        }
}
