//
//  PEHomeMenuBar.swift
//  PhotoEraser
//
//  Created by Rashed Nizam on 29/5/21.
//

import UIKit

@objc protocol PEHomeMenuBarDelegate {
    
    @objc optional func bottomMenuBar_FGGalleryButtonTapped()
    @objc optional func bottomMenuBar_BGGalleryButtonTapped()
    @objc optional func bottomMenuBar_CanvasButtonTapped()
    @objc optional func bottomMenuBar_FilterButtonTapped()
    @objc optional func bottomMenuBar_OverlayButtonTapped()
    @objc optional func bottomMenuBar_StickerButtonTapped()
    @objc optional func bottomMenuBar_TextButtonTapped()
    @objc optional func bottomMenuBar_DoodleButtonTapped()
}

class PEHomeMenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var delegate:PEHomeMenuBarDelegate!
    
    var collectionView: UICollectionView!
    
    let menuItemNames = ["GalleryButton", "BGButton", "CanvasButton", "FilterButton", "StickerButton", "TextButton"]
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .darkGray
        
        let safeAreaInset: UIEdgeInsets = UIApplication.shared.windows.first!.safeAreaInsets
        let barHeight: CGFloat = frame.height - safeAreaInset.bottom
        
        
        // Collection View
        let cvFrame = CGRect(x: 0, y: 0, width: frame.width, height: barHeight)
        
        let inset:CGFloat = 2.0
        let cellSize:CGFloat = cvFrame.height - inset*2
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        if menuItemNames.count <= 6 {
            layout.sectionInset = UIEdgeInsets(top: inset*2, left: inset*6, bottom: inset, right: inset*6)
//            layout.minimumInteritemSpacing = inset * 2
            let numOfItems: CGFloat = CGFloat(menuItemNames.count)
            let lineSpacing: CGFloat = (cvFrame.width - (layout.sectionInset.left+layout.sectionInset.right) - cellSize*numOfItems-2) / (numOfItems-1)
            layout.minimumLineSpacing = lineSpacing
            layout.itemSize = CGSize(width: cellSize, height: cellSize)
        } else {
            layout.sectionInset = UIEdgeInsets(top: inset, left: inset*3, bottom: inset, right: inset)
            layout.minimumInteritemSpacing = inset * 4
            layout.minimumLineSpacing = inset * 4
            layout.itemSize = CGSize(width: cellSize, height: cellSize)
        }
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
                delegate.bottomMenuBar_FGGalleryButtonTapped?()
            case 1:
                delegate.bottomMenuBar_BGGalleryButtonTapped?()
            case 2:
                delegate.bottomMenuBar_CanvasButtonTapped?()
            case 3:
                delegate.bottomMenuBar_FilterButtonTapped?()
            case 4:
                delegate.bottomMenuBar_StickerButtonTapped?()
            case 5:
                delegate.bottomMenuBar_TextButtonTapped?()
            default:
                delegate.bottomMenuBar_FGGalleryButtonTapped?()
            }
            
        }
    }
    
    
}

class BottomMenuBarCell: UICollectionViewCell {

    var imageView:UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        // Image
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height-6))
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        
    }
    
    override var isSelected: Bool {
        didSet {
//            if self.isSelected {
//                selectedBar.isHidden = false
//            } else {
//                selectedBar.isHidden = true
//            }
        }
    }
    
    
    
    
}
