//
//  CurrencyCountryMoel.swift
//  RevoultTest
//
//  Created by Kishor Pahalwani on 05/10/19.
//  Copyright © 2019 Kishor Pahalwani. All rights reserved.
//

import Foundation

class CurrencyCountryModel: Codable {
    
    var countryCode: String?
    var icon: String?
    var countryName: String?
    
    enum CodingKeys: String, CodingKey {
        case countryCode
        case icon
        case countryName
    }
    
    init(countryCode: String?, icon: String?, countryName: String?) {
        self.countryCode = countryCode
        self.icon = icon
        self.countryName = countryName
    }
    
    //helps to Encode the object
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(countryCode, forKey: .countryCode)
        try container.encode(icon, forKey: .icon)
        try container.encode(countryName, forKey: .countryName)
    }
    
    //helps to Decode the object
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        countryCode = try container.decode(String.self, forKey: .countryCode)
        icon = try container.decode(String.self, forKey: .icon)
        countryName = try container.decode(String.self, forKey: .countryName)
    }
}
