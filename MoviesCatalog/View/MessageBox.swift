//
//  MessageBox.swift
//  MoviesCatalog
//
//  Created by AHMET SIRMA on 21.08.2022.
//

import Foundation
import UIKit


public final class MessageBox {
    public static func show(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        AppDelegate.current().rootView?.present(alert, animated: true, completion: nil)
    }
}
