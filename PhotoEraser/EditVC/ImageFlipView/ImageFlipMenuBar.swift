//
//  ImageFlipMenuBar.swift
//  ImageFlip
//
//  Created by Rashed Nizam on 31/8/20.
//  Copyright © 2020 Rashed Nizam. All rights reserved.
//

import UIKit

public protocol ImageFlipMenuBarDelegate {
    func imageFlipMenuBar_CrossButtonTapped()
    func imageFlipMenuBar_TickButtonTapped()
    func imageFlipMenuBar_UndoButtonTapped()
    func imageFlipMenuBar_RedoButtonTapped()
}

class ImageFlipMenuBar: UIView {
    
    var delegate: ImageFlipMenuBarDelegate!
    
    var undoButton: UIButton!
    var redoButton: UIButton!
    
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
        barView.backgroundColor = UIColor.black
        self.addSubview(barView)
        
        var buttonWidth:CGFloat = sHeight
        var buttonHeight:CGFloat = sHeight
        
        // Cross Button
        let crossButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        crossButton.center = CGPoint(x: 8+buttonWidth/2, y: sHeight/2)
        barView.addSubview(crossButton)
        crossButton.backgroundColor = UIColor.clear
        crossButton.setImage(UIImage(named:"ev_cross_button"), for: .normal)
        crossButton.imageView?.contentMode = .scaleAspectFit
        crossButton.addTarget(self, action: #selector(self.crossButtonTapped), for: .touchUpInside)
        
        // Tick Button
        let tickButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        tickButton.center = CGPoint(x: sWidth - (8+buttonWidth/2), y: sHeight/2)
        barView.addSubview(tickButton)
        tickButton.backgroundColor = UIColor.clear
        tickButton.setImage(UIImage(named:"ev_tick_button"), for: .normal)
        tickButton.imageView?.contentMode = .scaleAspectFit
        tickButton.addTarget(self, action: #selector(self.tickButtonTapped), for: .touchUpInside)
        
        
        buttonWidth = sHeight*0.85
        buttonHeight = sHeight*0.85
        
        // Undo Button
        undoButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        undoButton.center = CGPoint(x: sWidth/2 - buttonWidth/2-8, y: sHeight/2)
        barView.addSubview(undoButton)
        undoButton.backgroundColor = UIColor.clear
        undoButton.setImage(UIImage(named:"ev_undo_button"), for: .normal)
        undoButton.imageView?.contentMode = .scaleAspectFit
        undoButton.addTarget(self, action: #selector(self.undoButtonTapped), for: .touchUpInside)
        undoButton.isEnabled = false
        
        // Redo Button
        redoButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        redoButton.center = CGPoint(x: sWidth/2 + buttonWidth/2+8, y: sHeight/2)
        barView.addSubview(redoButton)
        redoButton.backgroundColor = UIColor.clear
        redoButton.setImage(UIImage(named:"ev_redo_button"), for: .normal)
        redoButton.imageView?.contentMode = .scaleAspectFit
        redoButton.addTarget(self, action: #selector(self.redoButtonTapped), for: .touchUpInside)
        redoButton.isEnabled = false
    }
    
    @objc func crossButtonTapped() {
        
        if (delegate != nil) {
            delegate.imageFlipMenuBar_CrossButtonTapped()
        }
    }
    
    @objc func tickButtonTapped() {
        
        if (delegate != nil) {
            delegate.imageFlipMenuBar_TickButtonTapped()
        }
    }
    
    @objc func undoButtonTapped() {
        
        if (delegate != nil) {
            delegate.imageFlipMenuBar_UndoButtonTapped()
        }
    }
    
    @objc func redoButtonTapped() {
        
        if (delegate != nil) {
            delegate.imageFlipMenuBar_RedoButtonTapped()
        }
    }
    
    func enableUndoButton(isEnable:Bool) {
        undoButton.isEnabled = isEnable
    }
    func enableRedoButton(isEnable:Bool) {
        redoButton.isEnabled = isEnable
    }
}
