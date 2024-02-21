//
//  RegExp001.swift
//  UnitTest
//
//  Created by lingxiao on 2024/1/6.
//

import XCTest


class RegExp: XCTestCase {
    
    private var config: RegExpConfig!
}

//MARK: - #####  字符匹配 ################
//MARK: -- 匹配模式
extension RegExp {
    
    //MARK: - `横向匹配 {m,n}`    连续出现最少 m 次，最多 n 次
    func test001() {
        /**
         横向模糊指的是，一个正则可匹配的字符串的长度不是固定的，可以是多种情况的。
         其实现的方式是使用量词。譬如 {m,n}，表示连续出现最少 m 次，最多 n 次。
         比如正则 "ab{2,5}c" 表示匹配这样一个字符串:第一个字符是 "a"，接下来是 2 到 5 个字符 "b"，最后
         是字符 "c"
         */
        
        let config: RegExpConfig = .init(
            pattern: "ab{2,5}c",
            inputString: "abc abbc abbbc abbbbc abbbbbc abbbbbbc"
        )
        
        let result = ["abbc", "abbbc", "abbbbc", "abbbbbc"]
        XCTAssertEqual(config.match_result_detail, result)
    }
    
    //MARK: - `纵向模糊匹配`    [abc] ==  字符 "a"、"b"、"c" 中的任何一个
    func test002() {
        /*
         纵向模糊指的是，一个正则匹配的字符串，具体到某一位字符时，它可以不是某个确定的字符，可以有多种
         可能。
         其实现的方式是使用字符组。譬如 [abc]，表示该字符是可以字符 "a"、"b"、"c" 中的任何一个。
         比如 "a[123]b" 可以匹配如下三种字符串： "a1b"、"a2b"、"a3b"。
         */
        
        let config: RegExpConfig = .init(
            pattern: "a[123]b",
            inputString: "a0b a1b a2b a3b a4b"
        )
        let result = ["a1b", "a2b", "a3b"]
        XCTAssertEqual(config.match_result_detail, result)
    }
}


//MARK: -- 字符组
/**
 字符组
 字符组（字符类），但只是其中一个字符。
 例如 [abc]，表示匹配一个字符，它可以是 "a"、"b"、"c" 之一
 */
extension RegExp {

