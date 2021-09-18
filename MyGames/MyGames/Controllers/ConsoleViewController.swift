//
//  ConsoleViewController.swift
//  MyGames
//
//  Created by Daivid Vasconcelos Leal on 15/09/21.
//

import UIKit

class ConsoleViewController: UIViewController {
    
    @IBOutlet weak var lbConsoleName: UILabel!
    @IBOutlet weak var ivCover: UIImageView!
    
    var console: Console!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lbConsoleName.text = console.name ?? ""
        
        if let image = console.cover as? UIImage {
            ivCover.image = image
        } else {
            ivCover.image = UIImage(named: "noCoverFull")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddEditPlataformaViewController
        vc.console = console
    }
}
