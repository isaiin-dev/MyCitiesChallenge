//
//  CityListInteractor.swift
//  MyCitiesChallenge
//
//  Created by Alejandro isai Acosta Martinez on 05/03/25.
//  Copyright (c) 2025 ___ORGANIZATIONNAME___. All rights reserved.
//
//  The interactor is responsible for managing data from the model layer 
//  (note that Model is not part of the VIPER architecture, feel free to 
//  implement it or not, but for sure it will make our app more concise).
//
//  This file was generated by the IsaiinDev's iOS Templates so
//  you can apply clean architecture to your iOS projects.
//

import Foundation

protocol CityListBusinessLogic {
    func loadCities(request: CityList.LoadCities.Request)
    func fetchCitiesPage(request: CityList.FetchPage.Request)
    func searchCitiesByPrefix(_ prefix: String)
    func goToCityDetail(city: CityList.City)
}

final class CityListInteractor: Interactor, CityListBusinessLogic {
   
    // MARK: - Properties

    var presenter: CityListPresentationLogic?
    var router: CityListRoutingLogic?
    let worker = CityListWorker()
    
    private let repository: CitiesRepositoryProtocol = CitiesRepository()

    // MARK: - Business Logic

    func loadCities(request: CityList.LoadCities.Request) {
        repository.loadCitiesIfNeeded { [weak self] success in
            if success {
                let response = CityList.LoadCities.Response(cities: self?.repository.loadedCities ?? [])
                self?.presenter?.presentCities(cities: response)
            } else {
                self?.presenter?.presentFailure(message: "Failed to load cities")
            }
        }
    }
    
    func fetchCitiesPage(request: CityList.FetchPage.Request) {
        repository.loadCitiesIfNeeded { [weak self] success in
            guard let self = self else { return }
            if success {
                let cities = self.repository.fetchPage(pageSize: request.pageSize, offset: request.offset)
                let response = CityList.FetchPage.Response(cities: cities)
                DispatchQueue.main.async {
                    self.presenter?.presentCities(cities: CityList.LoadCities.Response(cities: response.cities))
                }
            } else {
                DispatchQueue.main.async {
                    self.presenter?.presentFailure(message: "Failed to load cities.")
                }
            }
        }
    }
    
    func searchCitiesByPrefix(_ prefix: String) {
        let filtered = repository.searchCities(prefix: prefix)
        presenter?.presentFilteredCities(cities: CityList.SearchCities.Response(filteredCities: filtered))
    }

    // MARK: - Routing Logic

    func goToCityDetail(city: CityList.City) {
        router?.routeToCityDetail(city: city)
    }
}