    // MARK: - `-` 范围表示法
    func test_zfu_001() {
        /**
         12345678900abcdefghijklmnopqistuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ
         匹配出上述字符串中 1-6， a-f, A-F  的字符
         */
        
        // let pattern = "[123456abcdefABCDEF]"  这种写法 太low, 可以通过 连字符“-” 来连接
        let pattern = "[1-6a-fA-F]"
        
        let config: RegExpConfig = .init(
            pattern: pattern,
            inputString: "12345678900abcdefghijklmnopqistuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        )
        
        let r = [
            "1","2","3","4","5","6",
            "a","b","c","d","e","f",
            "A","B","C","D","E","F"
        ]
        
//        XCTAssertTrue(config.can_match)
        XCTAssertEqual(config.match_result_detail, r)
    }
    func test_zfu_002() {
        /*
         那么要匹配 "a"、"-"、"z" 这三者中任意一个字符，该怎么做呢？
         不能写成 [a-z]，因为其表示小写字符中的任何一个字符。
         可以写成如下的方式：[-az] 或 [az-] 或 [a\-z]
         */
        let pattern = "[-za]"
        
        let inputString = "-12345678900abcdefghijklmnopqis-tuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        
        let result = ["-", "a", "-", "z"]
        let config: RegExpConfig = .init(pattern: pattern, inputString: inputString)
        XCTAssertEqual(config.match_result_detail, result)
        
    }

    //MARK: - `^` 脱字符
    /**
     纵向模糊匹配，还有一种情形就是，某位字符可以是任何东西，但就不能是 "a"、"b"、"c"。
     此时就是排除字符组（反义字符组）的概念。例如 [^abc]，表示是一个除 "a"、"b"、"c"之外的任意一个字
     符。字符组的第一位放 ^（脱字符），表示求反的概念
     
     在正则表达式中，`^` 符号有两个不同的用途，具体取决于它出现的位置：

     1. **在字符串的开始位置（脱字符）：** 当 `^` 出现在正则表达式的开头时，它表示匹配字符串的开始位置。例如，正则表达式 `^abc` 将匹配以 "abc" 开始的字符串。

        ```regex
        ^abc
        ```

        - 匹配："abc123", "abcdef", 等等。
        - 不匹配："123abc", "xyzabc", 等等。

     2. **在字符集([])内的位置：** 当 `^` 出现在字符集的开头时，它表示对字符集进行否定操作，即匹配除了列出的字符之外的任何字符。例如，正则表达式 `[^0-9]` 将匹配任何非数字字符。

        ```regex
        [^0-9]
        ```

        - 匹配："a", "X", "$", 等等。
        - 不匹配："1", "9", "0", 等等。

     总之，`^` 的含义取决于它在正则表达式中的位置。在开头表示字符串的开始，而在字符集内表示否定。
     */
    func test_zfu_003() {
        let pattern = "[^abcd]"
        let inputString = "1234abcdABCD"
        let config = RegExpConfig(pattern: pattern, inputString: inputString)
//        XCTAssertTrue(config.can_match)
        let r = [
            "1","2","3","4",
            "A","B","C","D"
        ]
        XCTAssertEqual(config.match_result_detail, r)
    }
    
    //MARK: - `\d`    == [0-9]
    func test_zfu_d() {
        let config: RegExpConfig = .init(
            pattern: "\\d",
            inputString: "1234abcdeABCD"
        )
        let result = ["1", "2", "3", "4"]
        XCTAssertEqual(config.match_result_detail, result)
    }
    //MARK: - `\D`    == `[^0-9]`
    
    func test_zfu_captial_D() {
        let pattern = "\\D"
        let inputString = "1234abcdeABCD"
        config = .init(pattern: pattern, inputString: inputString)
        
        XCTAssertTrue(config.can_match)
    }
    //MARK: - `\w`    == [0-9a-zA-Z_]     数字、大小写字母和下划线
    func test_zfu_w() {
        let pattern = "\\w"
        let inputString = "1234abcdeABCD_*&^sd"
        config = .init(pattern: pattern, inputString: inputString)
        XCTAssertTrue(config.can_match)
    }
    //MARK: - `\W`    == `[^0-9a-zA-Z_]`    不是 数字、大小写字母和下划线
    func test_zfu_captial_W() {
        
        config = .init(
            pattern: "\\W",
            inputString: "1234abcdeABCD_*&^sd"
        )
        
        let result = ["*", "&", "^"]
        XCTAssertEqual(config.match_result_detail, result)
    }
    
    //MARK: - `\s`    表示空白符
    func test_zfz_s() {
        /*
         \s: 表示 [ \t\v\n\r\f]。表示空白符，包括空格、水平制表符、垂直制表符、换行符、回车符、换页
         符
         */
        config = .init(
            pattern: "\\s",
            inputString: "_a _b\t_c\r_d\n_e" // a 后面有 空格
        )
        
        let result = [" ", "\t", "\r","\n"]
        XCTAssertEqual(config.match_result_detail, result)
    }
    
    //MARK: - `\S`    非空白符
    func test_zfz_captial_S() {
        config = .init(
            pattern: "\\S",
            inputString: "a b\tc\rd\ne"
        )
        let result = ["a", "b", "c","d","e"]
        XCTAssertEqual(config.match_result_detail, result)
    }
    
    //MARK: - `.`    通配符
    /*
     在正则表达式中，`.`（点号）表示匹配除换行符 `\n` 之外的任何单个字符。它是一个通配符，可以匹配任何字符，包括字母、数字、标点符号等。

     例如：

     - 正则表达式 `a.c` 可以匹配 "abc"、"adc"、"aec" 等字符串，因为 `.` 可以匹配任何字符。
     - 正则表达式 `..t` 可以匹配 "cat"、"bat"、"sat" 等字符串，因为 `.` 匹配任意字符，而 `t` 匹配字母 "t"。

     请注意，`.`并不匹配换行符 `\n`，如果你想要匹配任何字符，包括换行符，你可以使用 `[\s\S]` 这样的字符集，或者在一些正则表达式引擎中使用特殊标记，例如 `(?s)`。
     */
    func test_zfz_common() {
        config = .init(
            pattern: ".",
            inputString: "!@#$%^&*()e4\n"
        )
        
        let r = ["!","@","#","$","%","^","&","*","(",")","e","4","\n"]
        
        /*
         XCTAssertEqual failed: ("["!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "e", "4"]") is not equal to ("["!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "e", "4", "\n"]")
         
         由上可知， .  不匹配 换行符  \n
         */
        
//        XCTAssertTrue(config.match_result)
        XCTAssertEqual(config.match_result_detail, r)

    }
    
    
    /**
     如果要匹配任意字符怎么办？
        可以使用 [\d\D]、[\w\W]、[\s\S] 和 [^] 中任何的一个。
     */
}

//MARK: - 量词 ： Measure Count
extension RegExp {
    //MARK: - `{m,}`  至少连续出现 m 词
    func test_mn_001() {
        config = .init(
            pattern: "a{3,}[bcdf]", // [bcdf]  a后至少是中括号里的字符
            inputString: "aabcdaaabaaaacaaaaadaaaaaaaf"
        )
        let result = ["aaab","aaaac","aaaaad","aaaaaaaf"]
        XCTAssertEqual(config.match_result_detail, result)
    }
    
