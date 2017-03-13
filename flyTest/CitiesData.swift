//
//  CitiesData.swift
//  flyTest
//
//  Created by vivek verma on 13/03/17.
//  Copyright © 2017 vivek. All rights reserved.
//

import Foundation

class CitiesData {
    var cityDataArray : [NSDictionary] = [NSDictionary]()
    
    private init() {
        if let filePath = Bundle.main.path(forResource: "cities", ofType: "json"),
            let data = NSData(contentsOfFile: filePath) {
            do {
                let json = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments)
                cityDataArray = (json as? [NSDictionary])!
            }
            catch {

            }
        }
    }
    
    //MARK: Shared Instance
    
    static let sharedInstance: CitiesData = CitiesData()
}
