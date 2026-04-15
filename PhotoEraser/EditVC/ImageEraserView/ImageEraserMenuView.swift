//
//  ImageEraserMenuView.swift
//  ImageEraser
//
//  Created by Rashed Nizam on 10/9/20.
//  Copyright © 2020 Rashed Nizam. All rights reserved.
//

import UIKit

public protocol ImageEraserMenuViewDelegate {
    func imageEraserMenuView_sizeValueDidChange(value: CGFloat)
    func imageEraserMenuView_strengthValueDidChange(value: CGFloat)
    func imageEraserMenuView_offsetValueDidChange(value: CGFloat)
    
    func imageEraserMenuView_leftButtonTapped()
    func imageEraserMenuView_rightButtonTapped()
    func imageEraserMenuView_upButtonTapped()
    func imageEraserMenuView_downButtonTapped()
}

class ImageEraserMenuView: UIView {

    var delegate: ImageEraserMenuViewDelegate!
    
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
        
        // ------------------------ Sliders ------------------------
        var buttonWidth:CGFloat = 48
        var buttonHeight:CGFloat = 48
        
        // Size Icon
        let sizeIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        containerView.addSubview(sizeIcon)
        sizeIcon.center = CGPoint(x: containerView.bounds.width*0.125, y: containerView.bounds.height*0.25)
        sizeIcon.image = UIImage(named: "ev_size_icon")

