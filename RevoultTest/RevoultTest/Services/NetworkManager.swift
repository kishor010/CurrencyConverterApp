//
//  NetworkManager.swift
//  RevoultTest
//
//  Created by Kishor Pahalwani on 05/10/19.
//  Copyright © 2019 Kishor Pahalwani. All rights reserved.
//

import Foundation

private let _sharedInstance = RateConverterNetworkManager()
private let DEBUG_MODE = true

class RateConverterNetworkManager {
    
    //MARKS: Shared Instance
    private let restClient = RestClient()
    
    fileprivate init(){}
    
    static var sharedInstance: RateConverterNetworkManager {
        return _sharedInstance
    }
    
    //MARK: Network Call Methods
    func getCurrencyConverter(countries: [String], onSuccess: @escaping onSuccess,
                        onFailure: @escaping onFailure)  {
        let _url = CurrencyConverterAPIRouter.Router.compareRate(countries: countries)
        
        if let request = _url.asURLRequest() {
            restClient.makeRequest(urlRequest: request, onSuccess: onSuccess, onFailure: onFailure)
        }
        else {
            print("Error")
        }
    }
}

// MARK: - REST CLIENT -
fileprivate class RestClient {
    
    fileprivate func makeRequest(urlRequest: URLRequest,
                                 onSuccess: @escaping onSuccess,
                                 onFailure: @escaping onFailure
        ) -> Void {
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) {
            data,response,error in
            
            do {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                   guard let data = data else {
                         return
                   }
                   let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? dict
                    
                    if DEBUG_MODE {
                        print(jsonResult ?? "No Response") // print response
                    }
                    
                    onSuccess(jsonResult)
                }
                else {
                    onFailure("Item is not available")
                }
            } catch let error as NSError {
                onFailure(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
}








