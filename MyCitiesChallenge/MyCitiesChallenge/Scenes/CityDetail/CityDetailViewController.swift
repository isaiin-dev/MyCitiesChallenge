//
//  CityDetailViewController.swift
//  MyCitiesChallenge
//
//  Created by Alejandro isai Acosta Martinez on 07/03/25.
//

import UIKit
import MapKit

/// View controller that displays detailed information for a selected city.
class CityDetailViewController: UIViewController {
    
    /// The selected city whose details are shown.
    let city: CityList.City
    
    /// Map view to display the city location.
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    /// Card view to display full city details.
    private lazy var infoCardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 5
        return view
    }()
    
    /// Label to show all details about the city.
    private lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    /// Initializes the view controller with the selected city.
    init(city: CityList.City) {
        self.city = city
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = city.name
        navigationItem.largeTitleDisplayMode = .never
        setupViews()
        setupConstraints()
        configureMap()
        configureCard()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    
    /// Adds the map view and info card to the view.
    private func setupViews() {
        view.addSubview(mapView)
        view.addSubview(infoCardView)
        infoCardView.addSubview(detailsLabel)
    }
    
    /// Sets up Auto Layout constraints for map view and info card.
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Map view occupies the top half of the screen.
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            // Info card view is below the map with padding.
            infoCardView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 16),
            infoCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infoCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            infoCardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            // Details label fills the info card view with padding.
            detailsLabel.topAnchor.constraint(equalTo: infoCardView.topAnchor, constant: 16),
            detailsLabel.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor, constant: 16),
            detailsLabel.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor, constant: -16),
            detailsLabel.bottomAnchor.constraint(equalTo: infoCardView.bottomAnchor, constant: -16)
        ])
    }
    
    /// Configures the map by adding an annotation at the city's coordinates.
    private func configureMap() {
        let coordinate = CLLocationCoordinate2D(latitude: city.coord.lat, longitude: city.coord.lon)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(city.name), \(city.country)"
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)
    }
    
    /// Populates the info card with the city's full details.
    private func configureCard() {
        detailsLabel.text = """
        City: \(city.name)
        Country: \(city.country)
        ID: \(city.id)
        Coordinates: Lat \(city.coord.lat), Lon \(city.coord.lon)
        """
    }
}
