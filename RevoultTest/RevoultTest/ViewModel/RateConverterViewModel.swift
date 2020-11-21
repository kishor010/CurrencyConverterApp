//
//  RateConverterViewModel.swift
//  RevoultTest
//
//  Created by Kishor Pahalwani on 06/10/19.
//  Copyright © 2019 Kishor Pahalwani. All rights reserved.
//

import Foundation

protocol RateConverterProtocol: class {
    func success(data: [RateConverterModel])
    func failure(error: String)
}

class RateConverterViewModel: NSObject {
    
    weak var delegate: RateConverterProtocol?
    
    func fetchRateCompare(arrRatesModel: [RateConverterModel]) {
        
        let countries = fetchRateConverterResponse(arrRatesModel: arrRatesModel)
        
        if countries.count > 0 {
            RateConverterNetworkManager.sharedInstance.getCurrencyConverter(countries: countries, onSuccess: { (dictValue) in
                DispatchQueue.main.async {
                    if let data = dictValue {
                        let arrRateConverterModel = self.BindServerResponse(data: data, arrRatesModel: arrRatesModel)
                        self.delegate?.success(data: arrRateConverterModel)
                    }
                    else {
                        self.delegate?.failure(error: Constant.dataNotAvail)
                    }
                }
            }) { (failure) in
                 DispatchQueue.main.async {
                    self.delegate?.failure(error: failure)
                 }
             }
        }
        
        else {
            self.delegate?.failure(error: Constant.dataNotAvail)
        }
    }
    
    private func BindServerResponse(data: dict, arrRatesModel: [RateConverterModel]) -> [RateConverterModel] {
        
        var arrValue = [RateConverterModel]()

        for (index, dataItem) in arrRatesModel.enumerated() {
            if let dataValue = data[dataItem.serachRatesKey ?? ""] as? Double {
                var itemAtValue  = dataItem
                itemAtValue.rate = "\(dataValue)"
                itemAtValue.countryCodeFrom = (arrRatesModel[index].countryCodeFrom ?? "")
                arrValue.append(itemAtValue)
            }
        }
        
        return arrValue
    }
    
    //MARK:- API Request to fetch currency converter details
    private func fetchRateConverterResponse(arrRatesModel: [RateConverterModel]) -> [String] {
        
        var stringConverterRequestKey = [String]()
        
        for (_,modelItem) in arrRatesModel.enumerated() {
                
            if let rateKey = modelItem.serachRatesKey, rateKey != "" {
                stringConverterRequestKey.append(rateKey)
            }
        }
        
        if stringConverterRequestKey.count > 0 && arrRatesModel.count > 0 {
            return stringConverterRequestKey
        }
        
        return []
    }
}
