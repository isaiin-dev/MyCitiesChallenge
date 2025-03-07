//
//  CityTableViewCell.swift
//  MyCitiesChallenge
//
//  Created by Alejandro isai Acosta Martinez on 06/03/25.
//

import UIKit

/// A custom cell that displays city information including title, coordinates,
/// a favourite toggle, and an info button to open detailed information.
class CityTableViewCell: UITableViewCell {
    
    // MARK: - Static Properties
    
    public static let IDENTIFIER = "CityTableViewCell"
    
    // MARK: - UI Components
    
    /// Label to display the city name and country.
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Label to display the city coordinates.
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Button to toggle the favourite status of the city.
    private lazy var favouriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Button that opens an information screen for the selected city.
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Info", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Model
    
    /// The city model to be displayed in the cell.
    var city: CityList.City? {
        didSet {
            guard let city = city else { return }
            // Update the title label with the city name and country.
            titleLabel.text = "\(city.name), \(city.country)"
            // Update the subtitle label with the coordinates.
            subtitleLabel.text = "Lat: \(city.coord.lat), Lon: \(city.coord.lon)"
            // The favourite button state should be set based on your favourite logic.
            // For instance, using a shared FavoritesManager (not shown here).
            // favouriteButton.isSelected = FavoritesManager.shared.isFavorite(city: city)
        }
    }
    
    // MARK: - Actions Callbacks
    
    /// Closure to be called when the favourite button is toggled.
    var favouriteToggleAction: (() -> Void)?
    
    /// Closure to be called when the info button is tapped.
    var infoButtonAction: (() -> Void)?
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    /// Adds subviews and configures targets for buttons.
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(favouriteButton)
        contentView.addSubview(infoButton)
        
        // Set up button targets.
        favouriteButton.addTarget(self, action: #selector(toggleFavourite), for: .touchUpInside)
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
    }
    
    /// Sets up Auto Layout constraints for all subviews.
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            favouriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favouriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            favouriteButton.widthAnchor.constraint(equalToConstant: 30),
            favouriteButton.heightAnchor.constraint(equalToConstant: 30),
            
            infoButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            infoButton.trailingAnchor.constraint(equalTo: favouriteButton.leadingAnchor, constant: -8),
            infoButton.widthAnchor.constraint(equalToConstant: 50),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: infoButton.leadingAnchor, constant: -8),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    // MARK: - Button Actions
    
    /// Toggles the favourite state and calls the associated closure.
    @objc private func toggleFavourite() {
        favouriteToggleAction?()
        favouriteButton.isSelected.toggle()
    }
    
    /// Calls the info action closure when the info button is tapped.
    @objc private func infoButtonTapped() {
        infoButtonAction?()
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        favouriteButton.isSelected = false
        infoButton.setTitle("Info", for: .normal)
    }
}
