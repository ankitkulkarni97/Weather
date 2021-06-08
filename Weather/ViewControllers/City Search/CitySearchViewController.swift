//
//  CitySearchViewController.swift
//  Weather
//
//  Created by Ankit Kulkarni on 09/06/21.
//

import Foundation
import UIKit
import MapKit


class CitySearchViewController: UIViewController {
    
    var searchCompleter: MKLocalSearchCompleter?
    var searchResults: [MKLocalSearchCompletion]?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupSearchController() {
        searchCompleter = MKLocalSearchCompleter()
        searchCompleter?.delegate = self
        var searchResults = [MKLocalSearchCompletion]()
        searchCompleter?.queryFragment = "Ben"
    }
}

extension CitySearchViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(completer: MKLocalSearchCompleter) {
           searchResults = completer.results
//           searchResultsTableView.reloadData()
       }

       func completer(completer: MKLocalSearchCompleter, didFailWithError error: NSError) {
           // handle error
       }
}