    //MARK: - `{m}`   连续出现 m 次
    func test_mn_002() {
        config = .init(
            pattern: "a{3}[bcdf]", // [bcdf]  a后至少是中括号里的字符
            inputString: "aabcdaaabaaaacaaaaadaaaaaaaf"
        )
        let result = ["aaab","aaac", "aaad","aaaf"]
        XCTAssertEqual(config.match_result_detail, result)
    }
    
    //MARK: - `?` == {0, 1} 连续出现次数 要么0 要么1
    func test_mn_003() {
        config = .init(
            pattern: "a?[bcdf]", // [bcdf]  a后至少是中括号里的字符
            inputString: "aabcdaaabaaaacaaaaadaaaaaaaf"
        )
        
        // 之所以还有 c d 因为 ？表示连续出现次数 要么0 要么1
        let result = ["ab","c","d", "ab","ac", "ad","af"]
        XCTAssertEqual(config.match_result_detail, result)
    }
    
    //MARK: - `+` == {1,} 至少连续出现 1 次
    func test_mn_004() {
        config = .init(
            pattern: "a+[bcdf]", // [bcdf]  a后至少是中括号里的字符
            inputString: "aabcdaaabaaaacaaaaadaaaaaaaf"
        )
        
        let result = ["aab", "aaab","aaaac", "aaaaad","aaaaaaaf"]
        XCTAssertEqual(config.match_result_detail, result)
    }
    
    //MARK: - * 等价于 {0,}，表示出现任意次，有可能不出现
    func test_mn_005() {
        config = .init(
            pattern: "a*[bcdf]", // [bcdf]  a后至少是中括号里的字符
            inputString: "aabcdaaabaaaacaaaaadaaaaaaaf"
        )
        
        let result = ["aab", "c", "d","aaab","aaaac", "aaaaad","aaaaaaaf"]
        XCTAssertEqual(config.match_result_detail, result)
    }
}

//MARK: - 贪婪匹配与惰性匹配
// 在量词后 添加 符号"?" 表示惰性匹配
extension RegExp {
    // MARK: - 贪婪匹配： 尽可能多的 匹配 出 满足条件的 要求
    func test_greedy_pattern() {
        config = .init(
            pattern: "\\d{2,5}", // 表示数字连续出现 2 到 5 次
            inputString: "123 1234 12345 123456"
        )
        let result = ["123", "1234", "12345", "12345"]
        XCTAssertEqual(config.match_result_detail, result)
    }
    
    //MARK: - 惰性匹配： 表示在量词后 添加 "?"
    
    func test_lazy_pattern() {
        config = .init(
            pattern: "\\d{2,5}?",
            inputString: "123 1234 12345 123456"
        )
        /**
         "\\d{2,5}?"  后面 添加了 一个 ？ 表示，虽然 2 到 5 次都行，当 2 个就够的时候，就不再往下尝试了
         */
        
        let result = ["12", "12","34","12","34", "12","34","56"]
        /**
         inputString: "123 1234 12345 123456"
         result[0] == "12" 表示 从 123 中匹配的    这里有一个连续的出现2次的数字
         result[1] == "12"，result[2] == "34"  表示 从 1234 中匹配的  这里面有两个 连续的出现2次的数字
         result[3] == "12"，result[4] == "34"  表示 从 12345 中匹配的   这里面有两个 连续的出现2次的数字
         result[5] == "12"，result[6] == "34" ，result[7] == "56"表示 从 12345 中匹配的   这里面有三个 连续的出现2次的数字
         */
        XCTAssertEqual(config.match_result_detail, result)
    }
}


//MARK: 多选分支
/*
 一个模式可以实现横向和纵向模糊匹配。而多选分支可以支持多个子模式任选其一。
 具体形式如下：(p1|p2|p3)，其中 p1、p2 和 p3 是子模式，用 |（管道符）分隔，表示其中任何之一。
 例如要匹配字符串 "good" 和 "nice" 可以使用 /good|nice/。
 
 
 “|”
 表示逻辑上的“或”关系。具体来说，| 用于在正则表达式中分隔两个模式，表示匹配其中任意一个模式即可
 
 */
extension RegExp {
    func test_multiple_branch() {
        config = .init(
            pattern: "good|nice",// 相当于 逻辑或
            inputString: "good idea, nice try."
        )
        let r = ["good","nice"]
        XCTAssertEqual(config.match_result_detail, r)
    }
    
