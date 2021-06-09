//
//  CitySearchViewController.swift
//  Weather
//
//  Created by Ankit Kulkarni on 09/06/21.
//

import Foundation
import UIKit
import MapKit

/*
 The autocomplete search view controller to search for locations.
 */
class CitySearchViewController: UIViewController {
    
    var searchCompleter: MKLocalSearchCompleter?
    var searchResults = [MKLocalSearchCompletion]()
    let viewModel = CitySearchViewModel()
    weak var delegate: CitySearchViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        setupSearchController()
        setupTableView()
        bind()
    }
    
    private func bind() {
        self.viewModel.didFetchCoordinates = { [weak self] place, coord in
            guard let coordinates = coord else {
                self?.delegate?.didFailToGetCoordinates()
                return
            }
            self?.delegate?.didGetCoordinatesForPlace(place: place, coordinates: coordinates)
            self?.dismiss(animated: true, completion: nil)
        }
    }
    private func setupTextField() {
        self.searchTextField.delegate = self
        self.searchTextField.addTarget(self, action: #selector(textFieldDidChangeText), for: .editingChanged)
        self.searchTextField.becomeFirstResponder()
    }
    
    private func setupSearchController() {
        searchCompleter = MKLocalSearchCompleter()
        searchCompleter?.pointOfInterestFilter = .excludingAll
        searchCompleter?.delegate = self
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

//MARK: IBActions
extension CitySearchViewController {
    @IBAction func didTapCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: UITextField related functions
extension CitySearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchCompleter?.queryFragment = textField.text ?? ""
        self.searchTextField.resignFirstResponder()
        if searchCompleter?.queryFragment.isEmpty ?? true {
            self.clearSearchResults()
        }
        return true
    }
    
    @objc func textFieldDidChangeText() {
        guard let searchText = self.searchTextField.text else {
            return
        }
        if searchText.isEmpty {
            clearSearchResults()
        }
        self.searchCompleter?.queryFragment = searchText
    }
    
    private func clearSearchResults() {
        self.searchResults.removeAll()
        self.tableView.reloadData()
    }
}

//MARK: MKLocalSearchCompleterDelegate functions
extension CitySearchViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
    }
}

//MARK: UITableView delegate functions
extension CitySearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CitySearchCell"), self.searchResults.count > indexPath.row else {
            fatalError("This should not be nil")
        }
        cell.textLabel?.text = self.searchResults[indexPath.row].title
        cell.detailTextLabel?.text = self.searchResults[indexPath.row].subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < self.searchResults.count else {
            return
        }
        let result = self.searchResults[indexPath.row]
        self.viewModel.getCoordinatesFromResult(result: result)
    }
}
 
protocol CitySearchViewControllerDelegate: class {
    func didGetCoordinatesForPlace(place: String, coordinates: CLLocationCoordinate2D)
    func didFailToGetCoordinates()
}
