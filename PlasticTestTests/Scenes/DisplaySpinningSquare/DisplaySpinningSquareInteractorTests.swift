//
//  DisplaySpinningSquareInteractorTests.swift
//  PlasticTest
//
//  Created by Juan Carlos Samboni Ramirez on 3/6/19.
//  Copyright (c) 2019 Juan Carlos Samboni Ramirez. All rights reserved.
//

@testable import PlasticTest
import XCTest

class DisplaySpinningSquareInteractorTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: DisplaySpinningSquareInteractor!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupDisplaySpinningSquareInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupDisplaySpinningSquareInteractor() {
        sut = DisplaySpinningSquareInteractor()
    }
    
    // MARK: Tests
    
    func test_FetchTime_WhenExecuted_CallsWorkerFetchTimeAndPresentTime() {
        // Given
        let presentSpy = DisplaySpinningSquarePresentationLogicSpy()
        sut.presenter = presentSpy
        let workerSpy = DisplaySpinningSquareWorkerSpy(service: ServiceMock())
        sut.worker = workerSpy
        
        // When
        sut.fetchTime()
        
        // Then
        XCTAssertTrue(workerSpy.fetchTimeWasCalled)
        XCTAssertTrue(presentSpy.presentTimeWasCalled)
    }
}

extension DisplaySpinningSquareInteractorTests {
    // MARK: Spy
    
    class DisplaySpinningSquarePresentationLogicSpy: DisplaySpinningSquarePresentationLogic {
        var presentTimeWasCalled = false
        
        func presentTime(response: DisplaySpinningSquare.FetchTime.Response) {
            presentTimeWasCalled = true
        }
    }
    
    class DisplaySpinningSquareWorkerSpy: DisplaySpinningSquareWorker {
        var fetchTimeWasCalled = false
        
        override func fetchTime(completionHandler: @escaping (String?) -> Void) {
            fetchTimeWasCalled = true
            completionHandler(nil)
        }
    }
    
    // MARK: Mock
    
    class ServiceMock: ServiceProtocol {
        func fetchTime(completionHandler: @escaping (String?, Error?) -> Void) {
            completionHandler("true", nil)
        }
    }
}
