//
//  ConsolesManager.swift
//  MyGames
//
//  Created by Daivid Vasconcelos Leal on 15/09/21.
//

import CoreData

class ConsolesManager {
    
    static let shared = ConsolesManager()
    var consoles: [Console] = []
    
    func carregarConsoles(with context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Console> = Console.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            consoles = try context.fetch(fetchRequest)
        } catch  {
            print(error.localizedDescription)
        }
    }
        
    func deletarConsole(index: Int, context: NSManagedObjectContext) {
        let console = consoles[index]
        context.delete(console)
        do {
            try context.save()
            consoles.remove(at: index)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
}