    /*
     NOTE:
     应该注意，比如我用 /good|goodbye/，去匹配 "goodbye" 字符串时，结果是 "good"
     */
    func test_multiple_branch001() {
        config = .init(
            pattern: "good|goodbye",// 相当于 逻辑或
            inputString: "goodbye"
        )
        
        let r0 = ["good"]
//        let r1 = ["goodbye"] // 这个测试不通过，其匹配的结果是 good

        XCTAssertEqual(config.match_result_detail, r0)
//        XCTAssertEqual(config.match_result_detail, r1) // 这个测试项 不通过
    }
    
    /*
     NOTE:
     但如果 将 pattern 改成 /goodbye|good/ 时，结果会匹配成 goodbye。 由此可见，分支结构也是惰性的，前面的选项匹配成功就不会匹配后面的
     */
    func test_multiple_branch002() {
        config = .init(
            pattern: "goodbye|good",// 相当于 逻辑或
            inputString: "goodbye"
        )
        
        let r1 = ["goodbye"]

        XCTAssertEqual(config.match_result_detail, r1)
    }
}

// Practise One

extension RegExp {
    /*
     要求匹配 16 进制 颜色字符串
     #ffbbad
     #Fc01DF
     #FFF
     #ffE
     分析：
     表示一个 16 进制字符，可以用字符组 [0-9a-fA-F]。
     其中字符可以出现 3 或 6 次，需要是用量词和分支结构。
     使用分支结构时，需要注意顺序。

     #([0-9a-fA-F]{6}|[0-9a-fA-F]{3})
     -  # 表示 以#开头 的字符串
     -  [0-9a-fA-F] 表示数字和字母
     -  {6} 表示 [0-9a-fA-F] 连续出现6次
     -  | 表示分支结构 注意 分支结构式惰性的
     ...
     */
    func test_practise_hexColor() {
        config = .init(
            pattern: "#([0-9a-fA-F]{6}|[0-9a-fA-F]{3})",
            inputString: "#ffbbad #Fc01DF #FFF #ffE"
        )
        
        let r = ["#ffbbad", "#Fc01DF", "#FFF", "#ffE"]
        XCTAssertEqual(config.match_result_detail, r)
    }
    
    /*
     以 24 小时制为例。
     要求匹配：
     23:59
     02:07
     分析：
     共 4 位数字，第一位数字可以为 [0-2]。
     当第 1 位为 "2" 时，第 2 位可以为 [0-3]，其他情况时，第 2 位为 [0-9]。
     第 3 位数字为 [0-5]，第4位为 [0-9]。
     正则如下：
     regex = ^([01][0-9]|[2][0-3]):[0-5][0-9]$
     
        NOTE:
            ^ 表示字符串开头
            $ 表示字符串结尾

     */
    
    func test_practise_timer01() {
        let pattern = "^([01][0-9]|[2][0-3]):[0-5][0-9]$"
        config = .init(
            pattern: pattern,
            inputString: "23:59"
        )
        
        let r0 = ["23:59"]
        XCTAssertEqual(config.match_result_detail, r0)
        
        config = .init(
            pattern: pattern,
            inputString: "02:09"
        )
        let r1 = ["02:09"]
        XCTAssertEqual(config.match_result_detail, r1)
    }
    
