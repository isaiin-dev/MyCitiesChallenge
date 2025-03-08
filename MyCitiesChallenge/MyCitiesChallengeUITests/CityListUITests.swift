//
//  CityListUITests.swift
//  MyCitiesChallengeUITests
//
//  Created by Alejandro isai Acosta Martinez on 08/03/25.
//

import XCTest

/// UI tests for the City List screen.
final class CityListUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments.append("UI_TEST_MODE")
        app.launch()
    }

    override func tearDownWithError() throws {

    }

    /// Tests that the CityList screen displays the navigation bar, search bar, and table view.
    func testCityListScreenLoads() throws {
        let app = XCUIApplication()
        XCTAssertTrue(app.navigationBars["Cities"].exists)
        XCTAssertTrue(app.searchFields["Search for cities..."].exists)
        XCTAssertTrue(app.tables.firstMatch.exists)
    }
    
    /// Tests that typing into the search bar filters the table view results.
    func testCitySearchFiltering() throws {
        let app = XCUIApplication()
        let searchField = app.searchFields["Search for cities..."]
        XCTAssertTrue(searchField.exists)
        searchField.tap()
        searchField.typeText("Au")
        let table = app.tables.firstMatch
        XCTAssertGreaterThan(table.cells.count, 0, "Filtered results should be greater than 0")
    }
    
    /// Tests that scrolling to the bottom of the table triggers loading more cities.
    func testCityListPagination() throws {
       let app = XCUIApplication()
       let table = app.tables.firstMatch
       XCTAssertTrue(table.exists)
       table.swipeUp()
       XCTAssertGreaterThan(table.cells.count, 20, "Table should load more cells on scroll for pagination")
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
