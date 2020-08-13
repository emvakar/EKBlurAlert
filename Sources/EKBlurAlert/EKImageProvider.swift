//
//  EKImageProvider.swift
//  EKBlurAlert
//
//  Created by Emil Karimov on 13/08/2020.
//  Copyright © 2020 Emil Karimov. All rights reserved.
//

import UIKit

class EKImageProvider: NSObject {
    
    private static var bundle: Bundle?
    private static let onceTracker: () = {
        
        if let bundleURL = Bundle(for: EKImageProvider.self).url(forResource: "EKBlurAlertAssets", withExtension: "bundle") {
            
            if let bundle = Bundle(url: bundleURL) {
                
                EKImageProvider.bundle = bundle
            }
        }
    }()
    
    public static func getImage(_ named: String?) -> UIImage? {
        
        guard let named = named else {
            return nil
        }
        _ = self.onceTracker
        guard let bundle = self.bundle else {
            return nil
        }
        let image = UIImage(named: named, in: bundle, compatibleWith: nil)
        return image
    }
}