    /*
     如果也要求匹配 "7:9"，也就是说时分前面的 "0" 可以省略
     此时 正则 如下
     ^(0?[0-9]|1[0-9]|[2][0-3]):(0?[0-9]|[1-5][0-9])$
     */
    func test_practise_timer02() {
        let pattern = "^(0?[0-9]|1[0-9]|[2][0-3]):(0?[0-9]|[1-5][0-9])$"
        config = .init(
            pattern: pattern,
            inputString: "23:59"
        )
        
        let r0 = ["23:59"]
        XCTAssertEqual(config.match_result_detail, r0)
        
        config = .init(
            pattern: pattern,
            inputString: "02:09"
        )
        let r1 = ["02:09"]
        XCTAssertEqual(config.match_result_detail, r1)
        
        config = .init(
            pattern: pattern,
            inputString: "2:9"
        )
        let r2 = ["2:9"]
        XCTAssertEqual(config.match_result_detail, r2)
    }
    
    
    /*
     比如 yyyy-mm-dd 格式为例。
     要求匹配：
     2017-06-10
     分析：
        年，四位数字即可，可用 [0-9]{4}。
        月，共 12 个月，分两种情况 "01"、"02"、...、"09" 和 "10"、"11"、"12"，可用 (0[1-9]|1[0-2])。
        日，最大 31 天，可用 (0[1-9]|[12][0-9]|3[01])。
     
     正则如下：
        regex = ^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$
     */
    func test_practise_date() {
        let pattern = "^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$"
        config = .init(
            pattern: pattern,
            inputString: "2024-01-06"
        )
        
        XCTAssertTrue(config.can_match)
    }
    
}


//MARK: - ###### 位置匹配
/*
 理解位置：
    
    对于位置的理解，我们可以理解成空字符 "",每一个 空字符串"" 就表示位置
    hello = ""+"h"+""+"e"+""+"l"+""+"l"+""+"o"+""
 */
extension RegExp {
    
    //MARK: - `^`, `$`
    /*
     `^`: 匹配开头
     `$`: 匹配结尾
     */
    
    func test_begin_end_sign() {
        let inputString = "hello"
        let pattern = "(^|$)" // 要么开头，要么结尾
        let replaceStr = "#"
        
        config = .init(pattern: pattern, inputString: inputString, replaceStr: replaceStr)
        let r = "#hello#"
        XCTAssertEqual(config.modify_result, r)
    }

    
   //MARK: - `\b`,`\B`
    /*
     在正则表达式中，\b 和 \B 是用于表示单词边界（Word Boundary）的元字符，它们有如下的含义：

    
     \b 是单词边界，具体就是 \w 与 \W 之间的位置，也包括 \w 与 ^ 之间的位置，和 \w 与 $ 之间的位置

     \B（非单词边界）： 与 \b 相反，\B 表示匹配不是单词边界的位置。它同样是一个零宽断言，不消耗匹配字符。

     */
    func test_word_boundary_b() {
        let inputString = "[Swift] Les@$son_01.txt"
        let pattern = "\\b"
        let replaceStr = "#"
        
        config = .init(pattern: pattern, inputString: inputString, replaceStr: replaceStr)
        let r = "[#Swift#] #Les#@$#son_01#.#txt#"
        
        /*
         去理解 单词边界的意思    Swift   Les    son_01   txt 都是单词
         */
        
        XCTAssertEqual(config.modify_result, r)
    }
    
    func test_word_boundary_B() {
        let inputString = "[Swift] Lesson_01.txt"
        let pattern = "\\B"
        let replaceStr = "#"
        
        
        config = .init(pattern: pattern, inputString: inputString, replaceStr: replaceStr)
        
        /*
         理解非单词边界，  跟 单词边界 正相反 ，参考上面的案例
         */
        let r = "#[S#w#i#f#t]# L#e#s#s#o#n#_#0#1.t#x#t"
        
        XCTAssertEqual(config.modify_result, r)
    }
    

    //MARK: - `(?=...)` 和 `(?!=...)`
    /*
     (?=...)： 正向先行断言，表示模式只有在某个位置之前的位置匹配时才匹配。例如，foo(?=bar) 匹配 "foo"，但仅当其后面是 "bar" 时才匹配。
     
     (?!...)： 负向先行断言，表示模式只有在某个位置之前的位置不匹配时才匹配。例如，foo(?!bar) 匹配 "foo"，但仅当其后面不是 "bar" 时才匹配。
     */
    