        // Size Slider
        let sizeSlider = UISlider.init(frame: CGRect(x: 0, y: 0, width: containerView.bounds.width*0.27, height: 30))
        containerView.addSubview(sizeSlider)
        sizeSlider.center = CGPoint(x: containerView.bounds.width*0.33, y: containerView.bounds.height*0.25)
        sizeSlider.minimumValue = 4
        sizeSlider.maximumValue = 120
        sizeSlider.value = 50
        sizeSlider.addTarget(self, action: #selector(self.sizeSliderValueDidChange(slider:)), for: .valueChanged)
        sizeSlider.setThumbImage(UIImage(named: "ev_slider_thumb"), for: .normal)
        sizeSlider.tintColor = UIColor(displayP3Red: 188/255.0, green: 38/255.0, blue: 89/255.0, alpha: 1.0)
        sizeSlider.maximumTrackTintColor = UIColor(displayP3Red: 78/255.0, green: 78/255.0, blue: 78/255.0, alpha: 1.0)
        
        // Strength Icon
        let strenghtIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        containerView.addSubview(strenghtIcon)
        strenghtIcon.center = CGPoint(x: containerView.bounds.width*0.125, y: containerView.bounds.height*0.69)
        strenghtIcon.image = UIImage(named: "ev_strength_icon")
        
        // Strength Slider
        let strengthSlider = UISlider.init(frame: CGRect(x: 0, y: 0, width: containerView.bounds.width*0.27, height: 30))
        containerView.addSubview(strengthSlider)
        strengthSlider.center = CGPoint(x: containerView.bounds.width*0.33, y: containerView.bounds.height*0.68)
        strengthSlider.minimumValue = 0
        strengthSlider.maximumValue = 1.0
        strengthSlider.value = 0.2
        strengthSlider.addTarget(self, action: #selector(self.strengthSliderValueDidChange(slider:)), for: .valueChanged)
        strengthSlider.setThumbImage(UIImage(named: "ev_slider_blur_thumb"), for: .normal)
        strengthSlider.tintColor = UIColor(displayP3Red: 188/255.0, green: 38/255.0, blue: 89/255.0, alpha: 1.0)
        strengthSlider.maximumTrackTintColor = UIColor(displayP3Red: 78/255.0, green: 78/255.0, blue: 78/255.0, alpha: 1.0)

        
        // Offset Text
        let offsetIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        containerView.addSubview(offsetIcon)
        offsetIcon.center = CGPoint(x: containerView.bounds.width*0.60, y: containerView.bounds.height*0.25)
        offsetIcon.image = UIImage(named: "ev_offset_icon")
        
        // Strength Slider
        let offsetSlider = UISlider.init(frame: CGRect(x: 0, y: 0, width: containerView.bounds.width*0.27, height: 30))
        containerView.addSubview(offsetSlider)
        offsetSlider.center = CGPoint(x: containerView.bounds.width*0.81, y: containerView.bounds.height*0.25)
        offsetSlider.minimumValue = 30
        offsetSlider.maximumValue = 150
        offsetSlider.value = 80
        offsetSlider.addTarget(self, action: #selector(self.offsetSliderValueDidChange(slider:)), for: .valueChanged)
        offsetSlider.setThumbImage(UIImage(named: "ev_slider_thumb"), for: .normal)
        offsetSlider.tintColor = UIColor(displayP3Red: 188/255.0, green: 38/255.0, blue: 89/255.0, alpha: 1.0)
        offsetSlider.maximumTrackTintColor = UIColor(displayP3Red: 78/255.0, green: 78/255.0, blue: 78/255.0, alpha: 1.0)

        
        // ------------------------ Arrow Buttons ------------------------
        buttonWidth = 25
        buttonHeight = 25
        
        // Circle
        let circleIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        containerView.addSubview(circleIcon)
        circleIcon.center = CGPoint(x: containerView.bounds.width*0.75, y: containerView.bounds.height*0.67)
        circleIcon.image = UIImage(named: "ev_controller_circle")
        
        // Left Button
        leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        leftButton.center = CGPoint(x: circleIcon.center.x-buttonWidth-4, y: circleIcon.center.y)
        containerView.addSubview(leftButton)
        leftButton.backgroundColor = UIColor.clear
        leftButton.setImage(UIImage(named:"ev_left_normal"), for: .normal)
        leftButton.imageView?.contentMode = .scaleAspectFit
        leftButton.addTarget(self, action: #selector(self.leftButtonTapped(button:)), for: .touchUpInside)
        
        // Right Button
        rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        rightButton.center = CGPoint(x: circleIcon.center.x+buttonWidth+4, y: circleIcon.center.y)
        containerView.addSubview(rightButton)
        rightButton.backgroundColor = UIColor.clear
        rightButton.setImage(UIImage(named:"ev_right_normal"), for: .normal)
        rightButton.imageView?.contentMode = .scaleAspectFit
        rightButton.addTarget(self, action: #selector(self.rightButtonTapped(button:)), for: .touchUpInside)
        
        // Up Button
        upButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        upButton.center = CGPoint(x: circleIcon.center.x, y: circleIcon.center.y-buttonWidth-4)
        containerView.addSubview(upButton)
        upButton.backgroundColor = UIColor.clear
        upButton.setImage(UIImage(named:"ev_up_selected"), for: .normal)
        upButton.imageView?.contentMode = .scaleAspectFit
        upButton.addTarget(self, action: #selector(self.upButtonTapped(button:)), for: .touchUpInside)
        
        // Down Button
        downButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        downButton.center = CGPoint(x: circleIcon.center.x, y: circleIcon.center.y+buttonWidth+4)
        containerView.addSubview(downButton)
        downButton.backgroundColor = UIColor.clear
        downButton.setImage(UIImage(named:"ev_down_normal"), for: .normal)
        downButton.imageView?.contentMode = .scaleAspectFit
        downButton.addTarget(self, action: #selector(self.downButtonTapped(button:)), for: .touchUpInside)
    }
    
    // MARK: Slider
    @objc func sizeSliderValueDidChange(slider: UISlider) {
        if (delegate != nil) {
            delegate.imageEraserMenuView_sizeValueDidChange(value: CGFloat(slider.value))
        }
    }
    
    @objc func strengthSliderValueDidChange(slider: UISlider) {
        if (delegate != nil) {
            delegate.imageEraserMenuView_strengthValueDidChange(value: CGFloat(slider.value))
        }
    }
    
    @objc func offsetSliderValueDidChange(slider: UISlider) {
        if (delegate != nil) {
            delegate.imageEraserMenuView_offsetValueDidChange(value: CGFloat(slider.value))
        }
    }
    
    // MARK: left right up down
    @objc func leftButtonTapped(button: UIButton) {
        leftButton.setImage(UIImage(named:"ev_left_normal"), for: .normal)
        rightButton.setImage(UIImage(named:"ev_right_normal"), for: .normal)
        upButton.setImage(UIImage(named:"ev_up_normal"), for: .normal)
        downButton.setImage(UIImage(named:"ev_down_normal"), for: .normal)
        
        button.setImage(UIImage(named:"ev_left_selected"), for: .normal)
        
        if (delegate != nil) {
            delegate.imageEraserMenuView_leftButtonTapped()
        }
    }
    
    @objc func rightButtonTapped(button: UIButton) {
        leftButton.setImage(UIImage(named:"ev_left_normal"), for: .normal)
        rightButton.setImage(UIImage(named:"ev_right_normal"), for: .normal)
        upButton.setImage(UIImage(named:"ev_up_normal"), for: .normal)
        downButton.setImage(UIImage(named:"ev_down_normal"), for: .normal)
        
        button.setImage(UIImage(named:"ev_right_selected"), for: .normal)
        if (delegate != nil) {
            delegate.imageEraserMenuView_rightButtonTapped()
        }
    }
    
    @objc func upButtonTapped(button: UIButton) {
        leftButton.setImage(UIImage(named:"ev_left_normal"), for: .normal)
        rightButton.setImage(UIImage(named:"ev_right_normal"), for: .normal)
        upButton.setImage(UIImage(named:"ev_up_normal"), for: .normal)
        downButton.setImage(UIImage(named:"ev_down_normal"), for: .normal)
        
        button.setImage(UIImage(named:"ev_up_selected"), for: .normal)
        if (delegate != nil) {
            delegate.imageEraserMenuView_upButtonTapped()
        }
    }
    
    @objc func downButtonTapped(button: UIButton) {
        leftButton.setImage(UIImage(named:"ev_left_normal"), for: .normal)
        rightButton.setImage(UIImage(named:"ev_right_normal"), for: .normal)
        upButton.setImage(UIImage(named:"ev_up_normal"), for: .normal)
        downButton.setImage(UIImage(named:"ev_down_normal"), for: .normal)
        
        button.setImage(UIImage(named:"ev_down_selected"), for: .normal)
        if (delegate != nil) {
            delegate.imageEraserMenuView_downButtonTapped()
        }
    }
    
}
