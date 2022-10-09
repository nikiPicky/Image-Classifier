//
//  Alerts.swift
//  ImageClassifier
//
//  Created by Nikhil Jaggi on 09/10/21.
//

import UIKit

class Alerts {
    
    /*
     var actions: [(String, UIAlertAction.Style, UIColor)] = []
     actions.append(("Archive", UIAlertAction.Style.default, .cyan))
     actions.append(("Delete", UIAlertAction.Style.default, .brown))
     actions.append(("Cancel", UIAlertAction.Style.cancel, nil))
     
     USAGE:-
     
     //self = ViewController
         Alerts.showActionsheet(viewController: self, title: "D_My ActionTitle", message: "General Message in Action Sheet", actions: actions) { (index) in
             print("call action \(index)")
             /*
              switch index {
              cases ...
              }
              */
         }
     */
    
    static func showActionsheet(viewController: UIViewController, title: String?, message: String?, actions: [(String, UIAlertAction.Style, UIColor?)], completion: @escaping (_ index: Int) -> Void) {
    let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
    for (index, (title, style, color)) in actions.enumerated() {
        let alertAction = UIAlertAction(title: title, style: style) { (_) in
            completion(index)
        }
        
        if let color = color {
            alertAction.setValue(color, forKey: "titleTextColor")
        }

        alertViewController.addAction(alertAction)
     }
     // iPad Support
     alertViewController.popoverPresentationController?.sourceView = viewController.view
     
     viewController.present(alertViewController, animated: true, completion: nil)
    }
    
    static func showAlert(viewController: UIViewController, title: String?, message: String?,actions: [(String, UIAlertAction.Style, UIColor?)], completion: @escaping (_ index: Int) -> Void) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
        for (index, (title, style, color)) in actions.enumerated() {
            let alertAction = UIAlertAction(title: title, style: style) { (_) in
                completion(index)
            }
            
            if let color = color {
                alertAction.setValue(color, forKey: "titleTextColor")
            }

            alertViewController.addAction(alertAction)
         }
         // iPad Support
         alertViewController.popoverPresentationController?.sourceView = viewController.view
         
         viewController.present(alertViewController, animated: true, completion: nil)
        }
    
}


