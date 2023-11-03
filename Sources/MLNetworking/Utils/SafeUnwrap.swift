//
//  SafeUnwrap.swift
//  
//
//  Created by alaattib on 3.11.2023.
//

import Foundation

postfix operator ~

postfix func ~ (_ val: Int?) -> Int {
    return SafeUnwrap().safeUnwrap(val)
}

postfix func ~ (_ val: UInt?) -> UInt {
    return SafeUnwrap().safeUnwrap(val)
}

postfix func ~ (_ val: Float?) -> Float {
    return SafeUnwrap().safeUnwrap(val)
}

postfix func ~ (_ val: CGFloat?) -> CGFloat {
    return SafeUnwrap().safeUnwrap(val)
}

postfix func ~ (_ val: Double?) -> Double {
    return SafeUnwrap().safeUnwrap(val)
}

postfix func ~ (_ val: String?) -> String {
    return SafeUnwrap().safeUnwrap(val)
}

postfix func ~ (_ val: Substring?) -> String {
    return SafeUnwrap().safeUnwrap(val)
}

postfix func ~ (_ val: Bool?) -> Bool {
    return SafeUnwrap().safeUnwrap(val)
}

postfix func ~ (_ val: Date?) -> Date {
    return SafeUnwrap().safeUnwrap(val)
}

postfix func ~ <T>(_ val: [T]?) -> [T] {
    return SafeUnwrap().safeUnwrap(val)
}

postfix func ~ <T, U>(_ val: [T: U]?) -> [T: U] where T: Hashable {
    return SafeUnwrap().safeUnwrap(val)
}

class SafeUnwrap {
    func safeUnwrap(_ integer: Int?, defaultValue: Int = 0) -> Int {
        return integer ?? defaultValue
    }

    func safeUnwrap(_ integer: UInt?, defaultValue: UInt = 0) -> UInt {
        return integer ?? defaultValue
    }

    func safeUnwrap(_ float: Float?, defaultValue: Float = 0) -> Float {
        return float ?? defaultValue
    }

    func safeUnwrap(_ float: CGFloat?, defaultValue: CGFloat = 0) -> CGFloat {
        return float ?? defaultValue
    }

    func safeUnwrap(_ double: Double?, defaultValue: Double = 0) -> Double {
        return double ?? defaultValue
    }

    func safeUnwrap(_ string: String?, defaultValue: String = "") -> String {
        return string ?? defaultValue
    }

    func safeUnwrap(_ string: Substring?, defaultValue: Substring = "") -> String {
        return String(string ?? defaultValue)
    }

    func safeUnwrap(_ bool: Bool?, defaultValue: Bool = false) -> Bool {
        return bool ?? defaultValue
    }

    func safeUnwrap(_ date: Date?, defaultValue: Date = Date()) -> Date {
        return date ?? defaultValue
    }

    func safeUnwrap<T>(_ array: [T]?, defaultValue: [T] = [T]()) -> [T] {
        return array ?? defaultValue
    }

    func safeUnwrap<T, U>(_ dictionary: [T: U]?, defaultValue: [T: U] = [T: U]()) -> [T: U] where T: Hashable {
        return dictionary ?? defaultValue
    }
}
