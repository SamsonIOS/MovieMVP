// MovieMVPUITests.swift
// Copyright © RoadMap. All rights reserved.

import XCTest

final class MovieMVPUITests: XCTestCase {
    // MARK: - Constants

    private enum Constants {
        static let firstButtonID = "firstButton"
        static let secondButtonID = "secondButton"
        static let thirdButtonID = "thirdButton"
        static let moviesViewControllerID = "moviesViewController"
        static let moviesCell = "moviesCell"
        static let numberOfCell = 3
    }

    // MARK: - Public Methods

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        app.swipeUp()
        app.swipeDown()
        let firstButton = app
            .descendants(matching: .button)
            .matching(identifier: Constants.firstButtonID)
            .element
        XCTAssert(firstButton.exists)
        firstButton.tap()

        let secondButton = app
            .descendants(matching: .button)
            .matching(identifier: Constants.secondButtonID)
            .element
        XCTAssert(secondButton.exists)
        secondButton.tap()

        let thirdButton = app
            .descendants(matching: .button)
            .matching(identifier: Constants.thirdButtonID)
            .element
        XCTAssert(thirdButton.exists)
        thirdButton.tap()

        let moviesViewController = app.tables.matching(identifier: Constants.moviesViewControllerID)
        moviesViewController.element.swipeDown()
        moviesViewController.element.swipeUp()
        let moviesCell = moviesViewController.cells.element(
            matching: .cell,
            identifier: "\(Constants.moviesCell)\(Constants.numberOfCell)"
        )
        moviesCell.tap()
        app.swipeUp()
        app.swipeDown()
        app.navigationBars.buttons.element.tap()
        sleep(1)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [
                XCTClockMetric(),
                XCTCPUMetric(),
                XCTStorageMetric(),
                XCTMemoryMetric()
            ]) {
                XCUIApplication().launch()
            }
        }
    }
}
