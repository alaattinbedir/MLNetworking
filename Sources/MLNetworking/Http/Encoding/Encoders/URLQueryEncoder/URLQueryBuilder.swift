//
//  URLQueryBuilder.swift
//  WeatherToday
//
//  Created by Alaattin Bedir on 15.06.2022.
//

import Foundation
public struct URLQueryBuilder {
    let params: RequestParameters

    public init(params: RequestParameters) {
        self.params = params
    }

    public func build() -> String {
        guard params.keys.count > 0 else { return "" }

        var query = ""
        query = params
            .compactMap { item in
                if let encodedParam = (item.value as? URLQueryValueRepresentable)?.urlQueryValue {
                    return "\(item.key)=\(encodedParam)"
                } else {
                    return "\(item.key)=\(item.value)"
                }
            }
            .joined(separator: "&")

        return "?\(query)"
    }
}
