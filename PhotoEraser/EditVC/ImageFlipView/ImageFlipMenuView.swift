//
//  ImageFlipMenuView.swift
//  ImageFlip
//
//  Created by Rashed Nizam on 10/9/20.
//  Copyright © 2020 Rashed Nizam. All rights reserved.
//

import UIKit

public protocol ImageFlipMenuViewDelegate {
    func imageFlipMenuView_hFlipButtonTapped()
    func imageFlipMenuView_vFlipButtonTapped()
}

class ImageFlipMenuView: UIView {

    var delegate: ImageFlipMenuViewDelegate!
    
    var leftButton : UIButton!
    var rightButton : UIButton!
    var upButton : UIButton!
    var downButton : UIButton!

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override init(frame: CGRect) {
        super.init(frame : frame)
        
        createInterface()
    }
    
    
    func createInterface() {
                
        // Container View
        let containerView = UIView.init(frame:self.bounds)
        containerView.backgroundColor = UIColor(displayP3Red: 20/255.0, green: 20/255.0, blue: 20/255.0, alpha: 1.0)
        self.addSubview(containerView)
        containerView.clipsToBounds = true
        
        
        // h Flip Icon
        let hFlipButton = UIButton(frame: CGRect(x: 0, y: 0, width: 55, height: 55))
        containerView.addSubview(hFlipButton)
        hFlipButton.center = CGPoint(x: containerView.bounds.width*0.3, y: containerView.bounds.height*0.5)
        hFlipButton.backgroundColor = UIColor.clear
        hFlipButton.setImage(UIImage(named:"HFlipIcon"), for: .normal)
        hFlipButton.imageView?.contentMode = .scaleAspectFit
        hFlipButton.addTarget(self, action: #selector(self.hFlipButtonTapped), for: .touchUpInside)

        // v Flip Icon
        let vFlipButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        containerView.addSubview(vFlipButton)
        vFlipButton.center = CGPoint(x: containerView.bounds.width*0.7, y: containerView.bounds.height*0.5)
        vFlipButton.backgroundColor = UIColor.clear
        vFlipButton.setImage(UIImage(named:"VFlipIcon"), for: .normal)
        vFlipButton.imageView?.contentMode = .scaleAspectFit
        vFlipButton.addTarget(self, action: #selector(self.vFlipButtonTapped), for: .touchUpInside)

    }
    
    @objc func hFlipButtonTapped() {
        if (delegate != nil) {
            delegate.imageFlipMenuView_hFlipButtonTapped()
        }
    }
    
    @objc func vFlipButtonTapped() {
        if (delegate != nil) {
            delegate.imageFlipMenuView_vFlipButtonTapped()
        }
    }
    
}
