# simple_regExp
[文章参考链接](https://github.com/qdlaoyao/js-regex-mini-book)

## 匹配模式

###  横向匹配 `{m,n}`  连续出现最少 m 次，最多 n 次

>  横向模糊指的是，一个正则可匹配的字符串的长度不是固定的，可以是多种情况的。
>
>  其实现的方式是使用量词。譬如 {m,n}，表示**连续出现**最少 m 次，最多 n 次。
>
>  比如正则 "ab{2,5}c" 表示匹配这样一个字符串:第一个字符是 "a"，接下来是 2 到 5 个字符 "b"，最后是字符 "c"

```swift
let config: RegExpConfig = .init(
    pattern: "ab{2,5}c",
    inputString: "abc abbc abbbc abbbbc abbbbbc abbbbbbc"
)

let result = ["abbc", "abbbc", "abbbbc", "abbbbbc"]
XCTAssertEqual(config.match_result_detail, result)
```

### 纵向匹配 `[abc]` == 字符 "a"、"b"、"c" 中的任何一个

> 纵向模糊指的是，一个正则匹配的字符串，具体到某一位字符时，它可以不是某个确定的字符，可以有多种可能。
>
> 其实现的方式是使用字符组。譬如 [abc]，表示该字符是可以字符 "a"、"b"、"c" 中的任何一个。比如 "a[123]b" 可以匹配如下三种字符串： "a1b"、"a2b"、"a3b"。

```swift
let config: RegExpConfig = .init(
    pattern: "a[123]b",
    inputString: "a0b a1b a2b a3b a4b"
)
let result = ["a1b", "a2b", "a3b"]
XCTAssertEqual(config.match_result_detail, result)
```

## 字符组

> 字符组（字符类），但只是其中一个字符。
>
> 例如 [abc]，表示匹配一个字符，它可以是 "a"、"b"、"c" 之一

### `-` 范围表示法

> "12345678900abcdefghijklmnopqistuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
>
>  匹配出上述字符串中 1-6， a-f, A-F 的字符

```swift
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
```

那么要匹配 "a"、"-"、"z" 这三者中任意一个字符，该怎么做呢？

不能写成 [a-z]，因为其表示小写字符中的任何一个字符。 可以写成如下的方式：[-az] 或 [az-] 或 [a\-z]

```swift
let pattern = "[-za]"

let inputString = "-12345678900abcdefghijklmnopqis-tuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

let result = ["-", "a", "-", "z"]
let config: RegExpConfig = .init(pattern: pattern, inputString: inputString)
XCTAssertEqual(config.match_result_detail, result)
```

### `^` 脱字符

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

```swift
let pattern = "[^abcd]"
let inputString = "1234abcdABCD"
let config = RegExpConfig(pattern: pattern, inputString: inputString)
//        XCTAssertTrue(config.can_match)
let r = [
    "1","2","3","4",
    "A","B","C","D"
]
XCTAssertEqual(config.match_result_detail, r)
```

### `\d`  == `[0-9]`

### `\D`  == `[^0-9]`

### `\w`  == [0-9a-zA-Z_]   数字、大小写字母和下划线

### `\W`  == `[^0-9a-zA-Z_]`  不是 数字、大小写字母和下划线

### `\s`  表示空白符

### `\S`  非空白符

### `.`  通配符

> 在正则表达式中，`.` <u>是一个特殊的元字符，表示匹配除换行符 `\n` 之外的任意单个字符</u>。它是一个通配符，可以用来匹配任何字符，包括字母、数字、标点符号等。
>
> 下面是一些关于`.`的用法示例：
>
> 1. **匹配任意字符：**
>    ```regex
>    a.b
>    ```
>    - 匹配："aab", "abb", "acb", "a1b", 等等。
>    - 不匹配："abc", "a\nb", 等等。
>
> 2. **使用`.`匹配特定数量的字符：**
>    ```regex
>    ..t
>    ```
>    - 匹配："cat", "bat", "$$t", 等等。
>    - 不匹配："at", "t", 等等。
>
> 3. **非贪婪匹配：**
>    ```regex
>    .*?
>    ```
>    这个例子中，`*` 是一个量词，表示匹配前面的字符零次或更多次，而 `?` 是用来实现非贪婪匹配的，表示匹配尽量少的字符。
>
> 4. **匹配任意字符，包括换行符：**
>    在一些正则表达式引擎中，可以使用 `.` 加上相关标记（例如 `(?s)`）来匹配包括换行符在内的任意字符。
>
> 这些都是关于`.`在正则表达式中的一些基本用法。在实际使用时，要根据具体的需求选择合适的模式。
>
> ```swift
> config = .init(
>     pattern: ".",
>     inputString: "!@#$%^&*()e4\n"
> )
> 
> let r = ["!","@","#","$","%","^","&","*","(",")","e","4","\n"]
> 
> /*
>  XCTAssertEqual failed: ("["!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "e", "4"]") is not equal to ("["!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "e", "4", "\n"]")
> 
>  由上可知， .  不匹配 换行符  \n
>  */
> 
> //        XCTAssertTrue(config.match_result)
> XCTAssertEqual(config.match_result_detail, r)
> ```

## 量词 ： Measure Count

### `{m,}` 至少连续出现 `m` 词

### `{m}`  连续出现` m` 次

### `?` == `{0, 1}` 连续出现次数 要么0 要么1

### `+` == `{1,}` 至少连续出现 1 次

### `*`等价于 `{0,}`，表示出现任意次，有可能不出现

## 贪婪匹配与惰性匹配

### 贪婪匹配： 尽可能多的 匹配 出 满足条件的 要求

如下案例

```swift
config = .init(
    pattern: "\\d{2,5}", // 表示数字连续出现 2 到 5 次
    inputString: "123 1234 12345 123456"
)
let result = ["123", "1234", "12345", "12345"]
XCTAssertEqual(config.match_result_detail, result)
```

### 惰性匹配： 表示在量词后 添加 "?"

如下案例

```swift
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
```

## `|`多选分支 == 逻辑或

>  一个模式可以实现横向和纵向模糊匹配。而多选分支可以支持多个子模式任选其一。
>
>  具体形式如下：(p1|p2|p3)，其中 p1、p2 和 p3 是子模式，用 |（管道符）分隔，表示其中任何之一。
>
> **`|`**表示逻辑上的“或”关系。具体来说，| 用于在正则表达式中分隔两个模式，表示匹配其中任意一个模式即可
>
> 分支结构也是惰性的，前面的选项匹配成功就不会匹配后面的

```swift
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

func test_multiple_branch002() {
    config = .init(
        pattern: "goodbye|good",// 相当于 逻辑或
        inputString: "goodbye"
    )

    let r1 = ["goodbye"]

    XCTAssertEqual(config.match_result_detail, r1)
}
```

## 位置匹配

> 理解位置:
>
> ​	对于位置的理解，我们可以理解成空字符 "",每一个 空字符串"" 就表示位置
>
> ​	hello = `""`+`"h"`+`""`+`"e"`+`""`+`"l"`+`""`+`"l"`+`""`+`"o"`+`""`

### `^`, `$`

- `^` 开始位置
- `$ ` 结束位置

```swift
let inputString = "hello"
let pattern = "(^|$)" // 要么开头，要么结尾
let replaceStr = "#"

config = .init(pattern: pattern, inputString: inputString, replaceStr: replaceStr)
let r = "#hello#"
XCTAssertEqual(config.modify_result, r)
```

### `\b`,`\B`

> 在正则表达式中，\b 和 \B 是用于表示单词边界（Word Boundary）的元字符，
>
> 它们有如下的含义：
>
> - `\b` 是单词边界，具体就是 `\w` 与` \W` 之间的位置，也包括 `\w` 与 `^` 之间的位置，和` \w `与 `$ `之间的位置 
> - `\B`（非单词边界）： 与 `\b` 相反，`\B` 表示匹配不是单词边界的位置。它同样是一个零宽断言，不消耗匹配字符。

```swift
let inputString = "[Swift] Les@$son_01.txt"
let pattern = "\\b"
let replaceStr = "#"

config = .init(pattern: pattern, inputString: inputString, replaceStr: replaceStr)
let r = "[#Swift#] #Les#@$#son_01#.#txt#"

/*
 去理解 单词边界的意思    Swift   Les    son_01   txt 都是单词
 */

XCTAssertEqual(config.modify_result, r)
```

```swift
let inputString = "[Swift] Lesson_01.txt"
let pattern = "\\B"
let replaceStr = "#"


config = .init(pattern: pattern, inputString: inputString, replaceStr: replaceStr)

/*
 理解非单词边界，  跟 单词边界 正相反 ，参考上面的案例
 */
let r = "#[S#w#i#f#t]# L#e#s#s#o#n#_#0#1.t#x#t"

XCTAssertEqual(config.modify_result, r)
```

### `(?=...)` 和 `(?!=...)`

> - `(?=...)`： 正向先行断言，表示模式只有在某个位置之前的位置匹配时才匹配。例如，foo(?=bar) 匹配 "foo"，但仅当其后面是 "bar" 时才匹配。
>
> - `(?!...)`： 负向先行断言，表示模式只有在某个位置之前的位置不匹配时才匹配。例如，foo(?!bar) 匹配 "foo"，但仅当其后面不是 "bar" 时才匹配。

```swift
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
```

## 拓展

### ? 在正则表达式中的作用

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
