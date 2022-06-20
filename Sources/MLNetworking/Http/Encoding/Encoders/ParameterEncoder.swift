//
//  ParameterEncoder.swift
//  WeatherApp
//
//  Created by Alaattin Bedir on 17.06.2022.
//

import Foundation

public typealias RequestParameters = [String: Any]

public protocol ParameterEncoder {
    func encode(urlRequest: URLRequest, with parameters: RequestParameters?) throws -> URLRequest
}
