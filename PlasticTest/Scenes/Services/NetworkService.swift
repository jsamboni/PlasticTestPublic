//
//  NetworkService.swift
//  PlasticTest
//
//  Created by Juan Carlos Samboni Ramirez on 3/6/19.
//  Copyright © 2019 Juan Carlos Samboni Ramirez. All rights reserved.
//

import Foundation

final class NetworkService: ServiceProtocol {
    static let timeURL = "https://dateandtimeasjson.appspot.com/"
    
    struct TimeJSON: Decodable {
        var datetime: String
    }
    
    func fetchTime(completionHandler: @escaping (String?, Error?) -> Void) {
        guard let url = URL(string: NetworkService.timeURL) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    completionHandler(nil, error)
                    return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let container = try jsonDecoder.decode(TimeJSON.self, from: dataResponse)
                completionHandler(container.datetime, nil)
            } catch let decodeError {
                completionHandler(nil, decodeError)
            }
        }
        task.resume()
    }
}
