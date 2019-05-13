//
//  PlaceholderTableViewCell.swift
//  ankportal
//
//  Created by Admin on 23/04/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class PlaceholderTableViewCell: UITableViewCell {
    
    var padding: CGFloat {
        get {
            return 24
        }
    }
    
    var cornerRadius: CGFloat {
        get {
            return 10
        }
    }
    
    var backgroundColorForView: UIColor {
        get {
            return UIColor(r: 235, g: 235, b: 235)
        }
    }
    
    lazy var containerView: UIView = getContainterView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupCell()
    }
    
    func getContainterView() -> UIView {
        let view = ShadowShimmerView()
        view.layer.cornerRadius = cornerRadius
        view.backgroundColor = backgroundColorForView
        return view
    }
    
    func setupCell() {
        selectionStyle = .none
    }
    
    func setupViews() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -padding).isActive = true
        containerView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -padding).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
