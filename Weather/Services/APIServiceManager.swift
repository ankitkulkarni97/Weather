//
//  APIServiceManager.swift
//  Weather
//
//  Created by Ankit Kulkarni on 09/06/21.
//

import Foundation

protocol  ServiceManager {
    func getWeatherData(lattitude: Double, longitude: Double, success: @escaping (WeatherResponseModel?) -> Void, failure: @escaping (Error?) -> Void)
}

class ServiceManagerImplementation: ServiceManager {
    func getWeatherData(lattitude: Double, longitude: Double, success: @escaping (WeatherResponseModel?) -> Void, failure: @escaping (Error?) -> Void) {
        guard let url = URL(string: Constants.Urls.getOpenWeatherUrl(lattitude: lattitude, longitude: longitude)) else {
            return
        }
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
        guard let data = data else { return }
            if error != nil {
                DispatchQueue.main.async {
                    failure(error)
                }
            }
            do {
                let weatherData = try JSONDecoder().decode(WeatherResponseModel.self, from: data)
                DispatchQueue.main.async {
                    success(weatherData)
                }
            } catch let error {
                 print(error)
            }
        }.resume()
    }
}
