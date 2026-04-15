//
//  BottomMenuBar.swift
//  PhotoEraser
//
//  Created by Rashed Nizam on 29/5/21.
//

import UIKit

@objc protocol PEEditMenuBarDelegate {
    
    @objc optional func bottomMenuBar_ResetButtonTapped()
    @objc optional func bottomMenuBar_EraseButtonTapped()
    @objc optional func bottomMenuBar_CropButtonTapped()
    @objc optional func bottomMenuBar_FlipButtonTapped()
}

class PEEditMenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var delegate:PEEditMenuBarDelegate!
    
    var collectionView: UICollectionView!
    
    let menuItemNames = ["ResetButton", "EraseButton", "CropButton", "FlipButton"]
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .darkGray
        
        let safeAreaInset: UIEdgeInsets = UIApplication.shared.windows.first!.safeAreaInsets
        let barHeight: CGFloat = frame.height - safeAreaInset.bottom
        
        
        // Collection View Layout
        let cvFrame = CGRect(x: 0, y: 0, width: frame.width, height: barHeight)
        
        let inset:CGFloat = 2.0
        let cellSize:CGFloat = cvFrame.height - inset*2
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        layout.sectionInset = UIEdgeInsets(top: inset*2, left: inset*16, bottom: inset, right: inset*16)
//            layout.minimumInteritemSpacing = inset * 2
        let numOfItems: CGFloat = CGFloat(menuItemNames.count)
        let lineSpacing: CGFloat = (cvFrame.width - (layout.sectionInset.left+layout.sectionInset.right) - cellSize*numOfItems-2) / (numOfItems-1)
        layout.minimumLineSpacing = lineSpacing
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        
        // Collage View
        collectionView = UICollectionView(frame: cvFrame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        self.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(BottomMenuBarCell.self, forCellWithReuseIdentifier: "MenuItemCell")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItemNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuItemCell", for: indexPath) as! BottomMenuBarCell
        cell.imageView.image = CommonMethods.ins.uiImageWithName(named: menuItemNames[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (delegate != nil) {
            switch indexPath.item {
            case 0:
                delegate.bottomMenuBar_ResetButtonTapped?()
            case 1:
                delegate.bottomMenuBar_EraseButtonTapped?()
            case 2:
                delegate.bottomMenuBar_CropButtonTapped?()
            case 3:
                delegate.bottomMenuBar_FlipButtonTapped?()
            
            default:
                delegate.bottomMenuBar_ResetButtonTapped?()
            }
            
        }
    }
    
    
}
