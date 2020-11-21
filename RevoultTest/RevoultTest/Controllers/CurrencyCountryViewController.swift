//
//  CurrencyCountryViewController.swift
//  RevoultTest
//
//  Created by Kishor Pahalwani on 05/10/19.
//  Copyright © 2019 Kishor Pahalwani. All rights reserved.
//

import UIKit

class CurrencyCountryViewController: UIViewController {

    @IBOutlet weak var countryListView: UITableView!
    @IBOutlet weak var viewLeadingConstraint: NSLayoutConstraint!
    
    var rateConversionDelegate: RateConversionProtocol?
    var countryModel: [CurrencyCountryModel]?
    var viewModel: RateConverterViewModel?
    var selectedIndex: Int?
    var arrRatesModel = [RateConverterModel]()
    var selectedCountry: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataTableView()
        setupViewModel()
    }
    
    fileprivate func setupViewModel() {
        viewModel = RateConverterViewModel()
        viewModel?.delegate = self
    }
    
    private func setupDataTableView() {
        countryListView.delegate = self
        countryListView.dataSource = self
        countryListView.tableFooterView = UIView()
    }
    
    fileprivate func setModel(modelFrom: Int, modelTo: Int) -> RateConverterModel? {
        if ((countryModel?.count ?? 0) > 0) && countryModel?[modelFrom] != nil && countryModel?[modelTo] != nil {
            
            let countryCodeFrom = countryModel?[modelFrom].countryCode ?? ""
            let countryCodeTo = countryModel?[modelTo].countryCode ?? ""
            let countryNameFrom = countryModel?[modelFrom].countryName ?? ""
            let countryNameTo = countryModel?[modelTo].countryName ?? ""
            
            let model = RateConverterModel.init(countryCodeFrom: countryCodeFrom, countryCodeTo: countryCodeTo, countryNameFrom: countryNameFrom, countryNameTo: countryNameTo, serachRatesKey: countryCodeFrom+countryCodeTo, rate: "")
            
            return model
        }
        
        else {
            return nil
        }
    }
    
    fileprivate func dismissVC() {
        rateConversionDelegate?.rateConversionDetail(arrRatesModel: self.arrRatesModel)
        self.arrRatesModel = []
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: TableView Delegate and Datasource
extension CurrencyCountryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyConverterCell", for: indexPath) as! CurrencyConverterCell
        cell.setCellData(selectedIndex: selectedIndex, listModel: self.arrRatesModel, indexPath: indexPath, currencyList: self.countryModel, selectedCountry: self.selectedCountry)
        //cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndex != nil && selectedIndex != indexPath.row {
            if let model = setModel(modelFrom: selectedIndex!, modelTo: indexPath.row) {
                
                if arrRatesModel.count > 0 {
                    arrRatesModel.insert(model, at: 0)
                }
                else {
                    arrRatesModel.append(model)
                }
                showProgressIndicator(view: self.view)
                viewModel?.fetchRateCompare(arrRatesModel: arrRatesModel)
            }
        }
        
        else {
             self.viewLeadingConstraint.constant = -self.view.bounds.size.width
             selectedCountry = countryModel?[indexPath.row].countryCode ?? ""
             selectedIndex = indexPath.row
             self.countryListView.reloadData()
            
            UIView.animate(withDuration: 0.1, animations: {
                //self.listViewLeading.constant = -self.view.bounds.size.width
                self.view.layoutIfNeeded()
            }) { (animated) in
                
                if animated {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.viewLeadingConstraint.constant = 0.0
                        self.view.layoutIfNeeded()
                    }, completion: nil)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//MARK:- Rate converter Delegate (failure and success)
extension CurrencyCountryViewController: RateConverterProtocol {
    func success(data: [RateConverterModel]) {
        DBService.sharedInstance.save(arrRateConverter: data)
        self.selectedIndex = nil
        hideProgressIndicator(view: self.view)
        self.arrRatesModel = data
        dismissVC()
    }
    
    //MARK: Show alert on failure
    func failure(error: String) {
        countryListView.reloadData()
        self.selectedIndex = nil
        hideProgressIndicator(view: self.view)
        
        let alert = UIAlertController(title: Constant.error, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constant.alertOK, style: .default, handler: { (action) in
            if self.arrRatesModel.count > 0 {
                self.arrRatesModel.remove(at: 0)
            }
            self.dismissVC()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
