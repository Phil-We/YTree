//
//  string_extensions.swift
//  cards_ios
//
//  Created by Phil Weckenmann on 3/8/22.
//

extension String {
    enum RegEx: String {
        case hex = #"(?:#|0x)(?:[a-f0-9]{3}|[a-f0-9]{6})\b|(?:rgb|hsl)a?\([^\)]*\)"#
    }
    
    func matchesRegex(regex: String) -> Bool {
        let result = self.range(of: "^\(regex)$", options: .regularExpression) != nil
        return result
    }
    func matchesRegex(regex: RegEx) -> Bool {
        let result = self.range(of: "^\(regex)$", options: .regularExpression) != nil
        return result
    }
}
