//
//  CitiesRepositoryTests.swift
//  MyCitiesChallengeTests
//
//  Created by Alejandro isai Acosta Martinez on 08/03/25.
//

import XCTest
@testable import MyCitiesChallenge

class CitiesRepositoryTests: XCTestCase {

    var repository: CitiesRepository!

    override func setUp() {
        super.setUp()
        repository = CitiesRepository.shared
        let expectation = self.expectation(description: "Load cities")
        repository.loadCitiesIfNeeded { success in
            XCTAssertTrue(success, "Cities should load successfully")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }

    override func tearDown() {
        repository = nil
        super.tearDown()
    }

    /// Test that searching with an empty prefix returns all cities.
    func testSearchWithEmptyPrefixReturnsAllCities() {
        let allCities = repository.loadedCities
        let result = repository.searchCities(prefix: "")
        XCTAssertEqual(result.count, allCities.count, "Empty prefix should return all cities")
    }

    /// Test that searching with a valid prefix returns the correct subset.
    func testSearchWithValidPrefix() {
        let result = repository.searchCities(prefix: "Al")
        for city in result {
            XCTAssertTrue(city.name.lowercased().hasPrefix("al"), "City name should start with 'al'")
        }
    }

    /// Test that searching with a prefix that matches no city returns an empty array.
    func testSearchWithInvalidPrefixReturnsEmpty() {
        let result = repository.searchCities(prefix: "XYZ")
        XCTAssertTrue(result.isEmpty, "Search with an invalid prefix should return an empty array")
    }
}
