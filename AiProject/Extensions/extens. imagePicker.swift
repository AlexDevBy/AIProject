//
//  extens. imagePicker.swift
//  PasswordImages
//
//  Created by Alex Misko on 25.01.22.
//

import Foundation
import UIKit

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        if let image = info[.editedImage] as? UIImage {
            addImageObject(image)
        } else if let image = info[.originalImage] as? UIImage {
            addImageObject(image)
        }
        picker.dismiss(animated: true, completion: nil)
        let controller = LibraryViewController()
//        self.navigationController?.pushViewController(controller, animated: true)
        let imageContainer = Manager.shared.loadImageArray()
        controller.array = imageContainer
    }
    func addImageObject(_ image: UIImage) {
        if let imageString = Manager.shared.saveImage(image) {
            let newImageObject = ImageInfo(name: imageString, isLiked: false, text: "")
            Manager.shared.addImageArray(newImageObject)
        }
            
    }
}
