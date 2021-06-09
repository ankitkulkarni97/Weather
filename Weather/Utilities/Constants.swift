//
//  Constants.swift
//  Weather
//
//  Created by Ankit Kulkarni on 09/06/21.
//

import Foundation

struct Constants {
    static let OPENWEATHER_API_KEY = "0dcdf907b7f612a08a2d8c77b38d2e59"
    
    struct Urls {
        static func getOpenWeatherUrl(lattitude: Double, longitude: Double) -> String {
            let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(lattitude)&lon=\(longitude)&units=metric&appid=\(Constants.OPENWEATHER_API_KEY)"
            return url
        }
    }
}
