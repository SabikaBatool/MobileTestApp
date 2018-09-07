//
//  WeatherViewController.swift
//  MobileTestApp
//
//  Created by IOS Developer on 06/09/2018.
//  Copyright © 2018 IOS Developer. All rights reserved.
//

import UIKit
import GoogleMaps

class WeatherViewController: UIViewController {
    var locationLatitude = Double()
    var locationLongitude = Double()
    let locationManager = CLLocationManager()
    var weatherDict = [String:AnyObject]()
    let date = Date()
    let formatter = DateFormatter()
    
    @IBOutlet weak var firstDayLbl: UILabel!
    @IBOutlet weak var secondDayLbl: UILabel!
    @IBOutlet weak var thirdDayLbl: UILabel!
    @IBOutlet weak var fourthDayLbl: UILabel!
    @IBOutlet weak var fifthDayLbl: UILabel!
    
    @IBOutlet weak var firstDayTemperatureLbl: UILabel!
    @IBOutlet weak var secondDayTemperatureLbl: UILabel!
    @IBOutlet weak var thirdDayTemperatureLbl: UILabel!
    @IBOutlet weak var fourthDayTemperatureLbl: UILabel!
    @IBOutlet weak var fifthDayTemperatureLbl: UILabel!
    
    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var summaryLbl: UILabel!
    
    @IBOutlet weak var precipitationTextLbl: UILabel!
    @IBOutlet weak var precipitationLbl: UILabel!
    @IBOutlet weak var humidityTextLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var windTextLbl: UILabel!
    @IBOutlet weak var windLbl: UILabel!
    @IBOutlet weak var currentTemperatureLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        self.navigationController?.navigationItem.title = "Weather Detail"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateScreen() {
        populateCurrentWeather()
        populateWeatherForecast()
    }
    
    func populateCurrentWeather() {
        // Populate Current Weather
        let cityName = weatherDict["timezone"] as! String
        let splitCityArray = cityName.split(separator: "/")
        cityNameLbl.text = String(splitCityArray[1])
        
        formatter.dateFormat = "EEEE"
        dayLbl.text = formatter.string(from: date)
        currentTemperatureLbl.text = String(describing: Int(truncating: (weatherDict["currently"]!["temperature"] as? NSNumber)!)) + " F"
        summaryLbl.text = weatherDict["currently"]!["summary"] as? String
        precipitationTextLbl.text = "Precipitation"
        humidityTextLbl.text = "Humidity"
        windTextLbl.text = "Wind"
        let precipitationNum = Float(truncating: (weatherDict["currently"]!["precipIntensity"] as? NSNumber)!)
        let humidityNum = Float(truncating: (weatherDict["currently"]!["humidity"] as? NSNumber)!)
        let windNum = Float(truncating: (weatherDict["currently"]!["windSpeed"] as? NSNumber)!)
        precipitationLbl.text = String(describing: precipitationNum*100) + "%"
        humidityLbl.text = String(describing: humidityNum*100) + "%"
        windLbl.text = String(describing: windNum) + "Km/h"
    }
    
    func populateWeatherForecast() {
        //Populate Weather Forecast
        var dayArray = [String]()
        for i in 1...5 {
            let newDate = Calendar.current.date(byAdding: .day, value: i, to: Date())!
            formatter.dateFormat = "EE"
            let dayInWeek = formatter.string(from: newDate)
            dayArray.append(dayInWeek)
        }
        firstDayLbl.text = dayArray[0]
        secondDayLbl.text = dayArray[1]
        thirdDayLbl.text = dayArray[2]
        fourthDayLbl.text = dayArray[3]
        fifthDayLbl.text = dayArray[4]
        
        let dailyData = weatherDict["daily"]!["data"] as! [[String:AnyObject]]
        firstDayTemperatureLbl.text = String(describing: Int(truncating: (dailyData[0]["temperatureHigh"] as? NSNumber)!))
        secondDayTemperatureLbl.text = String(describing: Int(truncating: (dailyData[1]["temperatureHigh"] as? NSNumber)!))
        thirdDayTemperatureLbl.text = String(describing: Int(truncating: (dailyData[2]["temperatureHigh"] as? NSNumber)!))
        fourthDayTemperatureLbl.text = String(describing: Int(truncating: (dailyData[3]["temperatureHigh"] as? NSNumber)!))
        fifthDayTemperatureLbl.text = String(describing: Int(truncating: (dailyData[4]["temperatureHigh"] as? NSNumber)!))
    }
    
    // MARK: - IBAction
    
    @IBAction func nearbyRestaurantBtnTapped(_ sender: UIButton) {
        let nearbyPlacesViewController = storyboard?.instantiateViewController(withIdentifier: "NearbyPlacesViewController") as! NearbyPlacesViewController
        nearbyPlacesViewController.latitude = locationLatitude
        nearbyPlacesViewController.longitude = locationLongitude
        self.navigationController?.pushViewController(nearbyPlacesViewController, animated: true)
    }
    // MARK: - Service Call
    
    func getWeatherCall() {
        let urlStrWithAPIKey = WEATHER_BASE_URL + WeatherAPIKey + "/"
        let urlStr = urlStrWithAPIKey + "\(locationLatitude)" + "," + "\(locationLongitude)"
        
        ServiceModel.sharedModel.getData(urlString: urlStr, loaderTxt: "Loading..", parameters: nil as Dictionary<String, AnyObject>?, success: {(AnyObject) -> Void in
            print(AnyObject)
            if let dict = AnyObject as? [String: AnyObject] {
                print(dict)
                self.weatherDict = dict
                self.populateScreen()
            }
        }, failure: {(NSError) -> Void in
        })
    }
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        locationLatitude = location.coordinate.latitude
        locationLongitude = location.coordinate.longitude
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        getWeatherCall()
    }
}
