//
//  Car.swift
//  Carangas
//
//  Created by Daivid Vasconcelos Leal on 21/10/17.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation

class Carro: Codable {
    
    var _id: String?
    // marca
    var brand: String = ""
    var gasType: Int = 0
    var name: String = ""
    var price: Double = 0.0
    
    var gas: String {
        switch gasType {
        case 0:
            return "Flex"
        case 1:
            return "Álcool"
        default:
            return "Gasolina"
        }
    }
}
