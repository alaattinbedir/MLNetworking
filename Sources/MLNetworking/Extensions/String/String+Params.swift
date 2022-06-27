//
//  File.swift
//  
//
//  Created by Alaattin Bedir on 27.06.2022.
//

import Foundation

public extension String {

    func replaceParamsWithCurlyBrackets(_ params: String...) -> String {
        return replaceParamsWithCurlyBrackets(params)
    }

    func replaceParamsWithCurlyBrackets(_ params: [String]) -> String {
        var resourceStr = self
        guard resourceStr.count > 0 else { return resourceStr }
        guard resourceStr.contains("{"), resourceStr.contains("}") else { return resourceStr }

        var paramIndex = 0
        for param in params {
            let searchParamPattern = "{\(paramIndex)}"
            paramIndex += 1
            guard resourceStr.contains(searchParamPattern) else { continue }
            resourceStr = resourceStr.replacingOccurrences(of: searchParamPattern, with: param)
        }

        return resourceStr
    }
}

