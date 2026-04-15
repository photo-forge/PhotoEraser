//
//  ViewController.swift
//  PhotoEraser
//
//  Created by Arsil Ajim on 29/5/21.
//

import UIKit
import Mantis

class PELandingVC: UIViewController, CropViewControllerDelegate, PEImagePickerVCDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func addButtonAction(_ sender: Any) {
        let imgPickerVC = self.storyboard?.instantiateViewController(identifier: "IMAGE_PICKER") as! PEImagePickerVC
        imgPickerVC.fromForGround = true
        imgPickerVC.delegate = self
        self.present(imgPickerVC, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage]
        let cropViewController = Mantis.cropViewController(image: image as! UIImage)
            cropViewController.delegate = self
        cropViewController.modalPresentationStyle = .fullScreen
        
        self.dismiss(animated: true) {
            self.present(cropViewController, animated: true)
        }
    }
    
    //MARK: Image Picker Delegate
    func imagePicked(fileName: String, fromFG: Bool) {
        let cropViewController = Mantis.cropViewController(image: Utils.getImageWithName(fileName:fileName as NSString))
            cropViewController.delegate = self
        cropViewController.modalPresentationStyle = .fullScreen
        
        self.dismiss(animated: true) {
            self.present(cropViewController, animated: true)
        }
    }
    
    //MARK:: CropViewDelegates
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation) {
        self.dismiss(animated: true) {
            cropped.saveToDocuments(filename:"initial_crop")
            
            let homeVC = self.storyboard?.instantiateViewController(identifier: "PEHomeVC") as! PEHomeVC
            
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
    }
    
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

