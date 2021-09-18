//
//  AddEditViewControllerExtension.swift
//  Carangas
//
//  Created by Daivid Vasconcelos Leal on 18/09/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation

extension AddEditViewController:UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let brand = marcas[row]
        return brand.nome
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return marcas.count
    }
}
