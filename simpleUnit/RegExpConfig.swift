//
//  RegExpConfig.swift
//  UnitTest
//
//  Created by lingxiao on 2024/1/6.
//

import Foundation



struct RegExpConfig {
    let pattern: String
    let inputString: String
    var replaceStr: String!
}

extension RegExpConfig {
    var match_result: Bool {
        checkPattern_(pattern: pattern, inputString: inputString).0
    }
    
    var match_result_detail: Array<String> {
        checkPattern_(pattern: pattern, inputString: inputString).1
    }
    
    var can_match: Bool {
        canMatch_(pattern: pattern, inputString: inputString)
    }
    
    var modify_result: String {
        modifyStr_(pattern: pattern, inputString: inputString, replaceStr: replaceStr)
    }
    
}

extension RegExpConfig {
    
    private func modifyStr_(pattern: String, inputString: String, replaceStr: String) -> String {

        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(location: 0, length: inputString.utf16.count)
            
            let modifiedString = regex.stringByReplacingMatches(in: inputString, options: [], range: range, withTemplate: replaceStr)
            
            lxprint(modifiedString)
            return modifiedString
        } catch {
            return ""
        }
    }
    
    
    private func checkPattern_(pattern: String, inputString: String) -> (Bool, Array<String>) {
        var flag = false
        
        var result: Array<String> = .init()
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(location: 0, length: inputString.utf16.count)
            let matches = regex.matches(in: inputString, options: [], range: range)

            for match in matches {
                
                let matchRange = match.range
                if let swiftRange = Range(matchRange, in: inputString) {
                    let matchedSubstring = String(inputString[swiftRange])
                    flag = true
                    result.append(matchedSubstring)
                    lxprint(matchedSubstring)
                }
            }
        } catch {
            flag = false
            lxprint("Error creating regular expression: \(error)")
        }
        return (flag, result)
    }
    
    
    private func canMatch_(pattern: String, inputString: String) -> Bool {
        var flag = false
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(location: 0, length: inputString.utf16.count)
            let isMatch = regex.firstMatch(in: inputString, options: [], range: range) != nil
            flag = isMatch
        } catch {
            flag = false
            lxprint("Error creating regular expression: \(error)")
        }
        
        return flag
    }
    
    private func lxprint(_ msg: Any) {
        print("😁😁😁==\(msg)")
    }
    
    
    
}
