//
//  WeatherViewController.swift
//  Weather
//
//  Created by Ankit Kulkarni on 09/06/21.
//

import Foundation
import UIKit

class  WeatherViewController: UIViewController {
    
    @IBOutlet weak var minTempStackView: UIStackView!
    @IBOutlet weak var maxTempStackView: UIStackView!
    @IBOutlet weak var feelsLikeStackView: UIStackView!
    @IBOutlet weak var sunriseStackView: UIStackView!
    @IBOutlet weak var sunsetStackView: UIStackView!
    @IBOutlet weak var humidityStackView: UIStackView!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customizeUI()
    }
    
    func customizeUI() {
        let stackViewBgndColour = UIColor.systemGroupedBackground.withAlphaComponent(0.7)
        let labelBgndColour = UIColor.systemGroupedBackground.withAlphaComponent(0.7)
        minTempStackView.backgroundColor = stackViewBgndColour
        maxTempStackView.backgroundColor = stackViewBgndColour
        sunriseStackView.backgroundColor = stackViewBgndColour
        sunsetStackView.backgroundColor = stackViewBgndColour
        humidityStackView.backgroundColor = stackViewBgndColour
        feelsLikeStackView.backgroundColor = stackViewBgndColour
        cityNameLabel.backgroundColor = labelBgndColour
    }
    
}

extension WeatherViewController {
    func didSearchCity() {
//        let autocompleteVC = GMSAutocompleteViewController()
//        let filter = GMSAutocompleteFilter()
//        filter.type = .city
//        autocompleteVC.autocompleteFilter = filter
//        autocompleteVC.delegate = self
//        self.present(autocompleteVC, animated: true, completion: nil)
    }
}
