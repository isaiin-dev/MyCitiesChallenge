//
//  CityListViewController.swift
//  MyCitiesChallenge
//
//  Created by Alejandro isai Acosta Martinez on 05/03/25.
//  Copyright (c) 2025 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This layer contains the UI logic (display, update, animate…)
//  and is responsible for intercepting the user’s action and
//  sending it to the Presenter. Most importantly, it has no business logic.
//
//  This file was generated by the IsaiinDev's iOS Templates so
//  you can apply Clean Architecture to your iOS projects.
//

import UIKit
import MapKit

protocol CityListDisplayLogic: ViewLayer {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func displayCities(cities: CityList.LoadCities.Response)
    func displayFilteredCities(cities: CityList.SearchCities.Response)
    func displayFailure(message: String)
}

class CityListViewController: UIViewController {
    
    // MARK: - Properties
    
    var interactor: CityListBusinessLogic?
    
    private var cities = [CityList.City]() {
        didSet {
            self.tableView.reloadData()
            updateMapAnnotations()
        }
    }

    private let pageSize = 20                          
    private var currentPage = 0
    private var isPaginating = false
    private var isFiltering = false

    
    private var portraitConstraints: [NSLayoutConstraint] = []
    private var landscapeConstraints: [NSLayoutConstraint] = []
    
    private let citiesRepository = CitiesRepository()
    
    private let loadingOverlay = LoadingOverlayView()
    
    // MARK: - Subviews
    
    /// UISearchController for cities search and filtering
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.searchBar.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search for cities..."
        return sc
    }()
    
    /// UITableView to display the list of filtered city results.
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.dataSource = self
        tv.delegate = self
        tv.register(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCell.IDENTIFIER)
        return tv
    }()
    
    /// Lazy initialization for the map view to display city annotations.
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    // MARK: - Object Lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        updateLayoutForCurrentOrientation()
        
        loadNextPage()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // Update layout constraints when orientation changes
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.updateLayoutForSize(size)
        })
    }
    
    // MARK: - Setup Methods
    
    /// Configures the view by adding subviews and setting the background color.
    private func setupView() {
        self.title = "Cities"
        view.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        // Add subviews to the main view
        view.addSubview(tableView)
        view.addSubview(mapView)
    }
    
    /// Sets up the Auto Layout constraints for both portrait and landscape orientations.
    private func setupConstraints() {
        portraitConstraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        landscapeConstraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
    }
    
    /// Activates the appropriate constraints based on the current orientation.
    private func updateLayoutForCurrentOrientation() {
        if view.bounds.width > view.bounds.height {
            NSLayoutConstraint.deactivate(portraitConstraints)
            NSLayoutConstraint.activate(landscapeConstraints)
            mapView.isHidden = false
        } else {
            NSLayoutConstraint.deactivate(landscapeConstraints)
            NSLayoutConstraint.activate(portraitConstraints)
            mapView.isHidden = true
        }
    }
    
    /// Updates the layout constraints based on a given size.
    /// - Parameter size: The new size of the view after orientation change.
    private func updateLayoutForSize(_ size: CGSize) {
        if size.width > size.height {
            NSLayoutConstraint.deactivate(portraitConstraints)
            NSLayoutConstraint.activate(landscapeConstraints)
            mapView.isHidden = false
        } else {
            NSLayoutConstraint.deactivate(landscapeConstraints)
            NSLayoutConstraint.activate(portraitConstraints)
            mapView.isHidden = true
        }
        view.layoutIfNeeded()
    }
    
    private func loadNextPage() {
        guard !isPaginating else {
            return
        }
        
        isPaginating = true
        showLoadingIndicator()
        
        let offset = currentPage * pageSize
        
        interactor?.fetchCitiesPage(
            request: CityList.FetchPage.Request(
                pageSize: pageSize,
                offset: offset))
    }
    
    /// Updates the map view annotations based on the currently displayed cities.
    private func updateMapAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        
        for city in cities {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: city.coord.lat, longitude: city.coord.lon)
            annotation.title = "\(city.name), \(city.country)"
            mapView.addAnnotation(annotation)
        }
        
        if !mapView.annotations.isEmpty {
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }

}

// MARK: - UISearchResultsUpdating
extension CityListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        
        if query.isEmpty {
            isFiltering = false
            loadNextPage()
        } else {
            isFiltering = true
            interactor?.searchCitiesByPrefix(query)
        }
    }
}

// MARK: - UISearchBarDelegate
extension CityListViewController: UISearchBarDelegate {
    /// Restore paginated data when search is cancelled.
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isFiltering = false
        loadNextPage()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension CityListViewController: UITableViewDataSource, UITableViewDelegate {
    /// Returns the number of rows in the table view based on the placeholder cities array.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    /// Configures and returns a cell for the given row index.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.IDENTIFIER, for: indexPath) as? CityTableViewCell else {
            return UITableViewCell()
        }
        
        let city = cities[indexPath.row]
        cell.city = city
        
        return cell
    }
    
    /// Called when a table row is selected. Notifies the interactor about the selection.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = cities[indexPath.row]
        interactor?.goToCityDetail(city: selectedCity)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == cities.count - 1 && !isPaginating && !isFiltering {
            loadNextPage()
        }
    }
}
// MARK: - Display Logic

extension CityListViewController: CityListDisplayLogic {
    func showLoadingIndicator() {
        view.addSubview(loadingOverlay)
        NSLayoutConstraint.activate([
            loadingOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            loadingOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func hideLoadingIndicator() {
        loadingOverlay.removeFromSuperview()
    }
    
    func displayCities(cities: CityList.LoadCities.Response) {
        hideLoadingIndicator()
        self.cities.append(contentsOf: cities.cities)
        currentPage += 1
        isPaginating = false
        print("Cities succesfully loaded")
    }
    
    func displayFilteredCities(cities: CityList.SearchCities.Response) {
        hideLoadingIndicator()
        self.cities = cities.filteredCities
    }
    
    func displayFailure(message: String) {
        hideLoadingIndicator()
        isPaginating = false
        print("Something went wrong: \(message)")
    }
}
