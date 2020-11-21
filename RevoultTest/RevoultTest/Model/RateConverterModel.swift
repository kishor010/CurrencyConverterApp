//
//  RateConverterModel.swift
//  RevoultTest
//
//  Created by Kishor Pahalwani on 06/10/19.
//  Copyright © 2019 Kishor Pahalwani. All rights reserved.
//

import Foundation

class RateConverterModel: Codable {
    
    var countryCodeFrom: String?
    var countryCodeTo: String?
    var countryNameFrom: String?
    var countryNameTo: String?
    var serachRatesKey: String?
    var rate: String?
    
    enum CodingKeys: String, CodingKey {
        case countryCodeFrom
        case countryCodeTo
        case countryNameFrom
        case countryNameTo
        case serachRatesKey
        case rate
    }
    
    init(countryCodeFrom: String?, countryCodeTo: String?, countryNameFrom: String?, countryNameTo: String?, serachRatesKey: String?, rate: String?) {
        self.countryCodeFrom = countryCodeFrom
        self.countryCodeTo = countryCodeTo
        self.countryNameFrom = countryNameFrom
        self.countryNameTo = countryNameTo
        self.serachRatesKey = serachRatesKey
        self.rate = rate
    }
    
    //helps to Encode the object
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(countryCodeFrom, forKey: .countryCodeFrom)
        try container.encode(countryCodeTo, forKey: .countryCodeTo)
        try container.encode(countryNameFrom, forKey: .countryNameFrom)
        try container.encode(countryNameTo, forKey: .countryNameTo)
        try container.encode(serachRatesKey, forKey: .serachRatesKey)
        try container.encode(rate, forKey: .rate)
    }
    
    //helps to Decode the object
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        countryCodeFrom = try container.decode(String.self, forKey: .countryCodeFrom)
        countryCodeTo = try container.decode(String.self, forKey: .countryCodeTo)
        countryNameFrom = try container.decode(String.self, forKey: .countryNameFrom)
        countryNameTo = try container.decode(String.self, forKey: .countryNameTo)
        serachRatesKey = try container.decode(String.self, forKey: .serachRatesKey)
        rate = try container.decode(String.self, forKey: .rate)
    }
}
