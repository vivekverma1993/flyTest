//
//  Globals.swift
//  flyTest
//
//  Created by vivek verma on 09/03/17.
//  Copyright © 2017 vivek. All rights reserved.
//

import UIKit

struct Globals {
    static let ACCESS_TOKEN : String = "vIjD5XOxggdSHzdYN3Zy2qfPOg0YX7LKvO4TLDgw_XIPlnKsElhi0reVbN7pkSEmJn2phrpMTi1yAPI7mUxh_-e5tCy7ZuDo6wjC4FAcWq55BQxWfHfPs0CQXlfAWHYx"
    static let SCREEN_WIDTH = UIScreen.main.bounds.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.height
    static let ICON_FONT = "icomoon"
}

struct Icons {
    static let STAR_ICON : String = String.init("\u{e705}")
}

struct Colors {
    static let THEME_COLOR : UIColor = UIColor(red:0.93, green:0.08, blue:0.08, alpha:1.0)
    static let BLACK_COLOR : UIColor = UIColor.black
    static let BORDER_COLOR : UIColor = UIColor.black.withAlphaComponent(0.3)
    static let GRAY_COLOR  : UIColor = UIColor.gray
    static let FAFAFA      : UIColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
    static let BLUE_COLOR  : UIColor = UIColor.blue
}

struct Strings {
    static let CONTACT_AGENT_STRING : String = "Contact Agent"
}

struct CommonFunctions {
    
    static func bottomOfView(view : UIView) -> CGFloat {
        return view.frame.origin.y + view.frame.size.height
    }
    
    static func rightOfView(view : UIView) -> CGFloat {
        return view.frame.origin.x + view.frame.size.width
    }
    
    static func sizeOfString(text: String, font: UIFont, constrainedToSize size: CGSize) -> CGSize {
        return NSString(string: text).boundingRect(with: CGSize(width: size.width, height: size.height),
                                                           options: .usesLineFragmentOrigin,
                                                           attributes: [NSFontAttributeName: font],
                                                           context: nil).size
    }
}
