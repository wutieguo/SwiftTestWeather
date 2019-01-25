//
//  APIClient.swift
//  Weather
//
//  Created by Tieguo Wu on 1/25/19.
//  Copyright © 2019 Tieguo Wu. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import Alamofire
import SwiftyJSON

class APIClient {

    static let shared = APIClient()
    
    typealias CompletionHandler = (_ weather : Weather?,  _ success : Bool?) -> Void
    
    private let url = "https://api.openweathermap.org/data/2.5/weather"
    private let apiKey = "a3cc441bba609f4ab59e7d686cbe2442"
    
    func getWeatherInfo(_ coordinate: CLLocationCoordinate2D, _ completion: CompletionHandler!) {
        let parameters = [
            "appid" : apiKey,
            "lat" : coordinate.latitude,
            "lon" : coordinate.longitude
        ] as [String : Any]
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            switch (response.result) {
            case .success(let value):
                let json = JSON(value)
                
                let weather = NSEntityDescription.insertNewObject(forEntityName: "Weather", into: AppDelegate.shared.persistentContainer.viewContext) as! Weather
                weather.name = json["name"].stringValue
                weather.lat = json["coord"]["lat"].doubleValue
                weather.lon = json["coord"]["lon"].doubleValue

                weather.main = json["weather"][0]["main"].stringValue
                weather.mainDescription = json["weather"][0]["description"].stringValue
                weather.icon = json["weather"][0]["icon"].stringValue
                
                weather.temp = json["main"]["temp"].doubleValue
                weather.pressure = json["main"]["pressure"].doubleValue
                weather.humidity = json["main"]["humidity"].doubleValue
                weather.tempMin = json["main"]["temp_min"].doubleValue
                weather.tempMax = json["main"]["temp_max"].doubleValue

                weather.speed = json["wind"]["speed"].doubleValue
                weather.deg = json["wind"]["deg"].doubleValue

                AppDelegate.shared.saveContext()
                
                completion?(weather, true)
                break
                
            case .failure(_):
                let weather = Weather()
                completion?(weather, false)
                break
            }
        }
    }
    
    func getIcon(_ icon: String) -> String {
        let iconUrl = "http://openweathermap.org/img/w/\(icon).png"
        return iconUrl
    }
    
}
