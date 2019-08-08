//
//  PriceAndButtonToCartCell.swift
//  ankportal
//
//  Created by Олег Рачков on 07/08/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class PriceAndButtonToCartTableViewCell: UITableViewCell {
    
    lazy var toCartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("В корзину", for: .normal)
        button.backgroundColor = UIColor.ankPurple
        button.layer.cornerRadius = 5
        button.showsTouchWhenHighlighted = true
        button.addTarget(self, action: #selector(self.addToCartHandler), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    lazy var oldPriceLabel: StrikeThroughLabel = {
        let label = StrikeThroughLabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote).withSize(15)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(18)
        label.textColor = UIColor.ankPurple
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.addSubview(priceLabel)
        priceLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        priceLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4).isActive = true
        priceLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: contentInsetLeftAndRight).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -contentInsetLeftAndRight).isActive = true
        
        self.addSubview(toCartButton)
        toCartButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -contentInsetLeftAndRight).isActive = true
        toCartButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3).isActive = true
        toCartButton.topAnchor.constraint(equalTo: self.topAnchor, constant: contentInsetLeftAndRight).isActive = true
        toCartButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -contentInsetLeftAndRight).isActive = true
    }
    
    @objc private func addToCartHandler() {
        performAnimation()
    }
    
    private func performAnimation() {
        let label = getLabelForAddToCartAction()
        animateLabelAndRemove(label)
    }
    
    private func getLabelForAddToCartAction() -> UILabel {
        let label = UILabel()
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: toCartButton.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: toCartButton.centerYAnchor).isActive = true
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.text = "+1"
        return label
    }
    
    private func animateLabelAndRemove(_ label: UILabel) {
        UIView.animate(withDuration: 0.7, animations: {
            label.transform = CGAffineTransform(translationX: 0, y: -200)
            label.layer.opacity = 0.0
        }) { _ in
            label.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
}
