//
//  ImageCropMenuView.swift
//  ImageCrop
//
//  Created by Rashed Nizam on 10/9/20.
//  Copyright © 2020 Rashed Nizam. All rights reserved.
//

import UIKit

public protocol ImageCropMenuViewDelegate {
    
}

class ImageCropMenuView: UIView {

    var delegate: ImageCropMenuViewDelegate!
    
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
        
    }
    
    
    
}
