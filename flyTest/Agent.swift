//
//  Agent.swift
//  flyTest
//
//  Created by vivek verma on 12/03/17.
//  Copyright © 2017 vivek. All rights reserved.
//

import UIKit
import ObjectMapper

class Agent: Mappable {
    
    var image_url      : String?
    var display_phone  : String?
    var distance       : Double?
    var name           : String?
    var rating         : Int?
    var phone          : String?
    var id             : String?
    var review_count   : Int?
    var url            : String?
    var is_closed      : Bool?
    var coordinates    : AgentCoordinates?
    var location       : AgentAddress?



    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        image_url      <- map["image_url"]
        display_phone  <- map["display_phone"]
        distance       <- map["distance"]
        name           <- map["name"]
        rating         <- map["rating"]
        phone          <- map["phone"]
        id             <- map["id"]
        review_count   <- map["review_count"]
        url            <- map["url"]
        is_closed      <- map["is_closed"]
        coordinates    <- map["coordinates"]
        location       <- map["location"]
    }
}

struct AgentAddress: Mappable {
    var address1 : String?
    var address2 : String?
    var address3 : String?
    var zip_code : String?
    var city     : String?
    var state    : String?
    var country  : String?
    var displayAddress : [String]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        address1     <- map["address1"]
        address2     <- map["address2"]
        address3     <- map["address3"]
        zip_code     <- map["zip_code"]
        city         <- map["city"]
        state        <- map["state"]
        country      <- map["country"]
        displayAddress <- map["display_address"]
    }
}

struct AgentCoordinates: Mappable {
    var longitude : Double?
    var latitude  : Double?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        longitude     <- map["longitude"]
        latitude      <- map["latitude"]
    }
}
