//
//  DisplaySpinningSquarePresenterTests.swift
//  PlasticTest
//
//  Created by Juan Carlos Samboni Ramirez on 3/6/19.
//  Copyright (c) 2019 Juan Carlos Samboni Ramirez. All rights reserved.
//


@testable import PlasticTest
import XCTest

class DisplaySpinningSquarePresenterTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: DisplaySpinningSquarePresenter!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupDisplaySpinningSquarePresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupDisplaySpinningSquarePresenter() {
        sut = DisplaySpinningSquarePresenter()
    }
    
    // MARK: Tests
    
    func test_PresentTime_WhenExecuted_CallsDisplayTime() {
        // Given
        let spy = DisplaySpinningSquareDisplayLogicSpy()
        sut.viewController = spy
        let response = DisplaySpinningSquare.FetchTime.Response(rawTime: "")
        
        // When
        sut.presentTime(response: response)
        
        // Then
        XCTAssertTrue(spy.displayTimeWasCalled)
    }
    
    func test_PresentTime_WhenGivenAnExpectedTimeString_ItIsFormatted() {
        // Given
        let rawTime = "2019-03-07 02:25:57.644421"
        let expectedFormattedTime = "02:25:57"
        let spy = DisplaySpinningSquareDisplayLogicSpy()
        sut.viewController = spy
        let response = DisplaySpinningSquare.FetchTime.Response(rawTime: rawTime)
        
        // When
        sut.presentTime(response: response)
        
        // Then
        XCTAssertEqual(spy.formattedTime, expectedFormattedTime)
    }
}

extension DisplaySpinningSquarePresenterTests {
    // MARK: Spy
    
    class DisplaySpinningSquareDisplayLogicSpy: DisplaySpinningSquareDisplayLogic {
        var displayTimeWasCalled = false
        var formattedTime = ""
        
        func displayTime(viewModel: DisplaySpinningSquare.FetchTime.ViewModel) {
            displayTimeWasCalled = true
            formattedTime = viewModel.formattedTime
        }
    }
}
