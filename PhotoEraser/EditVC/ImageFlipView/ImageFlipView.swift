//
//  ImageFlipView.swift
//  ImageFlip
//
//  Created by Rashed Nizam on 29/8/20.
//  Copyright © 2020 Rashed Nizam. All rights reserved.
//

import UIKit

public protocol ImageFlipViewDelegate {
    func imageFlipView_CrossButtonTapped()
    func imageFlipView_TickButtonTapped(image: UIImage)
}

class ImageFlipView: UIView, ImageFlipUndoManagerDelegate, ImageFlipMenuBarDelegate, ImageFlipMenuViewDelegate {
    
    // MARK: Declarations
    var delegate: ImageFlipViewDelegate!
    
    var flipUndoManager : ImageFlipUndoManager!
        
    var menuViewHeight:CGFloat!
    var menuBar : ImageFlipMenuBar!
    
    var containerView : UIView!
    
    var image : UIImage!
    var imageView : UIImageView!
    
    var flipPoint: CGPoint!
        
    
    // MARK:- Initial Methods
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        self.backgroundColor = UIColor.black
        
        // Undo Manager
        flipUndoManager = ImageFlipUndoManager()
        flipUndoManager.delegate = self
        
        menuViewHeight = 234.0
        
        flipPoint = CGPoint(x: 1, y: 1)
        
        createFlipInterface()
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
        menuBar = ImageFlipMenuBar.init(frame: CGRect(x: 0, y: 0, width: containerView.bounds.width, height: barHeight))
        menuBar.delegate = self
        containerView.addSubview(menuBar)
        
        // ------------------------ Menu ------------------------
        let menuInterface = ImageFlipMenuView.init(frame: CGRect(x: 0, y: barHeight, width: containerView.bounds.width, height: containerView.bounds.height-barHeight))
        menuInterface.delegate = self
        containerView.addSubview(menuInterface)
        
    }
    
    func createFlipInterface() {
        
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
        
        // Update Undo Manager
        flipUndoManager.reset()
    }
    
    // MARK:- Menu Bar
    func imageFlipMenuBar_CrossButtonTapped() {
//        print("cross")
        
        if (delegate != nil) {
            delegate.imageFlipView_CrossButtonTapped()
        }
        
    }
    
    func imageFlipMenuBar_TickButtonTapped() {
//        print("tick")
        
        if (delegate != nil) {
            delegate.imageFlipView_TickButtonTapped(image: imageView.image!)
        }
    }
    
    func imageFlipMenuBar_UndoButtonTapped() {
//        print("undo")
        flipUndoManager.undo()
    }
    
    func imageFlipMenuBar_RedoButtonTapped() {
//        print("redo")
        flipUndoManager.redo()
    }
    
    func imageFlipMenuView_hFlipButtonTapped() {
        image = flipHorizontally(image)
        imageView.image = image
        
        flipPoint = CGPoint(x: -flipPoint.x, y: flipPoint.y)
        flipUndoManager.addObject(isHFlipped: true)
    }
    
    func imageFlipMenuView_vFlipButtonTapped() {
        image = flipVertically(image)
        imageView.image = image
        flipPoint = CGPoint(x: flipPoint.x, y: -flipPoint.y)
        flipUndoManager.addObject(isHFlipped: false)
    }
    
    func flipVertically(_ image: UIImage?) -> UIImage? {
        UIGraphicsBeginImageContext(image?.size ?? CGSize.zero)
        
        UIGraphicsGetCurrentContext()?.draw((image?.cgImage)!, in: CGRect(x: 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return image
    }
    
    func flipHorizontally(_ image: UIImage) -> UIImage? {

        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: image.size.width, y: image.size.height)
        context.scaleBy(x: -image.scale, y: -image.scale)
        context.draw(image.cgImage!, in: CGRect(origin:CGPoint.zero, size: image.size))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    // MARK:- Menu Bar
    func imageFlipUndoManager_ReachedToStart(isReached: Bool) {
        if menuBar != nil {
            menuBar.enableUndoButton(isEnable: !isReached)
        }
    }
    
    func imageFlipUndoManager_ReachedToEnd(isReached: Bool) {
        if menuBar != nil {
            menuBar.enableRedoButton(isEnable: !isReached)
        }
    }
    
    func imageFlipUndoManager_UndoneWithFlag(isHFlipped: Bool) {
        
        if isHFlipped {
            image = flipHorizontally(image)
        } else {
            image = flipVertically(image)
        }
        imageView.image = image
    }
    
    
    func imageFlipUndoManager_RedoneWithFlag(isHFlipped: Bool) {
        
        if isHFlipped {
            image = flipHorizontally(image)
        } else {
            image = flipVertically(image)
        }
        imageView.image = image
    }
    
}
