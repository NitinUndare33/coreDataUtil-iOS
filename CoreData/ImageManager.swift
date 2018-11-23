//
//  ImageManager.swift
//  CoreDataDemo
//
//  Created by Apple on 17/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit
public class ImageManager{
    public static var shared : ImageManager!
    public static func sharedInstance() -> ImageManager{
        if shared == nil{
            shared = ImageManager()
        }
        return shared
    }
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        let targetSize = CGSize(width: width, height: height)

        let size = image.size
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        var newSize: CGSize
//        if(widthRatio > heightRatio) {
//            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
//        } else {
//            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
//        }
        
        newSize = CGSize(width: size.width * widthRatio, height: size.height * heightRatio)
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: newSize.width, height: newSize.height))
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

    func maskRoundedImage(image: UIImage, radius: Double) -> UIImage {
        let radiuscorner = CGFloat(radius)
        let imageView: UIImageView = UIImageView(image: image)
        let layer = imageView.layer
        layer.masksToBounds = true
        layer.cornerRadius = radiuscorner
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage!
    }

    private func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    func saveImage(image : UIImage , name : String){
        let fileManager = FileManager.default
        let paths = (self.getDirectoryPath() as NSString).appendingPathComponent(name)
        print(paths)
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    
    func getImage(name : String) -> UIImage?{
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent(name)
        if fileManager.fileExists(atPath: imagePAth){
        return UIImage(contentsOfFile: imagePAth)
        }else{
            print("No Image")
            return nil
        }
    }
    
}
