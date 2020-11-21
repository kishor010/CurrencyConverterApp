//
//  RevoultTestTests.swift
//  RevoultTestTests
//
//  Created by Kishor Pahalwani on 12/10/19.
//  Copyright © 2019 Kishor Pahalwani. All rights reserved.
//

import XCTest
@testable import RevoultTest

var model: [RateConverterModel] = []
var viewModel: RateConverterViewModel!

class RevoultTestTests: XCTestCase {
    override func setUp() {
        
        //Example values
        model.append(RateConverterModel(countryCodeFrom: "IND", countryCodeTo: "ISK", countryNameFrom: "Indian Rupees", countryNameTo: "Iceland Krona", serachRatesKey: "INDISK", rate: "20"))
        
        model.append(RateConverterModel(countryCodeFrom: "AUS", countryCodeTo: "ISK", countryNameFrom: "Australian Dollar", countryNameTo: "Iceland Krona", serachRatesKey: "AUDISK", rate: ""))
        
        viewModel = RateConverterViewModel.init()
    }

    override func tearDown() {
        model = []
        viewModel = nil
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        //Time Measurement
        measure {
            viewModel.fetchRateCompare(arrRatesModel: [model[0]])
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDeletedCurrency()  {
        let obj =  CurrencyConverterViewController.init()
        XCTAssert(obj.deleteValue(index: 0, data: model).0)
        XCTAssert(obj.deleteValue(index: 1, data: model).0)
        //XCTAssert(obj.deleteValue(index: 2, data: model).0)
    }
    
    func testDeleteCurrenyValues()  {
        let obj =  CurrencyConverterViewController.init()
        XCTAssert(obj.deleteValue(index: 2, data: model).0)
    }
    
    //Test Check pass or fail
    func testCountries() {
        let  modelCountries = CurrencyCountryModel.init(countryCode: nil, icon: "abc", countryName: "")
        let abc = CurrencyCountryModel.init(countryCode: nil, icon: "abc", countryName: "")
        let value = modelCountries.countryCode == abc.icon
        XCTAssert(value)
    }
    
    func testEqualValues() {
        XCTAssertEqual(model[0].serachRatesKey, model[1].serachRatesKey)
    }
    
    func testEditModel() {
        //XCTAssert(viewModel.fetchRateCompare(arrRatesModel: []))
    }
}
