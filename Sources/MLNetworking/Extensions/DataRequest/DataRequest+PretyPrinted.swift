//
//  DataRequest+PretyPrinted.swift
//  WeatherApp
//
//  Created by Alaattin Bedir on 19.06.2022.
//

import Foundation
import Alamofire

extension DataRequest {

    @discardableResult
    func prettyPrintedJsonResponse() -> Self {
        return responseJSON { (response) in
            switch response.result {
            case .success(let result):
                if let data = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted),
                    let text = String(data: data, encoding: .utf8) {
                    print("📗 prettyPrinted JSON response: \n \(text)")
                }
            case .failure: break
            }
        }
    }
}
