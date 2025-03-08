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
    var favoriteChangedAction: (() -> Void)?
    
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
    
    // MARK: - Model
    
    /// The city model to be displayed in the cell.
    var city: CityList.City? {
        didSet {
            guard let city = city else { return }
            titleLabel.text = "\(city.name), \(city.country)"
            subtitleLabel.text = "Lat: \(city.coord.lat), Lon: \(city.coord.lon)"
            favouriteButton.isSelected = CitiesRepository.shared.isFavorite(city: city)
        }
    }
    
    // MARK: - Actions Callbacks
    
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
        
        // Set up button targets.
        favouriteButton.addTarget(self, action: #selector(toggleFavourite), for: .touchUpInside)
    }
    
    /// Sets up Auto Layout constraints for all subviews.
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            favouriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favouriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            favouriteButton.widthAnchor.constraint(equalToConstant: 30),
            favouriteButton.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: favouriteButton.leadingAnchor, constant: -8),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    // MARK: - Button Actions
    
    /// Toggles the favourite state and calls the associated closure.
    @objc private func toggleFavourite() {
        favouriteButton.isSelected.toggle()
        guard let city = self.city else { return }
        if favouriteButton.isSelected {
            CitiesRepository.shared.addFavorite(city: city)
        } else {
            CitiesRepository.shared.removeFavorite(city: city)
        }
        favoriteChangedAction?()
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
    }
}
