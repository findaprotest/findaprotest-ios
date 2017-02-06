//
//  UIViewController+Extensions.swift
//  FindAProtest
//
//  Created by Pratikbhai Patel on 2/6/17.
//  Copyright © 2017 Find a Protest. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func show(error: FAPError, completion: (() -> Void)?) {
        let alertController = UIAlertController(title: error.title, message: error.title, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: completion)
    }
    
}
