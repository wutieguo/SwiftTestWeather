//
//  WeatherViewController.swift
//  Weather
//
//  Created by Tieguo Wu on 1/25/19.
//  Copyright © 2019 Tieguo Wu. All rights reserved.
//

import UIKit
import CoreLocation
import SDWebImage
import MBProgressHUD

class WeatherViewController: UITableViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    var coordinate: CLLocationCoordinate2D! = nil
    var weather: Weather! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load;
        if coordinate != nil {
            loadWeather()
        } else {
            loadController()
        }
    }
    
    func loadWeather() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        APIClient.shared.getWeatherInfo(coordinate) { (value, success) in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            guard let success1 = success, success1 == true else {
                return
            }
            
            guard let weather = value else {
                print("error")
                return
            }
            
            self.weather = weather
            self.loadController()
        }
    }
    
    func loadController() {
        self.title = weather.name
        
        let urlString = APIClient.shared.getIcon(weather.icon!)
        let url = URL(string: urlString)
        imageView.sd_setImage(with: url, completed: nil)
        weatherDescriptionLabel.text = weather.mainDescription
        windSpeed.text = "\(weather.speed) km/h, \(weather.deg)°"
        pressureLabel.text = "\(weather.pressure) hpa"
        tempLabel.text = "\(weather.temp) °K"
    }
    
}
