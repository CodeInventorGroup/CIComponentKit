//
//  RootTableViewCell.swift
//  CIComponentKitDemo
//
//  Created by ManoBoo on 04/01/2018.
//  Copyright © 2018 club.codeinventor. All rights reserved.
//

import UIKit
import CIComponentKit

class RootTableViewCell: UITableViewCell {

    var data: (title: String, subtitle: String, info: String) = ("", "", "")

    private let containerView = UIView()

    private let titleLabel = UILabel().font(UIFont.cic.preferred(.headline))
    private let subtitleLabel = UILabel().font(UIFont.init(name: "GillSans-SemiBold", size: 16.0)!).line(0)
    private let infoLabel = CICLabel().font(UIFont.cic.preferred(.body)).line(0)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(CICAppearance.didToggleTheme),
                                               name: Notification.Name.cic.themeDidToggle,
                                               object: nil)
        initSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initSubviews() {
        selectionStyle = .none
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(infoLabel)
        infoLabel.longPressAction(.copy)
        infoLabel.copySuccessClousure = { [weak self] in
            guard let `self` = self else { return }
            let alertView = CICAlertView.init(contentView: nil,
                                              title: "复制文本为:",
                                              content: self.data.info)
            alertView.show()
        }
    }

    func render() {
        containerView.size(contentView)
        didToggleTheme()
        let contentWidth = contentView.cic.width - 2 * 10
        titleLabel.text(data.title).sizeTo(layout: .maxWidth(contentWidth))
            .x(10).y(10)
        subtitleLabel.text(data.subtitle).width(contentWidth)
            .sizeTo(layout: .maxHeight(.greatestFiniteMagnitude))
            .x(10).y(titleLabel.cic.bottom + 10)
        infoLabel.text(data.info).width(contentWidth)
            .sizeTo(layout: .maxHeight(.greatestFiniteMagnitude))
            .x(10).y(subtitleLabel.cic.bottom + 10)
        containerView.height(infoLabel.cic.bottom + 10)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        render()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        self.width(size.width)

        return CGSize.init(width: size.width, height: containerView.cic.bottom)
    }
}

extension RootTableViewCell: CICAppearance {
    func willToggleTheme() {

    }

    func didToggleTheme() {
        let config = CIComponentKitThemeCurrentConfig
        containerView.backgroundColor(config.mainColor)
        self.backgroundColor(config.mainColor)
        UIView.animate(withDuration: 0.35) {
            self.titleLabel.textColor(config.tintColor)
            self.subtitleLabel.textColor(config.textColor)
            self.infoLabel.textColor(config.textColor)
        }
    }


}