    func test_postive_pattern() {
        let inputString = "hello"
        let pattern = "(?=l)" // 当前位置后 是 l 的 位置
        let replaceStr = "#"
        
        config = .init(pattern: pattern, inputString: inputString, replaceStr: replaceStr)
        
        let r = "he#l#lo"
        
        XCTAssertEqual(config.modify_result, r)
    }
    
    func test_negative_pattern() {
        let inputString = "hello"
        let pattern = "(?!l)"
        let replaceStr = "#"
        
        config = .init(pattern: pattern, inputString: inputString, replaceStr: replaceStr)
        
        let r = "#h#ell#o#" //当前位置后 不是是 l 的 位置
        
        XCTAssertEqual(config.modify_result, r)
    }
    
    /*
     ? 在正则表达式中的作用
     
     在正则表达式中，`?` 具有多种用法，取决于它出现的位置和上下文。以下是主要的用法：

     1. **零次或一次匹配：** 在一个字符、字符集、子表达式或分组后面使用 `?`，表示该元素是可选的，即出现零次或一次。例如，正则表达式 `colou?r` 可以匹配 "color" 或 "colour"。

         ```regex
         colou?r
         ```

         - 匹配："color", "colour"
         - 不匹配："colouur", "colr"

     2. **非贪婪匹配：** 在量词（如 `*` 或 `+`）后面使用 `?`，表示匹配尽量少的字符。默认情况下，量词是贪婪的，会尽量匹配更多的字符。通过在量词后面添加 `?`，可以实现非贪婪匹配。

         ```regex
         .*?  // 匹配任意字符，但尽量匹配最少字符
         ```

     3. **正向先行断言：** 在一个位置之前使用 `(?=...)`，表示模式只有在该位置之前的位置匹配时才匹配。例如，`foo(?=bar)` 匹配 "foo"，但仅当其后面是 "bar" 时才匹配。

         ```regex
         foo(?=bar)
         ```

         - 匹配："foobar", "foo123bar"
         - 不匹配："foo", "bar"

     4. **负向先行断言：** 在一个位置之前使用 `(?!...)`，表示模式只有在该位置之前的位置不匹配时才匹配。例如，`foo(?!bar)` 匹配 "foo"，但仅当其后面不是 "bar" 时才匹配。

         ```regex
         foo(?!bar)
         ```

         - 匹配："foo", "foobaz"
         - 不匹配："foobar", "foo123bar"

     这些是 `?` 在正则表达式中的一些常见用法。根据具体的需求和上下文，你可以选择适当的用法。
     */
    
    // Practise
    func test_sep_thousand() {
        //把 "12345678"，变成 "12,345,678
        
        // 1. 分析 先把 12345678 ==》12345,678
        var inputStr = "12345678"
        var pattern = "(?=\\d{3}$)"
        let replace = ","
        config = .init(pattern: pattern, inputString: inputStr, replaceStr: replace)
        var r = "12345,678"
        XCTAssertEqual(config.modify_result, r, "not equal")
        
        
        // 2. 再把 12345678 ==》12,345,678
        
        pattern = "(?=(\\d{3})+$)"
        config = .init(pattern: pattern, inputString: inputStr, replaceStr: replace)
        r = "12,345,678"
        XCTAssertEqual(config.modify_result, r, "not equal")
        
        // 3. test regExp
        inputStr = "123456789"
        config = .init(pattern: pattern, inputString: inputStr, replaceStr: replace)
        r = "123,456,789"
        /*
         config.modify_result == ",123,456,789" 这就有问题, 所以下面的 unit test fail
         */
        //XCTAssertEqual(config.modify_result, r, "not equal")
        
        // 4. 修正
        /*
         匹配开头可以使用 ^，但要求这个位置不是开头可以使用(?!^)
         */
        pattern = "(?!^)(?=(\\d{3})+$)"
        config = .init(pattern: pattern, inputString: inputStr, replaceStr: replace)
        XCTAssertEqual(config.modify_result, r, "not equal")
        
        // 5. 在次测试
        inputStr = "12345678"
        config = .init(pattern: pattern, inputString: inputStr, replaceStr: replace)
        r = "12,345,678"
        XCTAssertEqual(config.modify_result, r, "not equal")
        
    }
}




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
            /*
             Returns a new string containing matching regular expressions replaced with the template string.
             */
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
            
            /*
             Returns an array containing all the matches of the regular expression in the string.
             */
            
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
            /*
             Returns the first match of the regular expression within the specified range of the string.
             */
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
