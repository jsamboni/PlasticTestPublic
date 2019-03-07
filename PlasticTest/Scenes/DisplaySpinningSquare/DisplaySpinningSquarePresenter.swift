//
//  DisplaySpinningSquarePresenter.swift
//  PlasticTest
//
//  Created by Juan Carlos Samboni Ramirez on 3/6/19.
//  Copyright (c) 2019 Juan Carlos Samboni Ramirez. All rights reserved.
//

import UIKit

protocol DisplaySpinningSquarePresentationLogic {
    func presentTime(response: DisplaySpinningSquare.FetchTime.Response)
}

class DisplaySpinningSquarePresenter: DisplaySpinningSquarePresentationLogic {
    weak var viewController: DisplaySpinningSquareDisplayLogic?
    
    private let expectedDateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
    private let presetingDateFormat = "HH:mm:ss"
    
    // MARK: Present Time
    
    func presentTime(response: DisplaySpinningSquare.FetchTime.Response) {
        let formattedTimeString = format(timeString: response.rawTime)
        let viewModel = DisplaySpinningSquare.FetchTime.ViewModel(formattedTime: formattedTimeString)
        viewController?.displayTime(viewModel: viewModel)
    }
}

private extension DisplaySpinningSquarePresenter {
    func format(timeString: String) -> String {
        let formater = DateFormatter()
        formater.dateFormat = expectedDateFormat
        guard let date = formater.date(from: timeString) else {
            return ""
        }
        
        let printFormatter = DateFormatter()
        printFormatter.dateFormat = presetingDateFormat
        return printFormatter.string(from: date)
    }
}
