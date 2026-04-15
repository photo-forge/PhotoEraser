//
//  ImageCropView.swift
//  ImageCrop
//
//  Created by Rashed Nizam on 29/8/20.
//  Copyright © 2020 Rashed Nizam. All rights reserved.
//

import UIKit

public protocol ImageCropViewDelegate {
    func imageCropView_CrossButtonTapped()
    func imageCropView_TickButtonTapped(image: UIImage)
//    func imageCropView_hFlipButtonTapped()
//    func imageCropView_vFlipButtonTapped()
}

class ImageCropView: UIView, ImageCropMenuBarDelegate, ImageCropMenuViewDelegate {
    
    // MARK: Declarations
    var delegate: ImageCropViewDelegate!
        
    var menuViewHeight:CGFloat!
    var menuBar : ImageCropMenuBar!
    
    var containerView : UIView!
    
    var image : UIImage!
    var imageView : UIImageView!
        
    
    // MARK:- Initial Methods
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        self.backgroundColor = UIColor.black
        
        menuViewHeight = 234.0
        
        createCropInterface()
        createMenuInterface()
    }
    
    
    func createMenuInterface() {
        
        let barHeight:CGFloat = 50.0

        // Container View
        let containerView = UIView.init(frame:CGRect(x: 0, y: self.bounds.height-menuViewHeight, width: self.bounds.width, height: menuViewHeight))
        containerView.backgroundColor = UIColor(displayP3Red: 20/255.0, green: 20/255.0, blue: 20/255.0, alpha: 1.0)
        self.addSubview(containerView)
        containerView.clipsToBounds = true
        
        // ------------------------------ BAR ------------------------------
        menuBar = ImageCropMenuBar.init(frame: CGRect(x: 0, y: 0, width: containerView.bounds.width, height: barHeight))
        menuBar.delegate = self
        containerView.addSubview(menuBar)
        
        // ------------------------ Menu ------------------------
        let menuInterface = ImageCropMenuView.init(frame: CGRect(x: 0, y: barHeight, width: containerView.bounds.width, height: containerView.bounds.height-barHeight))
        menuInterface.delegate = self
        containerView.addSubview(menuInterface)
        
    }
    
    func createCropInterface() {
        
        // Container View
        containerView = UIView.init(frame:CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height-menuViewHeight))
        containerView.backgroundColor = UIColor.red
        self.addSubview(containerView)
        containerView.clipsToBounds = true
        
        // Grid View
        let gridImage = UIImage(named: "ev_grid_image")
        let gridImageView = UIImageView.init(frame: containerView.bounds)
        gridImageView.center = CGPoint(x: containerView.bounds.width/2, y: containerView.bounds.height/2)
        containerView.addSubview(gridImageView)
        gridImageView.backgroundColor = UIColor.cyan
        gridImageView.image = gridImage
        gridImageView.contentMode = .scaleAspectFill
        
        // Image View
        imageView = UIImageView()
        containerView.addSubview(imageView)
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFill
        
    }
    
    func setImage(image: UIImage) {
        
        self.image = image
        
        // Image View
        let imageSizeRatio:CGFloat = (image.size.width) / (image.size.height)
        let containerSizeRatio = (containerView.bounds.size.width) / (containerView.bounds.size.height)
        var imageViewSize = CGSize(width: containerView.bounds.width-40, height: containerView.bounds.height-40)
        if imageSizeRatio > containerSizeRatio {
            imageViewSize.height = imageViewSize.width/imageSizeRatio
        } else {
            imageViewSize.width = imageViewSize.height * imageSizeRatio
        }
        imageView.frame = CGRect(x: 0, y: 0, width: imageViewSize.width, height: imageViewSize.height)
        imageView.center = CGPoint(x: containerView.bounds.width/2.0, y: containerView.bounds.height/2.0)
        imageView.image = image
        
    }
    
    // MARK:- Menu Bar
    func imageCropMenuBar_CrossButtonTapped() {
//        print("cross")
        
        if (delegate != nil) {
            delegate.imageCropView_CrossButtonTapped()
        }
        
    }
    
    func imageCropMenuBar_TickButtonTapped() {
//        print("tick")
        
        if (delegate != nil) {
            delegate.imageCropView_TickButtonTapped(image: imageView.image!)
        }
    }
    
    func imageCropMenuBar_UndoButtonTapped() {
//        print("undo")
    }
    
    func imageCropMenuBar_RedoButtonTapped() {
//        print("redo")
    }
    
    
}
