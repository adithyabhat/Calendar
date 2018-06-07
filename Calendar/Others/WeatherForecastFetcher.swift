//
//  WeatherForecastFetcher.swift
//  Calendar
//
//  Created by Bhat, Adithya H on 08/03/18.
//  Copyright © 2018 SAP Labs, Bengaluru. All rights reserved.
//

import UIKit
import CoreLocation

protocol WeatherForecastFetcherDelegate: class  {
    func initiatedFetchingWeatherInfo()
    func currentTemperature(temperature: CGFloat)
    func didFailFetchingWeatherInfo()
}

//Singleton class, fetches the current weather information
class WeatherForecastFetcher: NSObject {
    weak var delegate: WeatherForecastFetcherDelegate?
    private let locationManager = CLLocationManager()
    
    init(delegate: WeatherForecastFetcherDelegate) {
        self.delegate = delegate
    }
    
    //MARK: Private helper methods
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        delegate?.initiatedFetchingWeatherInfo()
    }
    
    func fetchWeatherInfo(forLocation location: CLLocationCoordinate2D) {
        //Form query URL
        let urlString = Constants.WeatherInfo.baseURL + "\(location.latitude),\(location.longitude)?units=si"
        //setup url session
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        if let url = URL(string: urlString) {
            session.dataTask(
                with: url,
                completionHandler: { (data, response, error) in
                    guard let responseData = data else {
                        return
                    }
                    //Parse the API response
                    do {
                        guard let dict = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: .allowFragments) as? [String: Any],
                            let currentlyDict = dict["currently"] as? [String: Any],
                            let currentTemp = currentlyDict["temperature"] as? CGFloat else {
                                print("Could not parse JSON")
                                return
                        }
                        
                        DispatchQueue.main.async(execute: { [weak self] in
                            self?.delegate?.currentTemperature(temperature: currentTemp)
                        })
                    } catch {}
            }).resume()
        }
    }
    
    //MARK: Public method
    func fetchCurrentWeatherInfo() {
        configureLocationManager()
    }
}

extension WeatherForecastFetcher: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let recentLocation = locations.last {
            //Request for weather details
            fetchWeatherInfo(forLocation: recentLocation.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
