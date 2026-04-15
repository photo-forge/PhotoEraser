//
//  PEEditVC.swift
//  PhotoEraser
//
//  Created by Rashed Nizam on 11/6/21.
//

import UIKit

@objc protocol PEEditVCDelegate {
    
    @objc optional func editVC_dismissedWith(image: UIImage)
}

class PEEditVC: UIViewController, PEEditMenuBarDelegate, ImageEraserViewDelegate, ImageCropViewDelegate, ImageFlipViewDelegate {
    
    var delegate:PEEditVCDelegate!
    
    var image:UIImage!
    var originalImage:UIImage!

    let screenBound = UIScreen.main.bounds
    var safeAreaInset: UIEdgeInsets!
    
    // Eraser View
    var eraserView : ImageEraserView!
    var isEraserViewAppeared: Bool!
    
    // Crop View
    var cropView: ImageCropView!
    var isCropViewAppeared: Bool!
    
    // Flip View
    var flipView : ImageFlipView!
    var isFlipViewAppeared: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createInterface()
        
    }
    
    
    func createInterface() {
        
        print(screenBound)
        safeAreaInset = UIApplication.shared.windows.first?.safeAreaInsets
        print(safeAreaInset.bottom)
        
        // Bottom Menu Bar
        let barHeight:CGFloat = 50+safeAreaInset.bottom
        let bbRect = CGRect(x: 0, y: screenBound.height-barHeight, width: self.view.bounds.width, height: barHeight)
        let bottomBar: PEEditMenuBar = PEEditMenuBar(frame: bbRect)
        self.view.addSubview(bottomBar)
        bottomBar.delegate = self
        
        // Views
        let evRect = CGRect(x: 0, y: 0, width: screenBound.width, height: screenBound.height-barHeight)
        
        // Crop View
        cropView = ImageCropView(frame: evRect)
        cropView.delegate = self
        self.view.addSubview(cropView)
        cropView.setImage(image: self.image)
        
        // Eraser View
        eraserView = ImageEraserView(frame: evRect)
        eraserView.delegate = self
        self.view.addSubview(eraserView)
        eraserView.setImage(image: self.image)
        
        // Flip View
        flipView  = ImageFlipView(frame: evRect)
        flipView.delegate = self
        self.view.addSubview(flipView)
        flipView.setImage(image: self.image)
        
        
        isEraserViewAppeared = true
        isCropViewAppeared = false
        isFlipViewAppeared = false
        
    }
    
    // MARK: - Bottom Bar Delegates
    
    func updateCurrentImage() {
        self.image = eraserView.imageView.image
        if isCropViewAppeared {
            self.image = eraserView.imageView.image
        } else if isFlipViewAppeared {
            self.image = cropView.imageView.image
        }
    }
    
    func bottomMenuBar_ResetButtonTapped() {
        flipView.setImage(image: self.originalImage)
        cropView.setImage(image: self.originalImage)
        eraserView.setImage(image: self.originalImage)
    }
    
    func bottomMenuBar_EraseButtonTapped() {
        updateCurrentImage()
        isEraserViewAppeared = true
        isCropViewAppeared = false
        isFlipViewAppeared = false
        
        if (self.image != nil) {
            eraserView.setImage(image: self.image)
        }
        self.view.addSubview(eraserView)
        self.view.bringSubviewToFront(eraserView)
    }
    
    func bottomMenuBar_CropButtonTapped() {
        updateCurrentImage()
        isEraserViewAppeared = false
        isCropViewAppeared = true
        isFlipViewAppeared = false
        
        if (self.image != nil) {
            cropView.setImage(image: self.image)
        }
        self.view.addSubview(cropView)
        self.view.bringSubviewToFront(cropView)
    }
    
    func bottomMenuBar_FlipButtonTapped() {
        updateCurrentImage()
        isEraserViewAppeared = false
        isCropViewAppeared = false
        isFlipViewAppeared = true
        
        if (self.image != nil) {
            flipView.setImage(image: self.image)
        }
        self.view.addSubview(flipView)
        self.view.bringSubviewToFront(flipView)
    }
    
    
    
    // MARK: - Eraser View Delegates
    func imageEraserView_CrossButtonTapped() {
        dismissSelf()
    }
    
    func imageEraserView_TickButtonTapped(image: UIImage) {
        if (delegate != nil) {
            delegate.editVC_dismissedWith?(image: image)
        }
        dismissSelf()
    }
    
    // MARK: - Crop View Delegates
    func imageCropView_CrossButtonTapped() {
        dismissSelf()
    }
    
    func imageCropView_TickButtonTapped(image: UIImage) {
        if (delegate != nil) {
            delegate.editVC_dismissedWith?(image: image)
        }
        dismissSelf()
    }
    
    func imageCropView_hFlipButtonTapped() {
        
    }
    
    func imageCropView_vFlipButtonTapped() {
        
    }
    
    // MARK: - Eraser View Delegates
    func imageFlipView_CrossButtonTapped() {
        dismissSelf()
    }
    
    func imageFlipView_TickButtonTapped(image: UIImage) {
        if (delegate != nil) {
            delegate.editVC_dismissedWith?(image: image)
        }
        dismissSelf()
    }
    
    
    func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }
}
