//
//  SettingsPresenter.swift
//  MyCitiesChallenge
//
//  Created by Alejandro isai Acosta Martinez on 08/03/25.
//  Copyright (c) 2025 ___ORGANIZATIONNAME___. All rights reserved.
//
//  The presenter is the only layer that communicates with the view
//  (The rest of layers communicate with the presenter). Basically,
//  it’s the layer responsible for making decisions based on the
//  user’s actions sent by The View.
//
//  This file was generated by the IsaiinDev's iOS Templates so
//  you can apply clean architecture to your iOS projects.
//

import Foundation

protocol SettingsPresentationLogic {
    func presentResetFavoritesSuccess()
    func presentFailure(message: String)
}

final class SettingsPresenter: Presenter, SettingsPresentationLogic {
    
    // MARK: - Properties

    weak var view: SettingsDisplayLogic?

    // MARK: - Presentation Logic

    func presentResetFavoritesSuccess() {
        view?.displayResetFavoritesSuccessfully()
    }

    func presentFailure(message: String) {
        view?.displayFailure(message: message)
    }
}
