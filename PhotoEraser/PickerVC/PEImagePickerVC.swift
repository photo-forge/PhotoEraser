//
//  PEImagePickerVC.swift
//  PhotoEraser
//
//  Created by Kazi Muhammad Tawsif Jamil on 11/6/21.
//

import UIKit
import Photos
import UnsplashPhotoPicker

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    
    func configurecell(image: UIImage){
        imageView.image = image
    }
}

public protocol PEImagePickerVCDelegate {
    func imagePicked(fileName:String, fromFG:Bool)
}

class PEImagePickerVC: UIViewController, PEImagePickerTopBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UnsplashPhotoPickerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {

    var delegate:PEImagePickerVCDelegate!
    
    @IBOutlet weak var cameraRollCollectionView: UICollectionView!
    
    let arr_img = NSMutableArray()
    var assetCollection: PHAssetCollection!
    var photosAsset: PHFetchResult<AnyObject>!
    var assetThumbnailSize: CGSize!
    
    var fromForGround:Bool!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if fromForGround {
            self.view.viewWithTag(13)?.isHidden = true
        }

        // ------------------------------ BAR ------------------------------
        let barHeight:CGFloat = 50.0
        let menuBar = PEImagePickerTopBar.init(frame: CGRect(x: 0, y: Utils.getSafeAreaInset().top, width: self.view.bounds.width, height: barHeight))
        menuBar.delegate = self
        self.view.addSubview(menuBar)
        
        //PH asset collection
        let allPhotosOptions : PHFetchOptions = PHFetchOptions.init()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let allPhotosResult = PHAsset.fetchAssets(with: .image, options: allPhotosOptions)
        allPhotosResult.enumerateObjects({ (asset, idx, stop) in
            self.arr_img.add(asset)
        })
        cameraRollCollectionView.reloadData()
    }
    
    func getAssetThumbnail(asset: PHAsset, size: CGFloat) -> UIImage {
        let retinaScale = UIScreen.main.scale
        let retinaSquare = CGSize(width: size * retinaScale, height: size * retinaScale)//CGSizeMake(size * retinaScale, size * retinaScale)
        let cropSizeLength = min(asset.pixelWidth, asset.pixelHeight)
        let square = CGRect(x: 0, y: 0, width: cropSizeLength, height: cropSizeLength)//CGRectMake(0, 0, CGFloat(cropSizeLength), CGFloat(cropSizeLength))
        let cropRect = square.applying(CGAffineTransform(scaleX: 1.0/CGFloat(asset.pixelWidth), y: 1.0/CGFloat(asset.pixelHeight)))
        
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        var thumbnail = UIImage()
        
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        options.normalizedCropRect = cropRect
        
        manager.requestImage(for: asset, targetSize: retinaSquare, contentMode: .aspectFit, options: options, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return arr_img.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GALLERY_CELL",
                                                      for: indexPath) as! ImageCollectionViewCell
        let imgview : UIImageView = cell.imageView!
        imgview.image = self.getAssetThumbnail(asset: self.arr_img.object(at: indexPath.row) as! PHAsset, size: 150)
        
        return cell
    }
    
    //MARK:UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let img = self.getAssetThumbnail(asset: self.arr_img.object(at: indexPath.row) as! PHAsset, size:CGFloat((self.arr_img.object(at: indexPath.row) as! PHAsset).pixelWidth))
        img.saveToDocuments(filename: "initial_image")
        self.dismiss(animated: true) {
            self.delegate.imagePicked(fileName: "initial_image", fromFG: self.fromForGround)
        }
    }
    
    // UIImagePickerControllerDelegate Methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerTopBar_DownButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerTopBar_SearchButtonTapped() {
        let configuration = UnsplashPhotoPickerConfiguration(
            accessKey: "<YOUR_ACCESS_KEY>",
            secretKey: "<YOUR_SECRET_KEY>",
            allowsMultipleSelection: false
        )
        let unsplashPhotoPicker = UnsplashPhotoPicker(configuration: configuration)
        unsplashPhotoPicker.photoPickerDelegate = self

        present(unsplashPhotoPicker, animated: true, completion: nil)
    }
    
    func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos photos: [UnsplashPhoto]) {
        print("Unsplash photo picker did select \(photos.count) photo(s)")

    }

    func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker) {
        print("Unsplash photo picker did cancel")
    }
    
    
    //MARK: Header Actions
    @IBAction func headerBtnAction(_ sender: UIButton) {
        if sender.tag == 11 {
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
            {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
            }
            else
            {
                let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else if sender.tag == 12 {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                let imag = UIImagePickerController()
                imag.delegate = self
                imag.sourceType = UIImagePickerController.SourceType.photoLibrary;
                imag.allowsEditing = false
                self.present(imag, animated: true, completion: nil)
            }
        }
        else if sender.tag == 13 {
            
        }
        else if sender.tag == 14 {
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.image, UTType.jpeg, UTType.gif, UTType.png], asCopy: true)
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            documentPicker.shouldShowFileExtensions = true
            present(documentPicker, animated: true, completion: nil)
        }
        
        //MARK: documnet picker delegate
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
             
        }
    }
}
