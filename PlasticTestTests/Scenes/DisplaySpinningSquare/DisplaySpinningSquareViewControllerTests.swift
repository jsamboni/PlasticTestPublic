//
//  DisplaySpinningSquareViewControllerTests.swift
//  PlasticTest
//
//  Created by Juan Carlos Samboni Ramirez on 3/6/19.
//  Copyright (c) 2019 Juan Carlos Samboni Ramirez. All rights reserved.
//


@testable import PlasticTest
import XCTest

class DisplaySpinningSquareViewControllerTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: DisplaySpinningSquareViewController!
    var window: UIWindow!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupDisplaySpinningSquareViewController()
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupDisplaySpinningSquareViewController() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: "DisplaySpinningSquareViewController") as? DisplaySpinningSquareViewController
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: Tests
    
    func test_FetchTime_WhenViewIsLoaded_IsCalled() {
        // Given
        let spy = DisplaySpinningSquareBusinessLogicSpy()
        sut.interactor = spy
        
        // When
        loadView()
        
        // Then
        XCTAssertTrue(spy.fetchTimeWasCalled)
    }
    
    func test_DisplayTime_WhenCalled_UpdatesTimeLabel() {
        // Given
        let expectedString = "Time"
        let viewModel = DisplaySpinningSquare.FetchTime.ViewModel(formattedTime: expectedString)
        
        // When
        loadView()
        sut.displayTime(viewModel: viewModel)
        
        // Then
        XCTAssertEqual(sut.timeLabel.text, expectedString)
    }
}

extension DisplaySpinningSquareViewControllerTests {
    // MARK: Spy
    
    class DisplaySpinningSquareBusinessLogicSpy: DisplaySpinningSquareBusinessLogic {
        var fetchTimeWasCalled = false
        
        func fetchTime() {
            fetchTimeWasCalled = true
        }
    }
}
