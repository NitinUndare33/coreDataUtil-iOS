//
//  ImageWork.swift
//  CoreDataDemo
//
//  Created by Apple on 17/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ImageWork: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var txtRadious: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var txtWidth: UITextField!
    @IBOutlet weak var txtHeight: UITextField!
    let imagePicker  = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.getImage()

        // Do any additional setup after loading the view.
    }

    func showCroper(img : UIImage) {
        var config = ImageCropperConfiguration(with: img, and: .circle)
        //config.maskFillColor = UIColor(displayP3Red: 0.7, green: 0.5, blue: 0.2, alpha: 0.75)
        config.maskFillColor = UIColor.black.withAlphaComponent(0.5)
        config.borderColor = UIColor.black
        
        config.showGrid = true
        config.gridColor = UIColor.white
        config.doneTitle = "CROP"
        config.cancelTitle = "BACK"
        let cropper = ImageCropperViewController.initialize(with: config, completionHandler: { _croppedImage in
            /*
             Code to perform after finishing cropping process
             */
            self.imageView.image = _croppedImage
            self.saveImage(image: _croppedImage!)
            self.dismiss(animated: true, completion: nil)
        })
        self.present(cropper, animated: true, completion: nil)
    }
    
    func saveImage(image : UIImage) {
        ImageManager.sharedInstance().saveImage(image: image, name: "sample.png")
    }
    
    func getImage(){
        self.imageView.image = ImageManager.sharedInstance().getImage(name: "sample.png")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnTakeImage(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func makeRadious(_ sender: Any) {
        let image = ImageManager.sharedInstance().maskRoundedImage(image: imageView.image!, radius: Double(txtRadious.text!) ?? 40.0)
        imageView.image = image
    }
    
    @IBAction func btnConvertImage(_ sender: Any) {
        let image = ImageManager.sharedInstance().cropToBounds(image: imageView.image!, width: Double(txtWidth.text!) ?? 200.0, height: Double(txtHeight.text!) ?? 200.0)
        imageView.image = image
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            imageView.image = ImageManager.sharedInstance().cropToBounds(image: pickedImage, width:200, height: 200)
            dismiss(animated: true, completion: nil)
            self.showCroper(img: pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
