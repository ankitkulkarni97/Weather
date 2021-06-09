//
//  CitySearchViewModel.swift
//  Weather
//
//  Created by Ankit Kulkarni on 09/06/21.
//

import Foundation
import MapKit

class CitySearchViewModel {
    
    var didFetchCoordinates: ((String, CLLocationCoordinate2D?) -> Void)?
    
    func getCoordinatesFromResult(result: MKLocalSearchCompletion) {
        let request = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: { [weak self] response, error in
            if error != nil {
                self?.didFetchCoordinates?(result.title, nil)
                return
            }
            guard let coord = response?.mapItems.first?.placemark.coordinate else {
                self?.didFetchCoordinates?(result.title, nil)
                return
            }
            self?.didFetchCoordinates?(result.title, coord)
            
        })
    }
}
