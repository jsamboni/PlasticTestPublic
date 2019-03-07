//
//  DisplaySpinningSquareWorkerTests.swift
//  PlasticTest
//
//  Created by Juan Carlos Samboni Ramirez on 3/6/19.
//  Copyright (c) 2019 Juan Carlos Samboni Ramirez. All rights reserved.
//

@testable import PlasticTest
import XCTest

class DisplaySpinningSquareWorkerTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: DisplaySpinningSquareWorker!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupDisplaySpinningSquareWorker()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupDisplaySpinningSquareWorker() {
        sut = DisplaySpinningSquareWorker(service: ServiceMock())
    }
    
    // MARK: Tests
    
    func test_FetchTime_WhenCalled_ResponseIsNotNil() {
        // Given
        let fetchExpectation = expectation(description: "fetch")
        
        // When
        var rawTime: String?
        sut.fetchTime { (response) in
            fetchExpectation.fulfill()
            rawTime = response
        }
        
        waitForExpectations(timeout: 0.5)
        
        // Then
        XCTAssertNotNil(rawTime)
    }
}

extension DisplaySpinningSquareWorkerTests {
    // MARK: Mock
    
    class ServiceMock: ServiceProtocol {
        func fetchTime(completionHandler: @escaping (String?, Error?) -> Void) {
            completionHandler("true", nil)
        }
    }
}
