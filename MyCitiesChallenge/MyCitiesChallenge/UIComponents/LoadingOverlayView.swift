//
//  LoadingOverlayView.swift
//  MyCitiesChallenge
//
//  Created by Alejandro isai Acosta Martinez on 06/03/25.
//

import UIKit

/// A custom view that displays a blurred overlay with an activity indicator and a loading label.
class LoadingOverlayView: UIVisualEffectView {
    
    // MARK: - UI Components
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()
    
    private lazy var loadingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Cargando ciudades..."
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    // MARK: - Initializer
    
    init() {
        let blurEffect = UIBlurEffect(style: .light)
        super.init(effect: blurEffect)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        self.alpha = 0.8
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subviews to the content view of the visual effect view.
        contentView.addSubview(activityIndicator)
        contentView.addSubview(loadingLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Center the activity indicator in the overlay.
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -20),
            
            // Position the label below the activity indicator.
            loadingLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 8),
            loadingLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
