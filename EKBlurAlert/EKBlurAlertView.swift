//
//  EKBlurAlertView.swift
//  EKBlurAlertView
//
//  Created by Emil Karimov on 30.10.2017.
//  Copyright © 2017 Emil Karimov. All rights reserved.
//

import UIKit
import SnapKit

enum ShowType {
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
        image: UIImage = ImageProvider.getImage("apple_logo") ?? UIImage(),
        title: String? = nil,
        subtitle: String? = nil,
        autoFade: Bool = true,
        after: Double = 0.7,
        radius: CGFloat = 8,
        blurEffect: UIBlurEffect.Style = .dark) {

        super.init(frame: frame)
        self.createUI(with: image, blurEffect: blurEffect)
        self.setup(title: title, subtitle: subtitle, autoFade: autoFade, after: after, radius: radius, titleFont: titleFont, subTitleFont: subTitleFont)
    }


    private func createUI(with image: UIImage, blurEffect: UIBlurEffect.Style = .dark) {

        self.alertImage = UIImageView(image: image)

        self.titleLabel = UILabel()
        self.titleLabel.numberOfLines = 0
        self.titleLabel.textAlignment = .center
        self.titleLabel.textColor = UIColor.lightText

        self.subtitleLabel = UILabel()
        self.subtitleLabel.numberOfLines = 0
        self.subtitleLabel.textAlignment = .center
        self.subtitleLabel.textColor = UIColor.lightText

        self.blurView = UIVisualEffectView(effect: UIBlurEffect(style: blurEffect))

        self.contentView.alpha = 0.0
        self.contentView.addSubview(self.blurView)
        self.contentView.addSubview(self.alertImage)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.subtitleLabel)

    }

    private func setupConstraints() {

        self.contentView.center = self.center
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.translatesAutoresizingMaskIntoConstraints = true
        self.addSubview(self.contentView)

        if self.titleLabel.text != nil {

            if self.subtitleLabel.text != nil {

                self.setupContetViewContraints(type: ShowType.withSubtitle)

                self.alertImage.snp.makeConstraints { (make) in
                    make.top.equalToSuperview().offset(30)
                    make.left.equalToSuperview().offset(30)
                    make.right.equalToSuperview().offset(-30)
                    make.height.equalTo(self.contentView.snp.width).offset(-60)
                }

                self.titleLabel.snp.makeConstraints { (make) in
                    make.top.equalTo(self.alertImage.snp.bottom).offset(15)
                    make.left.equalToSuperview().offset(15)
                    make.right.equalToSuperview().offset(-15)
                    make.height.greaterThanOrEqualTo(21)
                }

                self.subtitleLabel.snp.makeConstraints { (make) in
                    make.top.equalTo(self.titleLabel.snp.bottom).offset(8)
                    make.left.equalToSuperview().offset(15)
                    make.right.equalToSuperview().offset(-15)
                    make.height.greaterThanOrEqualTo(21)
                    make.bottom.equalToSuperview().offset(-15)
                }

            } else {

                self.setupContetViewContraints(type: ShowType.withTitle)

                self.alertImage.snp.makeConstraints { (make) in
                    make.top.equalToSuperview().offset(30)
                    make.left.equalToSuperview().offset(30)
                    make.right.equalToSuperview().offset(-30)
                    make.height.equalTo(self.contentView.snp.width).offset(-60)
                }

                self.titleLabel.snp.makeConstraints { (make) in
                    make.top.equalTo(self.alertImage.snp.bottom).offset(15)
                    make.left.equalToSuperview().offset(15)
                    make.right.equalToSuperview().offset(-15)
                    make.height.greaterThanOrEqualTo(21)
                    make.bottom.equalToSuperview().offset(-15)
                }
            }


        } else {

            self.setupContetViewContraints(type: ShowType.noTexts)

            self.alertImage.snp.makeConstraints { (make) in

                make.top.equalToSuperview().offset(30)
                make.left.equalToSuperview().offset(30)
                make.right.equalToSuperview().offset(-30)
                make.bottom.equalToSuperview().offset(-30)
                make.width.equalTo(self.contentView.snp.width).offset(-60)
                make.height.equalTo(self.contentView.snp.width).offset(-60)

            }

        }
    }

    fileprivate func setupContetViewContraints(type: ShowType) {

        self.contentView.snp.makeConstraints { (make) in

            make.center.equalToSuperview()
            make.width.equalTo(self.frame.width / 2)

//            switch type {
//            case .noTexts:
//                make.height.equalTo(self.frame.width / 2)
//            case .withTitle:
//                make.height.equalTo((self.frame.width / 3) * 2)
//            case .withSubtitle:
//                make.height.equalTo((self.frame.width / 5) * 3)
//            }

        }

        self.blurView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createUI(with: UIImage(), blurEffect: UIBlurEffect.Style.dark)
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

    public func setup(title: String? = nil,
        subtitle: String? = nil,
        autoFade: Bool = true,
        after: Double = 3.0,
        radius: CGFloat = 8,
        titleFont: UIFont = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular),
        subTitleFont: UIFont = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)) {

        self.viewCornerRadius = radius

        self.titleLabel.text = title
        self.titleLabel.font = titleFont

        self.subtitleLabel.text = subtitle
        self.subtitleLabel.font = subTitleFont

        self.autoFade = autoFade
        self.timeAfter = after

        self.setupConstraints()
    }
}
