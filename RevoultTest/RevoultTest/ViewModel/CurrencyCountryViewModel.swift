//
//  CurrencyCountryViewModel.swift
//  RevoultTest
//
//  Created by Kishor Pahalwani on 05/10/19.
//  Copyright © 2019 Kishor Pahalwani. All rights reserved.
//

import Foundation

protocol RateConversionProtocol {
    func rateConversionDetail(arrRatesModel: [RateConverterModel])
    func failure()
}

protocol CurrencyCountryProtocol: class {
    func getCurrencyCountryList(data: [CurrencyCountryModel])
}

class CurrencyCountryViewModel: NSObject {
    
    weak var delegate: CurrencyCountryProtocol?
    
    func getCurrencyFromBundle() {
        
       if let path = Bundle.main.path(forResource: "currencies", ofType: "json") {
           do {
               let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
               let dataJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            if let data = dataJson as? [dict] {
                delegate?.getCurrencyCountryList(data:  GetCountryCountryModelData(arrCurrencyData: data))
            }
           } catch let error {
               print("parse error: \(error.localizedDescription)")
           }
       } else {
           print("Invalid filename/path.")
       }
    }
    
    //MARK: Return Array of Entity
    private func GetCountryCountryModelData(arrCurrencyData: [dict]) -> [CurrencyCountryModel] {
        var arrCurrencyModelData = [CurrencyCountryModel]()
        for item in arrCurrencyData {
            let data = CountryModel(countryModelData: item)
            arrCurrencyModelData.append(data)
        }
        return arrCurrencyModelData
    }
    
    //MARK: Return Single Entity
    private func CountryModel(countryModelData: dict) -> CurrencyCountryModel {
        
        var countryCode = ""
        var icon = ""
        var countryName = ""
        if let codeData = countryModelData["countryCode"] as? String {
            countryCode = codeData
        }
        if let iconData = countryModelData["icon"] as? String {
            icon = iconData
        }
        if let countryNameData = countryModelData["countryName"] as? String {
            countryName = countryNameData
        }
        return BindCountryCountryModelData(countryCode: countryCode, icon: icon, countryName: countryName)
    }
    
    private func BindCountryCountryModelData(countryCode: String?, icon: String?, countryName: String?) -> CurrencyCountryModel {
        let currencyModel = CurrencyCountryModel(countryCode: countryCode, icon: icon, countryName: countryName)
        return currencyModel
    }
}

