//
//  FlyAgentTableViewCell.swift
//  flyTest
//
//  Created by vivek verma on 12/03/17.
//  Copyright © 2017 vivek. All rights reserved.
//

import UIKit
import PINRemoteImage

class FlyAgentTableViewCell: UITableViewCell {
    
    let kNameFontSize       : CGFloat = 14.0
    let kRatingIconSize     : CGFloat = 14.0
    let kRatingFontSize     : CGFloat = 12.0
    let kAddressFontSize    : CGFloat = 12.0
    let kButtonFontSize     : CGFloat = 14.0
    let kButtonBorderWidth  : CGFloat = 1.0
    let kImagePadding       : CGFloat = 5.0
    let kImageDimension     : CGFloat = 60.0
    let kButtonHeight       : CGFloat = 35.0
    let kImageCornerRadius  : CGFloat = 3.0
    let kButtonCornerRadius : CGFloat = 3.0
    
    private var agentImageView   : UIImageView = UIImageView()
    private var nameLabel        : UILabel = UILabel()
    private var ratingLabel      : UILabel = UILabel()
    private var ratingCountLabel : UILabel = UILabel()
    private var addressLabel     : UILabel = UILabel()
    private var contactAgent     : UIButton = UIButton()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        agentImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        agentImageView.frame = CGRect(x: kImagePadding, y: 2*kImagePadding, width: kImageDimension, height: kImageDimension)
        agentImageView.layer.cornerRadius = kImageCornerRadius
        let nameLabelSize : CGSize = CommonFunctions.sizeOfString(text: nameLabel.text!, font: nameLabel.font!, constrainedToSize: CGSize(width: Globals.SCREEN_WIDTH-kImageDimension-3*kImagePadding, height: CGFloat.greatestFiniteMagnitude))
        nameLabel.frame = CGRect(x: CommonFunctions.rightOfView(view: agentImageView) + kImagePadding, y: 2*kImagePadding, width: nameLabelSize.width, height: nameLabelSize.height)
        
        let ratingLabelSize : CGSize = CommonFunctions.sizeOfString(text: ratingLabel.text!, font: ratingLabel.font!, constrainedToSize: CGSize(width: Globals.SCREEN_WIDTH - kImageDimension - 3*kImagePadding, height: CGFloat.greatestFiniteMagnitude))
        ratingLabel.frame = CGRect(x: CommonFunctions.rightOfView(view: agentImageView) + kImagePadding, y: CommonFunctions.bottomOfView(view: nameLabel) + kImagePadding, width: ratingLabelSize.width, height: ratingLabelSize.height)
        
        let ratingCountLabelSize : CGSize = CommonFunctions.sizeOfString(text: ratingCountLabel.text!, font: ratingCountLabel.font!, constrainedToSize: CGSize(width: Globals.SCREEN_WIDTH - kImageDimension - 4*kImagePadding - ratingLabelSize.width, height: CGFloat.greatestFiniteMagnitude))
        ratingCountLabel.frame = CGRect(x: CommonFunctions.rightOfView(view: ratingLabel) + kImagePadding, y: CommonFunctions.bottomOfView(view: nameLabel) + kImagePadding, width: ratingCountLabelSize.width, height: ratingCountLabelSize.height)
        
        let addressLabelSize : CGSize = CommonFunctions.sizeOfString(text: addressLabel.text!, font: addressLabel.font!, constrainedToSize: CGSize(width: Globals.SCREEN_WIDTH - kImageDimension - 3*kImagePadding, height: CGFloat.greatestFiniteMagnitude))
        
        addressLabel.frame = CGRect(x: CommonFunctions.rightOfView(view: agentImageView) + kImagePadding, y: CommonFunctions.bottomOfView(view: ratingLabel) + kImagePadding, width: addressLabelSize.width, height: addressLabelSize.height)
        
        let contactAgentOffset = max(CommonFunctions.bottomOfView(view: addressLabel), CommonFunctions.bottomOfView(view: agentImageView)) + kImagePadding
        
