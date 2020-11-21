//
//  NetworkRouter.swift
//  RevoultTest
//
//  Created by Kishor Pahalwani on 05/10/19.
//  Copyright © 2019 Kishor Pahalwani. All rights reserved.
//

import Foundation

private let requestTimeOut: TimeInterval = 60

class CurrencyConverterAPIRouter {
    
    enum Router {
        
        //MARK:- Case
        case compareRate(countries: [String])
        
        //MARK:- HTTP Method
        var method: String{
            switch self {
            case .compareRate:
                return "POST"
            }
        }
        
        //MARK: Base URL
        var baseUrl: String {
            return "https://europe-west1-revolut-230009.cloudfunctions.net/revolut-ios?"
        }
        
        //MARK:- API Path
        var path: String {
            switch self {
                case .compareRate(let city):
                    let strData = city.joined(separator: "&pairs=")
                return "pairs=\(strData)"
            }
        }
        
        //Method URLRequest
        func asURLRequest() -> URLRequest? {
            if let url =  URL(string: baseUrl + path) {
                var urlRequest = URLRequest(url:url)
                urlRequest.httpMethod = method
                urlRequest.timeoutInterval = requestTimeOut
                urlRequest.allowsCellularAccess = true
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                return urlRequest
            }
                
            else {
                return nil
            }
        }
    }
}





