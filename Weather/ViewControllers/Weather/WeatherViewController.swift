//
//  WeatherViewController.swift
//  Weather
//
//  Created by Ankit Kulkarni on 09/06/21.
//

import Foundation
import UIKit
import MapKit

class  WeatherViewController: UIViewController {
    
    let viewModel = WeatherViewModel()
    
    @IBOutlet weak var minTempStackView: UIStackView!
    @IBOutlet weak var maxTempStackView: UIStackView!
    @IBOutlet weak var feelsLikeStackView: UIStackView!
    @IBOutlet weak var sunriseStackView: UIStackView!
    @IBOutlet weak var sunsetStackView: UIStackView!
    @IBOutlet weak var humidityStackView: UIStackView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favouriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customizeUI()
        self.bind()
    }
    
    func bind() {

        self.viewModel.didFetchWeatherDataSucceed = { [weak self] in
            self?.populateUI()
        }
        
        self.viewModel.didFetchWeatherDataFail = { [weak self] error in
            self?.showAlert(error: error)
        }
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
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.isHidden = true
    }
    
    func populateUI() {
        self.cityNameLabel.text = self.viewModel.place
        setTemperatureLabelText()
        setMinTempLabelText()
        setMaxTempLabelText()
        setFeelsLikeLabelText()
        setHumidityLabelText()
        setSunriseLabelText()
        setSunsetLabelText()
        setFavouriteButtonImage(isFavourite: self.viewModel.weatherData?.isFavourite ?? false)
        self.weatherDescriptionLabel.text = self.viewModel.weatherData?.weather?.first?.main
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
    
    func setTemperatureLabelText() {
        guard let temperature = self.viewModel.weatherData?.main?.temp else {
            self.temperatureLabel.text = "-"
            return
        }
        self.temperatureLabel.text = "\(temperature)º"
    }
    
    func setMinTempLabelText() {
        guard let temperature = self.viewModel.weatherData?.main?.tempMin else {
            self.minTempLabel.text = "-"
            return
        }
        self.minTempLabel.text = "\(temperature)º"
    }
    
    func setMaxTempLabelText() {
        guard let temperature = self.viewModel.weatherData?.main?.tempMax else {
            self.maxTempLabel.text = "-"
            return
        }
        self.maxTempLabel.text = "\(temperature)º"
    }
    
    func setFeelsLikeLabelText() {
        guard let temperature = self.viewModel.weatherData?.main?.feelsLike else {
            self.feelsLikeLabel.text = "-"
            return
        }
        self.feelsLikeLabel.text = "\(temperature)º"
    }
    
    func setHumidityLabelText() {
        guard let humidity = self.viewModel.weatherData?.main?.humidity else {
            self.humidityLabel.text = "-"
            return
        }
        self.humidityLabel.text = "\(humidity)%"
    }
    
    func setSunriseLabelText() {
        guard let sunriseEpoch = self.viewModel.weatherData?.sys?.sunrise else {
            self.sunriseLabel.text = "-"
            return
        }
        let time  = Date(timeIntervalSince1970: sunriseEpoch)
        let dateFormatter = DateFormatter()
        let timezone = TimeZone(secondsFromGMT: self.viewModel.weatherData?.timezone ?? 0)
        dateFormatter.timeZone = timezone
        dateFormatter.timeStyle = .short
        let sunriseTime = dateFormatter.string(from: time)
        self.sunriseLabel.text = sunriseTime
    }
    
    func setSunsetLabelText() {
        guard let sunsetEpoch = self.viewModel.weatherData?.sys?.sunset else {
            self.sunsetLabel.text = "-"
            return
        }
        let time  = Date(timeIntervalSince1970: sunsetEpoch)
        let dateFormatter = DateFormatter()
        let timezone = TimeZone(secondsFromGMT: self.viewModel.weatherData?.timezone ?? 0)
        dateFormatter.timeZone = timezone
        dateFormatter.timeStyle = .short
        let sunsetTime = dateFormatter.string(from: time)
        self.sunsetLabel.text = sunsetTime
    }
    
    func showAlert(error: Error?) {
        let alertVC = UIAlertController(title: "Error", message: error.debugDescription, preferredStyle: .alert)
        let alertAction  = UIAlertAction(title: "OK", style: .default, handler: { _ in
            alertVC.dismiss(animated: true, completion: nil)
        })
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
}

//MARK: CitySearchVC related functions

extension WeatherViewController: CitySearchViewControllerDelegate {
    @IBAction func didTapSearchButton() {
        guard let citySearchVC = UIStoryboard(name: "CitySearchViewController", bundle: nil).instantiateInitialViewController() as? CitySearchViewController else {
            return
        }
        citySearchVC.delegate = self
        self.present(citySearchVC, animated: true, completion: nil)
    }
    
    func didFailToGetCoordinates() {
        let alertVC = UIAlertController(title: "Error", message: "Failed to fetch weather data.", preferredStyle: .alert)
        let alertAction  = UIAlertAction(title: "OK", style: .default, handler: { _ in
            alertVC.dismiss(animated: true, completion: nil)
        })
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func didGetCoordinatesForPlace(place: String, coordinates: CLLocationCoordinate2D) {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        self.viewModel.fetchWeatherData(for: coordinates)
        self.viewModel.place = place
    }
}

//MARK: Favourite related functions

extension WeatherViewController {
    
    @IBAction func didTapFavouritesButton() {
        guard let place = self.viewModel.place else {
            fatalError("Place name cannot be nil")
        }
        if (self.viewModel.weatherData?.isFavourite ?? false) {
            self.viewModel.weatherData?.isFavourite = false
            setFavouriteButtonImage(isFavourite: false)
            self.viewModel.favourites.removeValue(forKey: place)
        } else {
            self.viewModel.weatherData?.isFavourite = true
            setFavouriteButtonImage(isFavourite: true)
            self.viewModel.favourites[place] = self.viewModel.weatherData
        }
    }
    
    func setFavouriteButtonImage(isFavourite: Bool) {
        if isFavourite {
            self.favouriteButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
            self.favouriteButton.tintColor = .systemRed
        } else {
            self.favouriteButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
            self.favouriteButton.tintColor = .white
        }
    }
}

//MARK: Favourites VC related functions

extension WeatherViewController: FavouritesViewControllerDelegate {
    
    @IBAction func didTapFavouritesMenu() {
        guard let favouritesVC = UIStoryboard(name: "FavouritesViewController", bundle: nil).instantiateInitialViewController() as? FavouritesViewController else {
            return
        }
        let places = Array(self.viewModel.favourites.keys)
        let favouritesVM = FavouritesViewModel(favourites: places)
        favouritesVC.viewModel = favouritesVM
        favouritesVC.delegate = self
        self.navigationController?.pushViewController(favouritesVC, animated: true)
    }
    
    func didSelectPlace(place: String) {
        guard let weatherData = self.viewModel.favourites[place] else {
            //error handle
            return
        }
        self.viewModel.weatherData = weatherData
        self.viewModel.place = place
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        self.populateUI()
    }
}

