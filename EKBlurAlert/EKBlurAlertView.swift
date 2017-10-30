//
//  EKBlurAlertView.swift
//  EKBlurAlertView
//
//  Created by Emil Karimov on 30.10.2017.
//  Copyright © 2017 Emil Karimov. All rights reserved.
//

import UIKit

public class EKBlurAlertView: UIView {

    @IBOutlet weak var alertImage: UIImageView!
    @IBOutlet weak var headline_label: UILabel!
    @IBOutlet weak var subheadline_lablel: UILabel!
    
    let nibName = "EKBlurAlertView"
    var contentView: UIView!
    var viewCornerRadius: CGFloat = 0.0
    var timer: Timer?
    var autoFade: Bool = true
    var timeAfter: Double = 3.0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }

    fileprivate func cornerRadius(_ radius: CGFloat = 0.0) {
        self.contentView.layer.cornerRadius = radius
        self.contentView.layer.masksToBounds = self.contentView.layer.cornerRadius > 0
        self.contentView.clipsToBounds = self.contentView.layer.cornerRadius > 0
    }
    
    public override func layoutSubviews() {
        self.layoutIfNeeded()
        cornerRadius(viewCornerRadius)
    }
    
    public override func didMoveToSuperview() {
        self.contentView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.15, animations: {
            self.contentView.alpha = 1.0
            self.contentView.transform = CGAffineTransform.identity
        }) { _ in
            if self.autoFade {
                self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.timeAfter), target: self, selector: #selector(self.removeSelf), userInfo: nil, repeats: false)
            } else {
                self.removeSelf()
            }
        }
    }
    
    @objc private func removeSelf() {
        UIView.animate(withDuration: 0.15, animations: {
                self.contentView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.contentView.alpha = 0.0
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    private func setUpView() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(contentView)
        
        contentView.center = self.center
        contentView.autoresizingMask = []
        contentView.translatesAutoresizingMaskIntoConstraints = true
        
        headline_label.text = ""
        subheadline_lablel.text = ""
        self.contentView.alpha = 0.0
    }
    
    public func setCornerRadius(_ radius: CGFloat) {
        self.viewCornerRadius = radius
    }
    public func set(image: UIImage) {
        self.alertImage.image = image
    }
    public func set(headline text: String) {
        self.headline_label.text = text
    }
    public func set(subheading text: String) {
        self.subheadline_lablel.text = text
    }
    public func set(autoFade: Bool = true, after: Double = 3.0) {
        self.autoFade = autoFade
        self.timeAfter = after
    }
}
