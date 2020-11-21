//
//  CurrencyConverterCell.swift
//  RevoultTest
//
//  Created by Kishor Pahalwani on 05/10/19.
//  Copyright © 2019 Kishor Pahalwani. All rights reserved.
//

import UIKit

class CurrencyConverterCell: UITableViewCell {

    @IBOutlet weak var imgCountry: UIImageView!
    @IBOutlet weak var labelCountryName: UILabel!
    @IBOutlet weak var labelCountryCode: UILabel!
    @IBOutlet weak var selectedCellBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellData(selectedIndex: Int?, listModel: [RateConverterModel], indexPath: IndexPath, currencyList: [CurrencyCountryModel]?, selectedCountry: String) {
        
        guard let currencyListItem = currencyList?[indexPath.row] else {
            return
        }
        labelCountryName.text = currencyListItem.countryName
        imgCountry.image = UIImage.init(named: currencyListItem.icon ?? "defaultImg")
        labelCountryCode.text = currencyListItem.countryCode
        
        if selectedIndex != nil  {
            if indexPath.row == selectedIndex {
                setCellStatus(cell: self, isClear: false, isUserInteractionEnable: false, color: .systemIndigo, alpha: 0.8)
            }
            
            else if listModel.count > 0 {
                var findout = false
                for item in listModel {
                    if (item.serachRatesKey == selectedCountry
                         + (currencyList?[indexPath.row].countryCode ?? "") || item.serachRatesKey == (currencyList?[indexPath.row].countryCode ?? "") + selectedCountry ) {
                        findout = true
                        break
                    }
                }
                
                if findout {
                    setCellStatus(cell: self, isClear: false, isUserInteractionEnable: false, color: .placeholderText, alpha: 0.2)
                }
                
                else {
                    setCellStatus(cell: self, isClear: true, isUserInteractionEnable: true, color: .clear, alpha: 1)
                }
            }
            
            else {
                setCellStatus(cell: self, isClear: true, isUserInteractionEnable: true, color: .clear, alpha: 1)
            }
        }
        
        else {
            setCellStatus(cell: self, isClear: true, isUserInteractionEnable: true, color: .clear, alpha: 1)
        }
    }
    
    private func setCellStatus(cell: UITableViewCell, isClear: Bool, isUserInteractionEnable: Bool, color: UIColor, alpha: CGFloat) {
        cell.isUserInteractionEnabled = isUserInteractionEnable
        if isClear {
            self.selectedCellBackgroundView.isHidden = true
        }
        else {
            self.selectedCellBackgroundView.isHidden = false
        }
        self.selectedCellBackgroundView.backgroundColor = color
        self.selectedCellBackgroundView.alpha = alpha
        //self.selectedCellBackgroundView.backgroundColor?.withAlphaComponent(0.8) = color
    }
}
