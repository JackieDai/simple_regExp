//
//  LXExpTest.swift
//  UnitTest
//
//  Created by lingxiao on 2024/1/6.
//

import XCTest

class LXExpTest: XCTestCase {
    
    private var config: RegExpConfig!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

extension LXExpTest {
    /*
     {"pattern":"\\[v_cc1:(.*) V\\]"}
     regExp == "\\[v_cc1:(.*) V\\]"
     
     
     这个正则表达式 `\\[v_cc1:(.*) V\\]` 用于匹配特定模式的字符串。让我们逐步解释这个正则表达式的各个部分：

     1. `\\[`：匹配一个左方括号 `[`。由于方括号在正则表达式中有特殊含义，因此需要使用双反斜杠 `\\` 来转义它。

     2. `v_cc1:`：匹配字面字符串 "v_cc1:"。

     3. `(.*)`：这是一个捕获组，用于捕获括号内的任意字符零次或多次。`.` 匹配除换行符以外的任何字符，`*` 表示匹配零次或多次。

     4. ` V`：匹配一个空格字符和大写字母 "V"。

     5. `\\]`：匹配一个右方括号 `]`，同样需要使用双反斜杠 `\\` 来转义。

     综合起来，这个正则表达式的整体含义是匹配形如 "[v_cc1:任意字符 V]" 的字符串，其中 "任意字符" 可以是任何字符，包括空格，但不能包含换行符。这样的字符串模式通常用于提取或匹配特定格式的文本数据。
     
     */
    
    func test_v_cc1() {
        let inputString = "Some text [v_cc1:Hello World V] more text [v_cc1:123456 V] end. 12134 V]  56789]"

        config = .init(
            pattern: "\\[v_cc1:(.*) V\\]",
            inputString: inputString
        )
        let r = ["[v_cc1:Hello World V] more text [v_cc1:123456 V] end. 12134 V]"]
        XCTAssertEqual(config.match_result_detail, r)
        
    }
    
    func test_power_4v() {
        /*
         这个正则表达式 power_4v = (.*)] 的含义是匹配字符串中以 power_4v = 开始，后面跟着任意字符（除换行符外）零次或多次，直到遇到字符串 ] 结束的部分。

         具体来说：

            power_4v = 匹配字面字符串 "power_4v ="。
            (.*) 使用括号捕获任意字符（除换行符外）零次或多次。
            ] 匹配字面字符串 "]"。
         
         以下是一个简单的 Swift 示例代码，使用正则表达式来匹配字符串模式 power_4v = (.*)]：
         */
        
        let pattern = "power_4v = (.*)]"
        let inputString = "Some text power_4v = [123, 456, 789] end."
        config = .init(
            pattern: pattern,
            inputString: inputString
        )
        let r = ["power_4v = [123, 456, 789]"]
        XCTAssertEqual(config.match_result_detail, r)

    }
}
