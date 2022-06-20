//
//  URLQueryValueRepresentable.swift
//  WeatherToday
//
//  Created by Alaattin Bedir on 7.06.2022.
//

import Foundation

public protocol URLQueryValueRepresentable {
    var urlQueryValue: String? { get }
}
