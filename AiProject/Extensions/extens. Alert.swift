//
//  extens. Alert.swift
//  PasswordImages
//
//  Created by Alex Misko on 13.02.22.
//

import Foundation
import UIKit


extension UIViewController {
    func addAlert(title: String?,
                  message: String?,
                  style: UIAlertController.Style = UIAlertController.Style.alert,
                  okButtonHandler: ((UIAlertAction) -> ())? = nil,
                  cancelButtonHandler: ((UIAlertAction) -> ())? = nil,
                  titleButtonThree: String? = nil,
                  threeButtonHandler: ((UIAlertAction) -> ())? = nil,
                  threeButtonStyle: UIAlertAction.Style = UIAlertAction.Style.default) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: okButtonHandler)
        alert.addAction(okButton)
        if cancelButtonHandler != nil {
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelButtonHandler)
            alert.addAction(cancelButton)
        }
        if threeButtonHandler != nil {
            let threeButton = UIAlertAction(title: titleButtonThree, style: threeButtonStyle, handler: threeButtonHandler)
            alert.addAction(threeButton)
        }
        self.present(alert, animated: true, completion: nil)
    }
}
