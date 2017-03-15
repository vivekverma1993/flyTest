//
//  FLYNoInternetView.swift
//  flyTest
//
//  Created by vivek verma on 14/03/17.
//  Copyright © 2017 vivek. All rights reserved.
//

import UIKit

protocol FLYNoInternetViewDelegate: class {
    func refreshClicked()
}

class FLYNoInternetView: UIView {
    
    weak var delegate : FLYNoInternetViewDelegate?
    let klabelFontSize  : CGFloat = 14.0
    let kImageTopOffset : CGFloat = 150.0
    let kImageWidth     : CGFloat = 150.0
    let kLabelPadding   : CGFloat = 10.0
    let kButtonHeight   : CGFloat = 40.0
    
    private var imageView : UIImageView = UIImageView()
    private var label : UILabel = UILabel()
    private var button : UIButton = UIButton()
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Colors.WHITE_COLOR
        self.p_initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let ratio : CGFloat = (imageView.image?.size.height)!/(imageView.image?.size.width)!
        imageView.frame = CGRect(x: (self.frame.width - kImageWidth)/2, y: kImageTopOffset, width: kImageWidth, height: ratio*kImageWidth)
        let labelSize : CGSize = CommonFunctions.sizeOfString(text: Strings.NO_INTERNET_STRING, font: UIFont.systemFont(ofSize: klabelFontSize), constrainedToSize: CGSize(width: self.frame.width - 2*kLabelPadding, height: CGFloat.greatestFiniteMagnitude))
        label.frame = CGRect(x: kLabelPadding, y: CommonFunctions.bottomOfView(view: imageView) + kLabelPadding, width: labelSize.width, height: labelSize.height)
        button.layer.cornerRadius = 3.0
        button.frame = CGRect(x: kLabelPadding, y: CommonFunctions.bottomOfView(view: label) + kLabelPadding, width: labelSize.width, height: kButtonHeight)
    }
    
    //MARK: - action methods
    
    func p_refreshClicked(sender : UIButton) {
        if (self.delegate != nil) {
            self.delegate?.refreshClicked()
        }
    }
    
    //MARK: - private methods
    
    private func p_initSubviews() {
        self.p_setupImageView()
        self.p_setupLabel()
        self.p_setupButton()
    }
    
    private func p_setupImageView() {
        imageView.image = UIImage.init(named: "no_internet")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        self.addSubview(imageView)
    }
    
    private func p_setupLabel() {
        label.text = Strings.NO_INTERNET_STRING
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: klabelFontSize)
        label.textColor = Colors.BLACK_COLOR
        self.addSubview(label)
    }
    
    private func p_setupButton() {
        button.setTitle("Refresh", for: .normal)
        button.setTitleColor(Colors.BLACK_COLOR, for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = Colors.BORDER_COLOR.cgColor
        button.addTarget(self, action: #selector(FLYNoInternetView.p_refreshClicked(sender:)), for: .touchUpInside)
        self.addSubview(button)
    }
}
