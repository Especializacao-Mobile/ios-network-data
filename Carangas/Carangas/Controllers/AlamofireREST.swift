//
//  REST.swift
//  Carangas
//
//  Created by Daivid Vasconcelos Leal on 21/10/17.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireREST {
    
    private static let basePath = "https://carangas.herokuapp.com/cars"
    private static let urlFipe = "https://parallelum.com.br/fipe/api/v1/carros/marcas"
    
    private static let session = URLSession(configuration: configuration) // URLSession.shared
    
    
    private static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = true
        config.httpAdditionalHeaders = ["Content-Type":"application/json"]
        config.timeoutIntervalForRequest = 10.0
        config.httpMaximumConnectionsPerHost = 5
        return config
    }()
    
    static func loadCars(onComplete: @escaping ([Carro]) -> Void, onError: @escaping (CarroErrorEnum) -> Void) {
        
        guard let url = URL(string: basePath) else {
            onError(.url)
            return
        }
        
        
        AF.request(url, method: .get).responseJSON { response in
            switch response.result {
            case .success:
                if(response.response?.statusCode == 200){
                    guard let data = response.data else {return}
                    do {
                        let cars = try JSONDecoder().decode([Car].self, from: data)
                        onComplete(cars)
                    }catch {
                        onError(.invalidJSON)
                    }
                }else {
                    let statusCode = response.response?.statusCode
                    onError(.responseStatusCode(code: statusCode!))
                }
            case let .failure(error):
                print(error)
                onError(.errorDescription(error: error))
            }
        }
    }
    
    static func save(car: Carro, onComplete: @escaping (Bool) -> Void, onError: @escaping(CarroErrorEnum) -> Void ) {
        applyOperation(car: car, operation: .save, onComplete: onComplete, onError: onError)
    }
    
    
    static func update(car: Carro, onComplete: @escaping (Bool) -> Void, onError: @escaping(CarroErrorEnum) -> Void) {
        applyOperation(car: car, operation: .update, onComplete: onComplete, onError: onError)
    }
    
    class func delete(car: Carro, onComplete: @escaping (Bool) -> Void, onError: @escaping(CarroErrorEnum) -> Void) {
        applyOperation(car: car, operation: .delete, onComplete: onComplete, onError: onError)
    }
    

    private static func applyOperation(car: Carro, operation: RESTOperationEnum , onComplete: @escaping (Bool) -> Void, onError: @escaping (CarroErrorEnum) -> Void) {
        
        let urlString = basePath + "/" + (car._id ?? "")
        
        guard let url = URL(string: urlString) else {
            onComplete(false)
            return
        }
        
        var httpMethod: HTTPMethod
        switch operation {
        case .delete:
            httpMethod = .delete
        case .save:
            httpMethod = .post
        case .update:
            httpMethod = .put
        }
        
        AF.request(url, method: httpMethod, parameters: car, encoder: JSONParameterEncoder.default).response { response in
            debugPrint(response)
            switch response.result {
                case .success:
                    if(response.response?.statusCode == 200){
                         onComplete(true)
                    }
                case let .failure(error):
                    print(error)
                    onError(.errorDescription(error: error))
            }
        }
    }

    static func loadBrands(onComplete: @escaping ([Marca]?) -> Void, onError: @escaping (CarroErrorEnum) -> Void) {
        
        guard let url = URL(string: urlFipe) else {
            onError(.url)
            return
        }
        
        AF.request(url, method: .get).responseJSON { response in
            switch response.result {
            case .success:
                if(response.response?.statusCode == 200){
                    guard let data = response.data else {return}
                    do {
                        let brands = try JSONDecoder().decode([Brand].self, from: data)
                        onComplete(brands)
                    }catch {
                        onError(.invalidJSON)
                    }
                }else {
                    let statusCode = response.response?.statusCode
                    onError(.responseStatusCode(code: statusCode!))
                }
            case let .failure(error):
                print(error)
                onError(.errorDescription(error: error))
            }
        }
    }
    
}
