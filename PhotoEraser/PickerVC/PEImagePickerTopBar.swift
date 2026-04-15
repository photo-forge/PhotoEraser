//
//  PEImagePickerTopBar.swift
//  ImageEraser
//
//  Created by Rashed Nizam on 31/8/20.
//  Copyright © 2020 Rashed Nizam. All rights reserved.
//

import UIKit

public protocol PEImagePickerTopBarDelegate {
    func imagePickerTopBar_DownButtonTapped()
    func imagePickerTopBar_SearchButtonTapped()
}

class PEImagePickerTopBar: UIView {
    
    var delegate:PEImagePickerTopBarDelegate!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override init(frame: CGRect) {
        super.init(frame : frame)
        
        createInterface()
    }
        
    func createInterface() {
        
        let sWidth:CGFloat = self.bounds.width
        let sHeight:CGFloat = self.bounds.height
        
        // Bar
        let barView = UIView.init(frame:CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        barView.backgroundColor = UIColor.clear
        self.addSubview(barView)
        
        var buttonWidth:CGFloat = sHeight
        var buttonHeight:CGFloat = sHeight
        
        // Cross Button
        let crossButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        crossButton.center = CGPoint(x: 8+buttonWidth/2, y: sHeight/2)
        barView.addSubview(crossButton)
        crossButton.backgroundColor = UIColor.clear
        crossButton.setImage(UIImage(named:"ev_down_normal"), for: .normal)
        crossButton.imageView?.contentMode = .scaleAspectFit
        crossButton.addTarget(self, action: #selector(self.downButtonTapped), for: .touchUpInside)
        
        
        buttonWidth = sHeight*0.85
        buttonHeight = sHeight*0.85
        
        // Search Button
        let searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        searchButton.center = CGPoint(x: sWidth/2, y: sHeight/2)
        barView.addSubview(searchButton)
        searchButton.backgroundColor = UIColor.clear
        searchButton.setImage(UIImage(named:"ev_undo_button"), for: .normal)
        searchButton.imageView?.contentMode = .scaleAspectFit
        searchButton.addTarget(self, action: #selector(self.searchButtonTapped), for: .touchUpInside)
        searchButton.isEnabled = true
        
    }
    
    @objc func downButtonTapped() {
        if (delegate != nil) {
            delegate.imagePickerTopBar_DownButtonTapped()
        }
    }
    
    
    @objc func searchButtonTapped() {
        
        if (delegate != nil) {
            delegate.imagePickerTopBar_SearchButtonTapped()
        }
    }
    
}
