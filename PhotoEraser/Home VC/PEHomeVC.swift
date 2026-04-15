//
//  PEHomeVC.swift
//  PhotoEraser
//
//  Created by Rashed Nizam on 29/5/21.
//

import UIKit

extension UIDevice {
    /// Returns `true` if the device has a notch
    var hasNotch: Bool {
        guard #available(iOS 11.0, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
}

class PEHomeVC: UIViewController, PEHomeMenuBarDelegate, StickerMenuViewDelegate, StickerViewDelegate, PEEditVCDelegate, PEImagePickerVCDelegate {
    
    let screenBound = UIScreen.main.bounds
    var safeAreaInset: UIEdgeInsets!
    
    // Container View
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bottomBarContainer: UIView!
    
    @IBOutlet weak var backgroundView: UIImageView!
    
    var selectedSticker : ImageStickerView!
    
    // Sticker
    var stickerMenuView : StickerMenuView!
    var stickerArray : NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stickerArray = NSMutableArray()
        
        createInterface()
        
        // Tap Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        containerView.addGestureRecognizer(tapGesture)
        
        // Image Sticker
        let img = Utils.getImageWithName(fileName: "initial_crop")
        selectedSticker = ImageStickerView(frame: CGRect(x: 0, y: 0, width: 150, height: 250), image:  img, isTypeFG: true)
        selectedSticker.delegate = self
        selectedSticker.center = CGPoint(x: screenBound.width/2, y: 200)
        containerView.addSubview(selectedSticker);
        stickerArray.add(selectedSticker!)
        
    }
    
    @IBAction func crossButtonAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func createInterface() {
        
        print(screenBound)
        safeAreaInset = UIApplication.shared.windows.first?.safeAreaInsets
        print(safeAreaInset.bottom)
        
        // Bottom Menu Bar
        let barHeight:CGFloat = 50+safeAreaInset.bottom
        let rect = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: barHeight)
        let bottomBar: PEHomeMenuBar = PEHomeMenuBar(frame: rect)
        bottomBarContainer.addSubview(bottomBar)
        bottomBar.delegate = self
        
        // Sticker Menu
        let kMenuHeight:CGFloat = screenBound.width*1.0
        let smvRect = CGRect(x: 0, y: screenBound.height-kMenuHeight, width: screenBound.width, height: kMenuHeight)
        stickerMenuView = StickerMenuView(frame: smvRect)
        view.addSubview(stickerMenuView)
        stickerMenuView.isUserInteractionEnabled = true
        stickerMenuView.delegate = self;
        
    }
    
    // MARK:- Bottom Bar Delegates
    
    // FG
    func bottomMenuBar_FGGalleryButtonTapped() {
        print("FG")
        let imgPickerVC = self.storyboard?.instantiateViewController(identifier: "IMAGE_PICKER") as! PEImagePickerVC
        imgPickerVC.fromForGround = true
        imgPickerVC.delegate = self
        self.present(imgPickerVC, animated: true, completion: nil)
    }
    
    // BG
    func bottomMenuBar_BGGalleryButtonTapped() {
        print("BG")
        let imgPickerVC = self.storyboard?.instantiateViewController(identifier: "IMAGE_PICKER") as! PEImagePickerVC
        imgPickerVC.fromForGround = false
        imgPickerVC.delegate = self
        self.present(imgPickerVC, animated: true, completion: nil)
    }
    
    // Canvas
    func bottomMenuBar_CanvasButtonTapped() {
        print("Canvas")
    }
    
    // Filter
    func bottomMenuBar_FilterButtonTapped() {
        print("Filter")
    }
    
    // Overlay
    func bottomMenuBar_OverlayButtonTapped() {
        print("Overlay")
    }
    
    // Sticker
    func bottomMenuBar_StickerButtonTapped() {
        print("Sticker")
        stickerMenuView.appear()
    }
    
    // Text
    func bottomMenuBar_TextButtonTapped() {
        print("Text")
    }
    
    // Doodle
    func bottomMenuBar_DoodleButtonTapped() {
        print("Doodle")
        
    }
    
    // MARK:- Picker Delegate
    func imagePicked(fileName: String, fromFG: Bool) {
        // Image Sticker
        let img = Utils.getImageWithName(fileName: fileName as NSString)
        if fromFG {
            let fgSticker = ImageStickerView(frame: CGRect(x: 0, y: 0, width: 150, height: 250), image:  img, isTypeFG: true)
            fgSticker.delegate = self
            fgSticker.center = CGPoint(x: screenBound.width/2, y: 200)
            containerView.addSubview(fgSticker);
            stickerArray.add(fgSticker)
            
            selectedSticker = fgSticker
        }
        else {
            backgroundView.image = img
        }
    }
    
    // MARK: - Gesture
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) { // Tap
        selectedSticker.deselect()
    }
    
    // MARK: - Edit VC Delegates
    func editVC_dismissedWith(image: UIImage) {
        selectedSticker.imageView.image = image
    }
    
    // MARK: - Sticker View Delegates
    func stickerView_Selected(stickerView: ImageStickerView) {
        selectedSticker = stickerView
        
        // Deselect All Stickers
        for i in 0 ..< stickerArray.count {
            let sticker = stickerArray[i] as! ImageStickerView
            sticker.deselect()
        }
        
        selectedSticker.select()
    }
    
    func stickerView_ImageButtonTapped(stickerView: ImageStickerView) {
        print("Sticker Image Button Tapped")
        
    }
    
    func stickerView_EditButtonTapped(stickerView: ImageStickerView) {
        print("Sticker Edit Button Tapped")
        
        let editVC = self.storyboard!.instantiateViewController(identifier: "PEEditVC") as PEEditVC
        editVC.delegate = self
        editVC.image = selectedSticker.imageView.image
        editVC.originalImage = selectedSticker.imageView.image
        self.present(editVC, animated: true, completion: nil)
    }
    
    
    // MARK: - Sticker Menu Delegates
    func stickerMenuView_BackButtonTapped() {
        print("Back Button")
        
    }
    
    func stickerMenuView_TickButtonTapped() {
        print("Tick Button")
        
    }
    
    func stickerMenuView_didSelectStickerName(stickerName: String) {
        
        let image: UIImage = CommonMethods.ins.uiImageWithName(named: stickerName)
        
        // Image Sticker
        let imageSticker = ImageStickerView(frame: CGRect(x: 0, y: 0, width: 150, height: 150), image: image, isTypeFG: false)
        containerView.addSubview(imageSticker);
        imageSticker.delegate = self;
        imageSticker.center = CGPoint(x: screenBound.width/2, y: 200)
        stickerArray.add(imageSticker)
        
        stickerView_Selected(stickerView: imageSticker)
    }
    
}
