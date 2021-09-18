//
//  CarErrorEnum.swift
//  Carangas
//
//  Created by Daivid Vasconcelos Leal on 18/09/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation

enum CarroErrorEnum {
    case url
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJSON
    case errorDescription(error: Error)
}
