//
//  FavouritesViewModel.swift
//  Weather
//
//  Created by Ankit Kulkarni on 09/06/21.
//

import Foundation

class FavouritesViewModel {
    var favourites: [String]
    
    init(favourites: [String]) {
        self.favourites = favourites
    }
    
    func getItemAt(index: Int) -> String? {
        if index < self.favourites.count {
            return favourites[index]
        }
        return nil
    }
    
    func favouritesCount() -> Int {
        return self.favourites.count
    }
}
