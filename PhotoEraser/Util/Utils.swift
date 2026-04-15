//
//  Utils.swift
//  PhotoEraser
//
//  Created by Kazi Muhammad Tawsif Jamil on 11/6/21.
//

import UIKit
class Utils: NSObject {
    class func getImageWithName(fileName:NSString)->UIImage {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName as String)
            guard let image    = UIImage(contentsOfFile: imageURL.path) else { return UIImage.init()}
           return image
        }
        return UIImage.init()
    }
    
    class func getSafeAreaInset()->UIEdgeInsets {
        return UIApplication.shared.windows.first!.safeAreaInsets
    }
}
