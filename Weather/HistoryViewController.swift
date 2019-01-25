//
//  HistoryViewController.swift
//  Weather
//
//  Created by Travis Ferreira on 1/25/19.
//  Copyright © 2019 Tieguo Wu. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UITableViewController {

    var weathers: [Weather] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let predicate = NSPredicate(value: true)
        let request = NSFetchRequest<Weather>(entityName: "Weather")
        request.predicate = predicate
        request.sortDescriptors = []
        
        do {
            weathers = try AppDelegate.shared.persistentContainer.viewContext.fetch(request)
            self.tableView.reloadData()
        } catch {
            
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weathers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weather = weathers[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        cell.textLabel?.text = weather.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weather = weathers[indexPath.row]
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
        viewController.weather = weather
        self.navigationController?.pushViewController(viewController, animated: true)

    }
    

}
