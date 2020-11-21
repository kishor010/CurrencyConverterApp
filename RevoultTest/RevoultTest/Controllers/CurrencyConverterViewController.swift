//
//  CurrencyConverterViewController.swift
//  RevoultTest
//
//  Created by Kishor Pahalwani on 05/10/19.
//  Copyright © 2019 Kishor Pahalwani. All rights reserved.
//

import UIKit

class CurrencyConverterViewController: UIViewController {
    
    @IBOutlet weak var AddCurrencyView: UIStackView!
    @IBOutlet weak var AddCurrencyTop: UIButton!
    @IBOutlet weak var DataListView: UITableView!
    
    var countryModel: [CurrencyCountryModel]?
    var viewModel: CurrencyCountryViewModel?
    var arrRatesModel: [RateConverterModel]!
    var rateConverterViewModel: RateConverterViewModel?
    var timer : Timer?
    var timerCall = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        getRCData()
        setupDataTableView()
        _ = rateModelConverterPresent()
        setTimer()
    }
    
    fileprivate func setupViewModel() {
        arrRatesModel = [RateConverterModel]()
        viewModel = CurrencyCountryViewModel()
        viewModel?.delegate = self
        viewModel?.getCurrencyFromBundle()
        rateConverterViewModel = RateConverterViewModel()
        rateConverterViewModel?.delegate = self
    }
    
    fileprivate func getRCData() {
        arrRatesModel = DBService.sharedInstance.fetchRCModel()
    }
    
    //MARK:- Add Currency Tapped
    @IBAction func AddCurrency(_ sender: Any) {
        
        if let vc = self.storyboard?.instantiateViewController(identifier: Constant.CurrencyCountryViewController) as? CurrencyCountryViewController {
            
            if let countryModel = countryModel, countryModel.count > 0 {
                timerCall = false
                timerInValidate()
                vc.countryModel = self.countryModel
                vc.rateConversionDelegate = self
                vc.arrRatesModel = self.arrRatesModel
                self.present(vc, animated: true, completion: nil)
            }
                
            else {
                Helper.showAlert(AlertTitle: Constant.error, AlertMessage: Constant.dataNotAvail, controller: self)
            }
        }
            
        else {
            Helper.showAlert(AlertTitle: Constant.error, AlertMessage: "", controller: self)
        }
    }
    
    private func setupDataTableView() {
        DataListView.delegate = self
        DataListView.dataSource = self
        DataListView.tableFooterView = UIView()
    }
    
    private func rateModelConverterPresent() -> Bool {
        if arrRatesModel.count > 0 {
            initialUIConfiguration(currencyViewHidden: true)
            return true
        }
            
        else {
            initialUIConfiguration(currencyViewHidden: false)
            return false
        }
    }
    
    func deleteValue(index: Int, data: [RateConverterModel]) -> (Bool, [RateConverterModel]) {
        
        var values = data
        if index < values.count {
            DBService.sharedInstance.deleteRateConverter(id: values[index].serachRatesKey)
            values.remove(at: index)
            self.arrRatesModel = values
            return (true, values)
        }
        
        else {
            return (false, data)
        }
    }
    
    private func initialUIConfiguration(currencyViewHidden: Bool) {
        AddCurrencyView.isHidden = currencyViewHidden
        AddCurrencyTop.isHidden = !currencyViewHidden
        DataListView.isHidden = !currencyViewHidden
    }
    
    private func reloadData() {
        DataListView.reloadData()
        timerInValidate()
        setTimer()
    }
}

//MARK:- Data table view Delegate and Datasource
extension CurrencyConverterViewController: UITableViewDelegate,
UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRatesModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: Constant.rateConverterCell) as? RateConverterCell
        cell?.selectionStyle = .none
        if (nil == cell) {
            let nib:Array = Bundle.main.loadNibNamed(Constant.rateConverterCell, owner: self, options: nil)!
            cell = nib[0] as? RateConverterCell
        }
        cell?.setCurrencyConverterCell(ratesModel: self.arrRatesModel[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.rowHeight = 100;
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            if self.deleteValue(index: indexPath.row, data: self.arrRatesModel).0 == true {
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                          _ = rateModelConverterPresent()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        timerCall = false
        print("item")
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        timerCall = true
    }
}

//MARK:- Country list data from bundle
extension CurrencyConverterViewController: CurrencyCountryProtocol {
    func getCurrencyCountryList(data: [CurrencyCountryModel]) {
        self.countryModel = data
    }
}

//MARK:- Rate converter RateConversionProtocol delegate
extension CurrencyConverterViewController: RateConversionProtocol {
    func rateConversionDetail(arrRatesModel: [RateConverterModel]) {
        self.arrRatesModel = arrRatesModel
        if rateModelConverterPresent() == true {
            timerCall = true
            reloadData()
        }
    }
    
    func failure() {
        if rateModelConverterPresent() == true {
            timerCall = true
            reloadData()
        }
    }
}

//MARK:- Rate converter Delegate (failure and success)
extension CurrencyConverterViewController: RateConverterProtocol {
    func success(data: [RateConverterModel]) {
        if timerCall && self.arrRatesModel.count == data.count {
            self.arrRatesModel = data
            DBService.sharedInstance.save(arrRateConverter: arrRatesModel)
            if rateModelConverterPresent() == true {
                reloadData()
            }
        }
    }
    func failure(error: String) {
        if timerCall {
            if rateModelConverterPresent() == true {
                reloadData()
            }
        }
    }
}

//MARK:- Set Timer ()
extension CurrencyConverterViewController {
    fileprivate func setTimer() {
        if arrRatesModel.count > 0 {
            timer = Timer.scheduledTimer(timeInterval: Constant.timerDelay, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func timerFunction() {
        if timer?.isValid == true && timerCall {
            rateConverterViewModel?.fetchRateCompare(arrRatesModel: self.arrRatesModel)
        }
    }
    
    func timerInValidate() {
        timer?.invalidate()
        timer = nil
    }
}
