//
//  ImageProvider.swift
//  EKBlurAlert
//
//  Created by Emil Karimov on 03/11/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

public class ImageProvider: NSObject {
    
    private static var bundle: Bundle?
    private static let onceTracker: () = {
        
        if let bundleURL = Bundle(for: ImageProvider.self).url(forResource: "EKBlurAlertAssets", withExtension: "bundle") {
            
            if let bundle = Bundle(url: bundleURL) {
                
                ImageProvider.bundle = bundle
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

