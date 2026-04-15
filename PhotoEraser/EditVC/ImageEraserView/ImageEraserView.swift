//
//  ImageEraserView.swift
//  ImageEraser
//
//  Created by Rashed Nizam on 29/8/20.
//  Copyright © 2020 Rashed Nizam. All rights reserved.
//

import UIKit

public protocol ImageEraserViewDelegate {
    func imageEraserView_CrossButtonTapped()
    func imageEraserView_TickButtonTapped(image: UIImage)
}

class ImageEraserView: UIView, ImageEraserUndoManagerDelegate, ImageEraserMenuBarDelegate, ImageEraserMenuViewDelegate {
    
    
    // MARK: Declarations
    var delegate: ImageEraserViewDelegate!
    
    var eraserUndoManager : ImageEraserUndoManager!
    
    var menuViewHeight:CGFloat!
    var menuBar : ImageEraserMenuBar!
    
    var containerView : UIView!
    
    var image : UIImage!
    var currentImage : UIImage!
    var imageView : UIImageView!
    
    var eraserSize:CGFloat = 50
    var eraserOffset:CGFloat = 65
    var eraserStrength:CGFloat = 0.1
    
    var isEraserInLeftSide:Bool = false
    var isEraserInRightSide:Bool = false
    var isEraserInUpSide:Bool = true
    var isEraserInDownSide:Bool = false
    
    var eraserCircle : UIView!
    var touchPad : UIImageView!
    
    
    // MARK:- Initial Methods
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        self.backgroundColor = UIColor.black

        // Undo Manager
        eraserUndoManager = ImageEraserUndoManager()
        eraserUndoManager.delegate = self
        
        menuViewHeight = 234.0
        
        createEraserInterface()
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
        menuBar = ImageEraserMenuBar.init(frame: CGRect(x: 0, y: 0, width: containerView.bounds.width, height: barHeight))
        menuBar.delegate = self
        containerView.addSubview(menuBar)
        
