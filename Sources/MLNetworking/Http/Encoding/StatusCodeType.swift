//
//  StatusCodeType.swift
//  WeatherApp
//
//  Created by Alaattin Bedir on 17.06.2022.
//

import Foundation

enum StatusCodeType: Int {
    case successStatus
    case warningStatus
    case errorStatus
    case unknownStatus
}

extension StatusCodeType {
    static func toStatusType(httpStatusCode: Int?) -> StatusCodeType {
        guard let httpStatusCode = httpStatusCode else {
            return .unknownStatus
        }

        switch httpStatusCode {
        case 428:
            return .successStatus
        case 200 ..< 300:
            return .successStatus
        case 300 ..< 400:
            return .warningStatus
        case 400 ..< 600:
            return .errorStatus
        default:
            return .unknownStatus
        }
    }
}
