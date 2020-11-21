//
//  RateConverterCell.swift
//  RevoultTest
//
//  Created by Kishor Pahalwani on 06/10/19.
//  Copyright © 2019 Kishor Pahalwani. All rights reserved.
//

import UIKit

class RateConverterCell: UITableViewCell {
    
    @IBOutlet weak var labelCountryCodeFrom: UILabel!
    @IBOutlet weak var labelCurrencyRate: UILabel!
    @IBOutlet weak var labelCountryFrom: UILabel!
    @IBOutlet weak var labelCountryToNameCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCurrencyConverterCell(ratesModel: RateConverterModel?)  {
        guard let ratesModel = ratesModel else {
            return
        }
        labelCountryCodeFrom.text =  "1 " + (ratesModel.countryCodeFrom ?? "")
        labelCountryFrom.text = ratesModel.countryNameFrom
        labelCurrencyRate.text = ratesModel.rate
        labelCountryToNameCode.text = (ratesModel.countryNameTo ?? "") + "  " + (ratesModel.countryCodeTo ?? "")
    }
}
