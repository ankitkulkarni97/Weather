//
//  FavouritesViewController.swift
//  Weather
//
//  Created by Ankit Kulkarni on 09/06/21.
//

import Foundation
import UIKit

/*
 List of favourites displayed in a UITableView
 */
class FavouritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: FavouritesViewModel!
    weak var delegate: FavouritesViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func didTapCloseButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.favouritesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavouritesCell") else {
            fatalError("This should not be nil")
        }
        cell.textLabel?.text = self.viewModel.getItemAt(index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let place = self.viewModel.getItemAt(index: indexPath.row) else {
            return
        }
        self.delegate?.didSelectPlace(place: place)
        self.navigationController?.popViewController(animated: true)
    }
}

protocol FavouritesViewControllerDelegate: class {
    func didSelectPlace(place: String)
}
