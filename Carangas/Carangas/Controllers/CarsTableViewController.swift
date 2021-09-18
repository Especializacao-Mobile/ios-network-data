//
//  CarsTableViewController.swift
//  Carangas
//
//  Created by Daivid Vasconcelos Leal on 21/10/17.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit
import SideMenu

class CarsTableViewController: UITableViewController {
    
    var cars: [Carro] = []
    
    var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: "main")
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        SideMenuManager.default.leftMenuNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view, forMenu: SideMenuManager.PresentDirection.left)
        
        label.text = "Carregando carros ..."
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadCarros), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCarros()
    }
    
    @objc func loadCarros() {
        AlamofireREST.loadCars { cars in
            self.cars = cars
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        } onError: { error in
            print(error)
            var response: String = ""
            switch error {
                case .invalidJSON:
                    response = "invalidJSON"
                case .noData:
                    response = "noData"
                case .noResponse:
                    response = "noResponse"
                case .url:
                    response = "JSON inválido"
                case .errorDescription(let error):
                    response = "\(error.localizedDescription)"
                case .responseStatusCode(let code):
                    if code != 200 {
                        response = "Algum problema com o servidor. :( \nError:\(code)"
                    }
            }
            
            let alert = UIAlertController(title: response, message: "Deseja tentar novamente?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Sim", style: .default, handler: { action in
                self.loadCarros()
            }))
            alert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            
            DispatchQueue.main.async {
                self.label.text = "Ocorreu um erro no servidor\n\n\(response)"
                self.tableView.backgroundView = self.label
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = cars.count
        if count == 0 {
            self.label.text = "Sem dados"
            self.tableView.backgroundView = self.label
        } else {
            self.tableView.backgroundView = nil
        }
        return cars.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let car = cars[indexPath.row]
        cell.textLabel?.text = car.name
        cell.detailTextLabel?.text = car.brand
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let car = cars[indexPath.row]
            AlamofireREST.delete(car: car) { (success) in
                if success {
                    self.cars.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }else {
                    print("Nao foi possivel deletar esse carro.")
                }

            }onError: { error in
                print(error)
                var response: String = ""
                switch error {
                case .invalidJSON:
                    response = "invalidJSON"
                case .noResponse:
                    response = "noResponse"
                case .url:
                    response = "JSON inválido"
                case .noData:
                    response = "noData"
                case .errorDescription(let error):
                    response = "\(error.localizedDescription)"
                case .responseStatusCode(let code):
                    if code != 200 {
                        response = "Algum problema com o servidor. :( \nError:\(code)"
                    }
                }
                
                let alert = UIAlertController(title: "Nao foi possivel deletar o carro. \n \(response)", message: "Deseja tentar novamente?", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewSegue" {
            
            let vc = segue.destination as! CarViewController
            if let row = tableView.indexPathForSelectedRow?.row {
                vc.car = cars[row]
            }
        }
    }
    

}
