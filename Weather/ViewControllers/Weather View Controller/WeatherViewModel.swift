//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Ankit Kulkarni on 09/06/21.
//

import Foundation
import MapKit

class WeatherViewModel {
    
    var didFetchWeatherDataSucceed: (() -> Void)?
    var didFetchWeatherDataFail: ((Error?) -> Void)?
    var weatherData: WeatherResponseModel?
    var place: String?
    
    func fetchWeatherData(for coordinates: CLLocationCoordinate2D) {
        let serviceManager = ServiceManagerImplementation()
        serviceManager.getWeatherData(lattitude: coordinates.latitude, longitude: coordinates.longitude, success: { [weak self] weatherData in
            self?.weatherData = weatherData
            self?.didFetchWeatherDataSucceed?()
        }, failure: { [weak self] error in
            self?.didFetchWeatherDataFail?(error)
        })
    }
}
