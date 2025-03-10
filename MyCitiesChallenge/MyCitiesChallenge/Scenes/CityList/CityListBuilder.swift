//
//  CityListBuilder.swift
//  MyCitiesChallenge
//
//  Created by Alejandro isai Acosta Martinez on 05/03/25.
//  Copyright (c) 2025 ___ORGANIZATIONNAME___. All rights reserved.
//
//  The Builder is responsible for assembling the VIPER scene (Interactor,
//  Presenter, Router, and View) and returning a fully configured UIViewController.
//
//  This file was generated by the IsaiinDev's iOS Templates so
//  you can apply Clean Architecture to your iOS projects.
//

import UIKit

enum CityListBuilder {
    static func build() -> UIViewController {
        let viewController = CityListViewController()
        let interactor = CityListInteractor()
        let presenter = CityListPresenter()
        let router = CityListRouter()

        // Inject dependencies
        viewController.interactor = interactor
        interactor.presenter = presenter
        interactor.router = router
        router.view = viewController
        presenter.view = viewController

        return viewController
    }
}
