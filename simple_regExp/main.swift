//
//  main.swift
//  simple_regExp
//
//  Created by lingxiao on 2024/1/8.
//

import Foundation

/*
 Match 和 Group
 一下三个 pattern 分别测试。
 */

let inputString = "Date: 2022-02-21"
let pattern = "Date: (\\d{4}-\\d{2}-\\d{2})"
//let pattern = "Date: \\d{4}-\\d{2}-\\d{2}"
//let pattern = "Date: (\\d{4})-(\\d{2})-(\\d{2})"

do {
    let regex = try NSRegularExpression(pattern: pattern, options: [])
    if let match = regex.firstMatch(in: inputString, options: [], range: NSRange(location: 0, length: inputString.utf16.count)) {
        
        // 获取整个匹配
        let fullMatch = (inputString as NSString).substring(with: match.range)
        print("Full match: \(fullMatch)")
        
        // 获取捕获组的数量
        let numberOfGroups = match.numberOfRanges
        
        // 获取第一个捕获组
        if numberOfGroups > 1 {
            
            for index in 0..<numberOfGroups {
                let rangeOfFirstGroup = match.range(at: index)
                let group = (inputString as NSString).substring(with: rangeOfFirstGroup)
                print("Group \(index): \(group)")
            }
            
            
//            let rangeOfFirstGroup0 = match.range(at: 0)
//            let group0 = (inputString as NSString).substring(with: rangeOfFirstGroup0)
//            print("Group 0: \(group0)")
//
//
//            let rangeOfFirstGroup = match.range(at: 1)
//            let group1 = (inputString as NSString).substring(with: rangeOfFirstGroup)
//            print("Group 1: \(group1)")
        } else {
            print("No capture groups in the pattern.")
        }
        
    } else {
        print("No match found.")
    }
} catch {
    print("Error creating regex: \(error)")
}
