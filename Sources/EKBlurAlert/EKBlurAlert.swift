//
//  EKBlurAlert.swift
//  EKBlurAlert
//
//  Created by Emil Karimov on 13/08/2020.
//  Copyright © 2020 Emil Karimov. All rights reserved.
//

import UIKit
import SnapKit

public enum EKShowType {
    case noTexts
    case withTitle
    case withSubtitle
}

public class EKBlurAlertView: UIView {

    private var alertImage: UIImageView!
    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!
    private var blurView: UIVisualEffectView!

    private var contentView: UIView = UIView()
    private var viewCornerRadius: CGFloat = 8
    private var timer: Timer?
    private var autoFade: Bool = true
    private var timeAfter: Double = 0.7

    public init(
        frame: CGRect, titleFont: UIFont = UIFont.systemFont(ofSize: 17, weight: .regular),
        subTitleFont: UIFont = UIFont.systemFont(ofSize: 14, weight: .regular),
        image: UIImage = UIImage(),
        title: String? = nil,
        subtitle: String? = nil,
        autoFade: Bool = true,
        after: Double = 0.7,
        radius: CGFloat = 8,
        blurEffect: UIBlurEffect.Style = .dark) {

        super.init(frame: frame)
        createUI(with: image, blurEffect: blurEffect)
        setup(title: title, subtitle: subtitle, autoFade: autoFade, after: after, radius: radius, titleFont: titleFont, subTitleFont: subTitleFont)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createUI(with: UIImage(), blurEffect: UIBlurEffect.Style.dark)
    }

    public override func layoutSubviews() {
        layoutIfNeeded()
        cornerRadius(viewCornerRadius)
    }

    public override func didMoveToSuperview() {
        contentView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
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

    public func setup(title: String? = nil,
        subtitle: String? = nil,
        autoFade: Bool = true,
        after: Double = 3.0,
        radius: CGFloat = 8,
        titleFont: UIFont = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular),
        subTitleFont: UIFont = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)) {

        viewCornerRadius = radius

        titleLabel.text = title
        titleLabel.font = titleFont

        subtitleLabel.text = subtitle
        subtitleLabel.font = subTitleFont

        self.autoFade = autoFade
        timeAfter = after

        setupConstraints()
    }
}

// MARK: - Private

extension EKBlurAlertView {
    
    @objc
    private func removeSelf() {
        UIView.animate(withDuration: 0.15, animations: {
            self.contentView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.contentView.alpha = 0.0
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    private func cornerRadius(_ radius: CGFloat = 0.0) {
        contentView.layer.cornerRadius = radius
        contentView.layer.masksToBounds = contentView.layer.cornerRadius > 0
        contentView.clipsToBounds = contentView.layer.cornerRadius > 0
    }

    private func setupContetViewContraints(type: EKShowType) {

        contentView.snp.makeConstraints { (make) in

            make.center.equalToSuperview()
            make.width.equalTo(frame.width / 2)

//            switch type {
//            case .noTexts:
//                make.height.equalTo(self.frame.width / 2)
//            case .withTitle:
//                make.height.equalTo((self.frame.width / 3) * 2)
//            case .withSubtitle:
//                make.height.equalTo((self.frame.width / 5) * 3)
//            }

        }

        blurView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupConstraints() {

        contentView.center = center
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(contentView)

        if titleLabel.text != nil {

            alertImage.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(30)
                make.left.equalToSuperview().offset(30)
                make.right.equalToSuperview().offset(-30)
                make.height.equalTo(contentView.snp.width).offset(-60)
            }

            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(alertImage.snp.bottom).offset(15)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.height.greaterThanOrEqualTo(21)
            }
            
            if subtitleLabel.text != nil {

                setupContetViewContraints(type: EKShowType.withSubtitle)

                subtitleLabel.snp.makeConstraints { (make) in
                    make.top.equalTo(titleLabel.snp.bottom).offset(8)
                    make.left.equalToSuperview().offset(15)
                    make.right.equalToSuperview().offset(-15)
                    make.height.greaterThanOrEqualTo(21)
                    make.bottom.equalToSuperview().offset(-15)
                }

            } else {

                setupContetViewContraints(type: EKShowType.withTitle)

            }


        } else {

            setupContetViewContraints(type: EKShowType.noTexts)

            alertImage.snp.makeConstraints { (make) in

                make.top.equalToSuperview().offset(30)
                make.left.equalToSuperview().offset(30)
                make.right.equalToSuperview().offset(-30)
                make.bottom.equalToSuperview().offset(-30)
                make.width.equalTo(contentView.snp.width).offset(-60)
                make.height.equalTo(contentView.snp.width).offset(-60)

            }

        }
    }
    
    private func createUI(with image: UIImage, blurEffect: UIBlurEffect.Style = .dark) {

        alertImage = UIImageView(image: image)

        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.lightText

        subtitleLabel = UILabel()
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = UIColor.lightText

        blurView = UIVisualEffectView(effect: UIBlurEffect(style: blurEffect))

        contentView.alpha = 0.0
        contentView.addSubview(blurView)
        contentView.addSubview(alertImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)

    }
}

