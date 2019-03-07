//
//  DisplaySpinningSquareWorker.swift
//  PlasticTest
//
//  Created by Juan Carlos Samboni Ramirez on 3/6/19.
//  Copyright (c) 2019 Juan Carlos Samboni Ramirez. All rights reserved.
//

import UIKit

protocol ServiceProtocol {
    func fetchTime(completionHandler: @escaping (String?, Error?) -> Void)
}

class DisplaySpinningSquareWorker {
    var service: ServiceProtocol
    
    init(service: ServiceProtocol) {
        self.service = service
    }
    
    func fetchTime(completionHandler: @escaping (String?) -> Void) {
        service.fetchTime { (response, error) in
            DispatchQueue.main.async {
                completionHandler(response)
            }
        }
    }
}

