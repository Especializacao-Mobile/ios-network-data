//
//  ViewController+CoreData.swift
//  MyGames
//
//  Created by Daivid Vasconcelos Leal on 15/09/21.
//
import UIKit
import CoreData

extension UIViewController {
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
