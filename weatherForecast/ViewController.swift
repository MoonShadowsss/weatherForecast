//
//  ViewController.swift
//  weatherForecast
//

//  Copyright © 2017年 hadow. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var localityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var locationMangager: CLLocationManager!
    var currLocation: CLLocation!
    let APIKey = "your API key here"
    
    @IBAction func refresh(_ sender: Any) {
        updateWeatherInfo(lon: Double(currLocation.coordinate.longitude), lat: Double(currLocation.coordinate.latitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currLocation = locations[locations.count - 1]
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(currLocation, completionHandler: {
            (placeMark, error) -> Void in
            if error != nil {
                return
            }
            if (placeMark?.count)! > 0 {
                self.localityLabel.text = placeMark?[0].locality
            }
        })
        updateWeatherInfo(lon: Double(currLocation.coordinate.longitude), lat: Double(currLocation.coordinate.latitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.localityLabel.text = error.localizedDescription
    }
    
    func updateWeatherInfo(lon: Double, lat: Double) {
        let APICall = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=" + APIKey
        let url = URL(string: APICall)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!, completionHandler: {
            (data, response, error) -> Void in
            if error != nil {
                return
            }
            let json = JSON(data!)
            self.temperatureLabel.text = String(Double(json["main"]["temp"].stringValue)! - 273.15) + "℃"
        })
        dataTask.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationMangager = CLLocationManager()
        locationMangager.delegate = self
        locationMangager.desiredAccuracy = kCLLocationAccuracyBest
        locationMangager.distanceFilter = kCLLocationAccuracyHundredMeters
        locationMangager.requestWhenInUseAuthorization()
        locationMangager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

