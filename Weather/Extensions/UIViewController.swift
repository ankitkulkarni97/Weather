//
//  UIViewController.swift
//  Weather
//
//  Created by Ankit Kulkarni on 09/06/21.
//

import Foundation
import UIKit

extension UIViewController {
    static func weatherViewController() -> WeatherViewController {
        guard let weatherVC = UIStoryboard(name: "WeatherViewController", bundle: nil).instantiateInitialViewController() as? WeatherViewController else {
            fatalError("This should not be null.")
        }
        weatherVC.modalPresentationStyle = .fullScreen
        return weatherVC
    }
}
