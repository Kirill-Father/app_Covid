//
//  GlobalData.swift
//  Covid
//
//  Created by Kirill Selivanov on 17.08.2020.
//  Copyright © 2020 Kirill Selivanov. All rights reserved.
//

import CoreData

protocol GlobalDataProtocol {
    
    func addData(data: GlobalModel, date: String)
    
    func getData() -> Global?
    
}

final class GlobalData: GlobalDataProtocol {
    func addData(data: GlobalModel, date: String) {
        let fetchRequest: NSFetchRequest<Global> = Global.fetchRequest()
        
        do {
            let fetchResults = try DataManager.shared.context.fetch(fetchRequest)
            
            if let global = fetchResults.first {
                setData(global: global, data: data, date: date)
            } else {
                let global = Global(context: DataManager.shared.context)
                setData(global: global, data: data, date: date)
            }
            
            DataManager.shared.saveContext()
        } catch {
            print("Неожиданная ошибка: \(error).")
        }
    }
    
    private func setData(global: Global, data: GlobalModel, date: String) {
        global.name = "World"
        global.code = "World"
        global.totalConfirmed = Int64(data.totalConfirmed)
        global.totalDeaths = Int64(data.totalDeaths)
        global.totalRecovered = Int64(data.totalRecovered)
        global.newConfirmed = Int64(data.newConfirmed)
        global.newDeaths = Int64(data.newDeaths)
        global.newRecovered = Int64(data.newRecovered)
        global.date = date
    }
    
    func getData() -> Global? {
        let fetchRequest: NSFetchRequest<Global> = Global.fetchRequest()
        do {
            return try DataManager.shared.context.fetch(fetchRequest).first
        } catch {
            return nil
        }
    }
}