        // ------------------------ Menu ------------------------
        let menuInterface = ImageEraserMenuView.init(frame: CGRect(x: 0, y: barHeight, width: containerView.bounds.width, height: containerView.bounds.height-barHeight))
        menuInterface.delegate = self
        containerView.addSubview(menuInterface)
        
    }
    
    func createEraserInterface() {
        
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
        imageView.contentMode = .scaleAspectFit
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchOnImageView(_:)))
        containerView.addGestureRecognizer(pinchGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanOnImageView(_:)))
        containerView.addGestureRecognizer(panGesture)
        
        // Eraser Circle
        eraserCircle = UIView(frame: CGRect(x: 0, y: 0, width: eraserSize, height: eraserSize))
        containerView.addSubview(eraserCircle)
        eraserCircle.backgroundColor = UIColor.clear
        
        // Touch Pad
        touchPad = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        containerView.addSubview(touchPad)
        touchPad.image = UIImage(named: "ev_touch_pad")
        touchPad.center = CGPoint(x: containerView.bounds.width/2, y: containerView.bounds.height/2+40)
        
        let panG = UIPanGestureRecognizer(target: self, action: #selector(handlePanOnTouchPad(_:)))
        touchPad.addGestureRecognizer(panG)
        touchPad.isUserInteractionEnabled = true
        
        updateEraserPosition()
        
        let lineWidth:CGFloat = 2.0;
        let radius:CGFloat = eraserSize/2;
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: eraserSize/2, y: eraserSize/2), radius: radius, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor(displayP3Red: 188/255.0, green: 38/255.0, blue: 89/255.0, alpha: 1.0).cgColor
        shapeLayer.lineWidth = lineWidth
        eraserCircle.layer.addSublayer(shapeLayer)
        
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
        eraserUndoManager.reset()
    }
    
    // MARK:- Menu Bar
    func imageEraserMenuBar_CrossButtonTapped() {
//        print("cross")
        
        if (delegate != nil) {
            delegate.imageEraserView_CrossButtonTapped()
        }
        
//        eraserUndoManager.reset()
//        self.removeFromSuperview()
    }
    
    func imageEraserMenuBar_TickButtonTapped() {
//        print("tick")
        
        if (delegate != nil) {
            delegate.imageEraserView_TickButtonTapped(image: imageView.image!)
        }
        
//        eraserUndoManager.reset()
//        self.removeFromSuperview()
    }
    
    func imageEraserMenuBar_UndoButtonTapped() {
//        print("undo")
        eraserUndoManager.undo()
    }
    
    func imageEraserMenuBar_RedoButtonTapped() {
//        print("redo")
        eraserUndoManager.redo()
    }
    
    // MARK: - Slider
    func imageEraserMenuView_sizeValueDidChange(value: CGFloat) {
        print(round(value))
        eraserSize = value;
        
        eraserCircle.frame = CGRect(x: 0, y: 0, width: value, height: value)
        updateEraserPosition()
        
        eraserCircle.layer.sublayers?.removeAll()
        
        let lineWidth:CGFloat = 2.0;
        let radius:CGFloat = eraserSize/2;
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: eraserSize/2, y: eraserSize/2), radius: radius, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor(displayP3Red: 188/255.0, green: 38/255.0, blue: 89/255.0, alpha: 1.0).cgColor
        shapeLayer.lineWidth = lineWidth
        eraserCircle.layer.addSublayer(shapeLayer)
    }
    
    func imageEraserMenuView_strengthValueDidChange(value: CGFloat) {
        print(value)
        eraserStrength = value
    }
    
    func imageEraserMenuView_offsetValueDidChange(value: CGFloat) {
        print(round(value))
        eraserOffset = value
        updateEraserPosition()
    }
    
    
    // MARK:- left right up down
    func imageEraserMenuView_leftButtonTapped() {
        print("left")
        isEraserInLeftSide = true;
        isEraserInRightSide = false;
        isEraserInUpSide = false;
        isEraserInDownSide = false;
        updateEraserPositionWhenArrowButtonTapped()
    }
    
    func imageEraserMenuView_rightButtonTapped() {
        print("right")
        isEraserInLeftSide = false;
        isEraserInRightSide = true;
        isEraserInUpSide = false;
        isEraserInDownSide = false;
        updateEraserPositionWhenArrowButtonTapped()
    }
    
    func imageEraserMenuView_upButtonTapped() {
        print("up")
        isEraserInLeftSide = false;
        isEraserInRightSide = false;
        isEraserInUpSide = true;
        isEraserInDownSide = false;
        updateEraserPositionWhenArrowButtonTapped()
    }
    
    func imageEraserMenuView_downButtonTapped() {
        print("down")
        isEraserInLeftSide = false;
        isEraserInRightSide = false;
        isEraserInUpSide = false;
        isEraserInDownSide = true;
        updateEraserPositionWhenArrowButtonTapped()
    }
    
    // MARK:- Gesture Methods
    var oldPoint = CGPoint.zero
    var newPoint = CGPoint.zero
    var eraserPath = UIBezierPath()
    @objc func handlePanOnTouchPad(_ sender: UIPanGestureRecognizer) {
        
        // Update TouchPad Position
        let translation = sender.translation(in: self)
        if let view = sender.view {
            updateTouchPadPosition(center: CGPoint(x:view.center.x + translation.x, y:view.center.y + translation.y))
        }
        sender.setTranslation(CGPoint.zero, in: self)
        
        // Erase Image
        if sender.state == .began {
            currentImage = imageView.image
            oldPoint = containerView.convert(eraserCircle.center, to: imageView)
            eraserPath.removeAllPoints()
            eraserPath.move(to: pointOnImage(point: oldPoint, imgView: imageView))
        }
        newPoint = containerView.convert(eraserCircle.center, to: imageView)
        eraserPath.addLine(to: pointOnImage(point: newPoint, imgView: imageView))
        oldPoint = newPoint
                
        imageView.image = currentImage
        for _ in  1 ... 5 {
            eraseImageWithPathSizeAndStrength(path: eraserPath, eraserSize: eraserSize, eraserStrength: eraserStrength, viewScale: imageView.transform.a)
        }
        
        // Update Undo
        if sender.state == .ended {
            
            let dictionary: NSDictionary = [
                "path" : eraserPath.copy() as! UIBezierPath,
                "eraserSize" : eraserSize,
                "eraserStrength" : eraserStrength,
                "viewScale" : imageView.transform.a
            ]
            eraserUndoManager.addObject(object: dictionary)
        }
    }
    
    func eraseImageWithPathSizeAndStrength (path:UIBezierPath, eraserSize:CGFloat, eraserStrength:CGFloat, viewScale:CGFloat) {
                
        let vSize: CGSize = image.size
        
        UIGraphicsBeginImageContext(vSize)
        self.imageView.image?.draw(in: CGRect(x: 0, y: 0, width: vSize.width, height: vSize.height))
        
        var blurWidth: CGFloat = (eraserSize/viewScale)*eraserStrength*0.5
        var lineWidth:CGFloat = (eraserSize/viewScale) - blurWidth*1.5;
        blurWidth *= (vSize.width/imageView.bounds.width)
        lineWidth *= (vSize.width/imageView.bounds.width)
        
        UIGraphicsGetCurrentContext()!.saveGState()
        UIGraphicsGetCurrentContext()!.setShouldAntialias(true)
        UIGraphicsGetCurrentContext()!.setLineCap(CGLineCap.round)
        UIGraphicsGetCurrentContext()!.setLineWidth(lineWidth)
        UIGraphicsGetCurrentContext()!.setShadow(offset: CGSize(width: 0, height: 0), blur: blurWidth)
        UIGraphicsGetCurrentContext()!.setBlendMode(CGBlendMode.clear)
        UIGraphicsGetCurrentContext()!.addPath(path.cgPath)
        UIGraphicsGetCurrentContext()!.strokePath()
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsGetCurrentContext()!.restoreGState()
        UIGraphicsEndImageContext()
    }
    
    func pointOnImage(point: CGPoint, imgView:UIImageView) -> CGPoint {
        if imgView.image == nil {
            return point
        }
        
        let iSize: CGSize = imgView.image!.size
        return CGPoint(x: point.x*(iSize.width/imgView.bounds.width), y: point.y*(iSize.height/imgView.bounds.height));
    }
    
    func updateImageViewPosition() {
        
        let inset:CGFloat = containerView.bounds.width*0.4;
        let ivOrigin = imageView.frame.origin;
        let ivEnd = CGPoint(x: ivOrigin.x + imageView.frame.width, y: ivOrigin.y + imageView.frame.height)
        
        if ivOrigin.x > inset {
            imageView.frame.origin.x = inset
        }
        if ivOrigin.y > inset {
            imageView.frame.origin.y = inset
        }
        
        if ivEnd.x < containerView.bounds.width-inset {
            imageView.frame.origin.x = (containerView.bounds.width-inset) - imageView.frame.width
        }
        if ivEnd.y < containerView.bounds.height-inset {
            imageView.frame.origin.y = (containerView.bounds.height-inset) - imageView.frame.height
        }
    }
    
    @objc func handlePanOnImageView(_ sender: UIPanGestureRecognizer) {
        
        // Updater TouchPad Position
        let translation = sender.translation(in: self)
        imageView.center = CGPoint(x:imageView.center.x + translation.x, y:imageView.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self)
        
        // Limit position
        updateImageViewPosition()
    }
    
    @objc func handlePinchOnImageView(_ sender: UIPinchGestureRecognizer) {
        
        if imageView.transform.a > 0.8 || sender.scale >= 1.0 {
            imageView.transform = imageView.transform.scaledBy(x: sender.scale, y: sender.scale)
        }
        sender.scale = 1
        
        // Limit position
        updateImageViewPosition()
    }
    
    
    // MARK: - Touch Events
    var isTouchBegan = false;
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouchBegan = true
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.isTouchBegan = false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTouchBegan {
            if let touch: UITouch = touches.first {
                let currentPoint = touch.location(in: self)
                if containerView.frame.contains(currentPoint) {
                    updateTouchPadPosition(center: currentPoint)
                }
            }
        }
    }
    
    func updateTouchPadPosition(center: CGPoint) {
        
        touchPad.center = center
        
        if touchPad.center.x < 0 {
            touchPad.center = CGPoint(x: 0, y: touchPad.center.y)
        }
        if touchPad.center.x > containerView.bounds.width {
            touchPad.center = CGPoint(x: containerView.bounds.width, y: touchPad.center.y)
        }
        if touchPad.center.y < 0 {
            touchPad.center = CGPoint(x: touchPad.center.x, y: 0)
        }
        if touchPad.center.y > containerView.bounds.height {
            touchPad.center = CGPoint(x: touchPad.center.x, y: containerView.bounds.height)
        }
        
        updateEraserPosition()
    }
    
    func updateEraserPosition() {
        
        var eraserCircleCenter = CGPoint(x: touchPad.center.x, y:touchPad.center.y - eraserOffset)
        
        if isEraserInLeftSide {
            eraserCircleCenter = CGPoint(x: touchPad.center.x - eraserOffset, y:touchPad.center.y)
        } else
        if isEraserInRightSide {
            eraserCircleCenter = CGPoint(x: touchPad.center.x + eraserOffset, y:touchPad.center.y)
        } else
        if isEraserInUpSide {
            eraserCircleCenter = CGPoint(x: touchPad.center.x, y:touchPad.center.y - eraserOffset)
        } else {
            eraserCircleCenter = CGPoint(x: touchPad.center.x, y:touchPad.center.y + eraserOffset)
        }
        
        eraserCircle.center = eraserCircleCenter
    }
    
    func updateEraserPositionWhenArrowButtonTapped() {
        
        var midPoint = CGPointCenter(from: touchPad.center, to: eraserCircle.center)
        
        var touchPadCenter = touchPad.center
        var eraserCircleCenter = eraserCircle.center
        
        if isEraserInLeftSide {
            if midPoint.x < eraserOffset/2 {
                midPoint.x = eraserOffset/2
            }
            if midPoint.x > containerView.bounds.width - eraserOffset/2 {
                midPoint.x = containerView.bounds.width - eraserOffset/2
            }
            touchPadCenter = CGPoint(x: midPoint.x + eraserOffset/2, y:midPoint.y)
            eraserCircleCenter = CGPoint(x: midPoint.x - eraserOffset/2, y:midPoint.y)
        } else
        if isEraserInRightSide {
            if midPoint.x < eraserOffset/2 {
                midPoint.x = eraserOffset/2
            }
            if midPoint.x > containerView.bounds.width - eraserOffset/2 {
                midPoint.x = containerView.bounds.width - eraserOffset/2
            }
            touchPadCenter = CGPoint(x: midPoint.x - eraserOffset/2, y:midPoint.y)
            eraserCircleCenter = CGPoint(x: midPoint.x + eraserOffset/2, y:midPoint.y)
        } else
        if isEraserInUpSide {
            if midPoint.y < eraserOffset/2 {
                midPoint.y = eraserOffset/2
            }
            if midPoint.y > containerView.bounds.height - eraserOffset/2 {
                midPoint.y = containerView.bounds.height - eraserOffset/2
            }
            touchPadCenter = CGPoint(x: midPoint.x, y:midPoint.y + eraserOffset/2)
            eraserCircleCenter = CGPoint(x: midPoint.x, y:midPoint.y - eraserOffset/2)
        } else {
            if midPoint.y < eraserOffset/2 {
                midPoint.y = eraserOffset/2
            }
            if midPoint.y > containerView.bounds.height - eraserOffset/2 {
                midPoint.y = containerView.bounds.height - eraserOffset/2
            }
            touchPadCenter = CGPoint(x: midPoint.x, y:midPoint.y - eraserOffset/2)
            eraserCircleCenter = CGPoint(x: midPoint.x, y:midPoint.y + eraserOffset/2)
        }
        
        UIView.animate(withDuration: 0.25) {
            self.touchPad.center = touchPadCenter
            self.eraserCircle.center = eraserCircleCenter
        }
    }
    
    func CGPointCenter(from: CGPoint, to: CGPoint) -> CGPoint {
        return CGPoint(x: (from.x+to.x)/2, y: (from.y+to.y)/2)
    }
    
    // MARK: - Undo Manager Delegates
    func imageEraserUndoManager_ReachedToStart(isReached: Bool) {
        if menuBar != nil {
            menuBar.enableUndoButton(isEnable: !isReached)
        }
    }
    
    func imageEraserUndoManager_ReachedToEnd(isReached: Bool) {
        if menuBar != nil {
            menuBar.enableRedoButton(isEnable: !isReached)
        }
    }
    
    func imageEraserUndoManager_UndoneWithPaths(dics: [NSDictionary]) {
        eraseImageWithPaths(dics: dics)
    }
    
    func imageEraserUndoManager_RedoneWithPaths(dics: [NSDictionary]) {
        eraseImageWithPaths(dics: dics)
    }
    
    func eraseImageWithPaths(dics: [NSDictionary]) {
        imageView.image = image
        for dic in dics {
            let path = dic["path"] as! UIBezierPath
            let eraserSize = dic["eraserSize"] as! CGFloat
            let eraserStrength = dic["eraserStrength"] as! CGFloat
            let viewScale = dic["viewScale"] as! CGFloat
            for _ in  1 ... 5 {
                eraseImageWithPathSizeAndStrength(path: path, eraserSize: eraserSize, eraserStrength: eraserStrength, viewScale: viewScale)
            }
        }
    }
    
}