        contactAgent.frame = CGRect(x: kImagePadding, y: contactAgentOffset, width: Globals.SCREEN_WIDTH - 2*kImagePadding, height: kButtonHeight)
        contactAgent.layer.cornerRadius = kButtonCornerRadius
    }
    
    //MARK: - action methods
    
    func contactTapped(sender : UIButton) {
        
    }
    
    //MARK: - public methods
    
    public func updateCellWithAgentModel(agent : Agent) {
        agentImageView.pin_updateWithProgress = true
        agentImageView.pin_setImage(from: URL(string: agent.image_url!)!) {[weak self] (result) in
            self?.agentImageView.image = self?.resizeImage(image: result.image!, newWidth: (self?.kImageDimension)!)
        }
        nameLabel.text = agent.name!
        ratingLabel.attributedText = self.createRatingText(rating: agent.rating!)
        ratingCountLabel.text = agent.review_count! > 0 ? "\(agent.review_count!) reviews" : ""
        addressLabel.text = (agent.location?.displayAddress?.count)! > 0 ? agent.location?.displayAddress?.joined(separator: ",") : ""
    }
    
    class func getHeightOfCell(agent : Agent) -> CGFloat {
        let nameFontSize      : CGFloat = 14.0
        let ratingIconSize    : CGFloat = 14.0
        let addressFontSize   : CGFloat = 12.0
        let imagePadding      : CGFloat = 5.0
        let imageDimension    : CGFloat = 60.0
        let buttonHeight      : CGFloat = 35.0
        
        let nameLabelSize : CGSize = CommonFunctions.sizeOfString(text: agent.name!, font: UIFont.boldSystemFont(ofSize: nameFontSize), constrainedToSize: CGSize(width: Globals.SCREEN_WIDTH-imageDimension-3*imagePadding, height: CGFloat.greatestFiniteMagnitude))
        
        let ratingCountLabelSize : CGSize = CommonFunctions.sizeOfString(text: "\(agent.rating!) reviews", font:UIFont.systemFont(ofSize: ratingIconSize) , constrainedToSize: CGSize(width: Globals.SCREEN_WIDTH - imageDimension - 4*imagePadding - 150, height: CGFloat.greatestFiniteMagnitude))
        
        
        let address : String = (agent.location!.displayAddress?.count)! > 0 ? (agent.location?.displayAddress?.joined(separator: ","))! : ""
        let addressLabelSize : CGSize = CommonFunctions.sizeOfString(text: address, font: UIFont.systemFont(ofSize: addressFontSize), constrainedToSize: CGSize(width: Globals.SCREEN_WIDTH - imageDimension - 3*imagePadding, height: CGFloat.greatestFiniteMagnitude))
        
        return max(imageDimension + 2*imagePadding, imagePadding + nameLabelSize.height + imagePadding + ratingCountLabelSize.height + imagePadding + addressLabelSize.height + imagePadding) + buttonHeight + 3*imagePadding
    }
    
    //MARK: - private methods
    
    private func initSubViews() {
        self.setupAgentImageView()
        self.setupNameLabel()
        self.setupRatingLabel()
        self.setupRatingCountLabel()
        self.setupAddressLabel()
        self.setupContactButton()
    }
    
    private func setupAgentImageView() {
        agentImageView.contentMode = .center
        agentImageView.layer.masksToBounds = true
        self.addSubview(agentImageView)
    }
    
    private func setupNameLabel() {
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.boldSystemFont(ofSize: kNameFontSize)
        self.addSubview(nameLabel)
    }
    
    private func setupRatingLabel() {
        ratingLabel.textAlignment = .left
        self.addSubview(ratingLabel)
    }
    
    private func setupRatingCountLabel() {
        ratingCountLabel.textAlignment = .left
        ratingCountLabel.textColor = Colors.BLACK_COLOR
        ratingCountLabel.font = UIFont.systemFont(ofSize: kRatingFontSize)
        self.addSubview(ratingCountLabel)
    }
    
    private func setupAddressLabel() {
        addressLabel.textAlignment = .left
        addressLabel.numberOfLines = 0
        addressLabel.textColor = Colors.GRAY_COLOR
        addressLabel.font = UIFont.systemFont(ofSize: kAddressFontSize)
        self.addSubview(addressLabel)
    }
    
    private func setupContactButton() {
        contactAgent.setTitle(Strings.CONTACT_AGENT_STRING, for: .normal)
        contactAgent.setTitleColor(Colors.BLUE_COLOR, for: .normal)
        contactAgent.titleLabel?.font = UIFont.systemFont(ofSize: kButtonFontSize)
        contactAgent.backgroundColor = Colors.FAFAFA
        contactAgent.layer.borderWidth = kButtonBorderWidth
        contactAgent.layer.borderColor = Colors.BORDER_COLOR.cgColor
        contactAgent.addTarget(self, action: #selector(FlyAgentTableViewCell.contactTapped(sender:)), for: .touchUpInside)
        self.addSubview(contactAgent)
    }
    
    private func createRatingText(rating : Int) -> NSAttributedString {
        var ratingString : String = ""
        let mutableString : NSMutableAttributedString = NSMutableAttributedString()
        for _ in 0..<rating {
            ratingString = ratingString + Icons.STAR_ICON + " "
        }
        
        mutableString.append(NSAttributedString(string: ratingString, attributes: [NSForegroundColorAttributeName: Colors.THEME_COLOR, NSFontAttributeName: UIFont.init(name: Globals.ICON_FONT, size: kRatingIconSize) ?? UIFont.systemFont(ofSize: kRatingIconSize)]))
        
        var ratingLeftString : String = ""
        for _ in 0..<(5 - rating) {
            ratingLeftString = ratingLeftString + Icons.STAR_ICON + " "
        }
        
        mutableString.append(NSAttributedString(string: ratingLeftString, attributes: [NSForegroundColorAttributeName: Colors.GRAY_COLOR, NSFontAttributeName: UIFont.init(name: Globals.ICON_FONT, size: kRatingIconSize) ?? UIFont.systemFont(ofSize: kRatingIconSize)]))
        
        return mutableString.copy() as! NSAttributedString
    }
    
    private func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
        image.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

}
