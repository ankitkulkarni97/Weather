//
//  APIServiceManager.swift
//  Weather
//
//  Created by Ankit Kulkarni on 09/06/21.
//

import Foundation

protocol  ServiceManager {
    func getWeatherData(for city: String, success: @escaping (WeatherResponseModel?) -> Void, failure: @escaping (Error) -> Void)
}

class ServiceManagerImplementation: ServiceManager {
    func getWeatherData(for city: String, success: @escaping (WeatherResponseModel?) -> Void, failure: @escaping (Error) -> Void) {
        guard let url = URL(string: Constants.Urls.getOpenWeatherUrl(for: city)) else {
            return
        }
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
        guard let data = data else { return }
            do {
                let weatherData = try JSONDecoder().decode(WeatherResponseModel.self, from: data)
                success(weatherData)
            } catch let error {
                 print(error)
            }
        }.resume()
    }
}
