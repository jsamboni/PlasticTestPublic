//
//  DisplaySpinningSquareInteractor.swift
//  PlasticTest
//
//  Created by Juan Carlos Samboni Ramirez on 3/6/19.
//  Copyright (c) 2019 Juan Carlos Samboni Ramirez. All rights reserved.
//

import UIKit

protocol DisplaySpinningSquareBusinessLogic {
    func fetchTime()
}

class DisplaySpinningSquareInteractor: DisplaySpinningSquareBusinessLogic {
    var presenter: DisplaySpinningSquarePresentationLogic?
    var worker: DisplaySpinningSquareWorker = DisplaySpinningSquareWorker(service: NetworkService())
    
    private var fetchTimer = DispatchSource.makeTimerSource()
    
    // MARK: fetchTime
    
    func fetchTime() {
        fetchTimer.schedule(deadline: .now(), repeating: .milliseconds(100))
        fetchTimer.setEventHandler(handler: { [weak self] in
            self?.worker.fetchTime(completionHandler: { [weak self] (rawTime) in
                let response = DisplaySpinningSquare.FetchTime.Response(rawTime: rawTime ?? "")
                self?.presenter?.presentTime(response: response)
            })
        })
        fetchTimer.resume()
    }
    
    deinit {
        fetchTimer.setEventHandler {}
        fetchTimer.cancel()
        fetchTimer.resume()
    }
}
