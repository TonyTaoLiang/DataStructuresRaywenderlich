//
//  DP.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2021/11/5.
//

import Foundation

struct DP {

    //1.状态转移表法:麻省理工第一个走格子的的例子见手机图片
    //每一个格子的状态是其左/上状态加当前格子的值  比如到第二个1 是（3+1（左1+2+1），4+1（上1+3+1））选一个小的值填入
    /*
     1 3 5 9                 1 4 9 18
     2 1 3 4      由1->3     3 4 7 11
     5 2 6 7   ==========>   8 6 12 18
     6 8 4 3                14 14 16 19
     */

    func minDestDP(_ martix: [[Int]], _ n: Int) -> Int {

        var results: [[Int]] = Array(repeating: Array(repeating: -1, count: n), count: n)

        //因为只能往下或者往右不能回退，因此要把第一行第一列给初始化
        var sum: Int = 0
        for i in 0..<n {

            sum = sum + martix[0][i]
            results[0][i] = sum
        }

        sum = 0
        for j in 0..<n {

            sum = sum + martix[j][0]
            results[j][0] = sum
        }

        for i in 1..<n {

            for j in 1..<n {

                results[i][j] = min(results[i][j-1], results[i-1][j]) + martix[i][j]

            }

        }

        return results[n-1][n-1]

    }

    //2.状态转移方程法 有点类似递归的解题思路
    //一般情况下，我们有两种代码实现方法，一种是递归加“备忘录”，另一种是迭代递推。
    //这里我们使用备忘录的方式
    //动态转移方程：results[i][j] = min(results[i][j-1], results[i-1][j]) + martix[i][j]

    func minDestDPEquation(_ martix: [[Int]], _ n: Int, _ i: Int, _ j: Int, _ mem: inout [[Int]] ) -> Int {//从n-1倒着调用

        if i == 0 && j == 0 {
            return martix[0][0]
        }
        if mem[i][j] > 0 {
            return mem[i][j]
        }

        var minLeft = Int.max //初始为最大，这样后面方程选择的时候就会选已经计算过的小的值
        if j - 1 >= 0 {
            minLeft = minDestDPEquation(martix, n, i, j-1, &mem)
        }

        var minUp = Int.max

        if i - 1 >= 0 {
            minUp = minDestDPEquation(martix, n, i-1, j, &mem)
        }

        let current = martix[i][j] + min(minUp, minLeft)
        mem[i][j] = current
        return current

    }


    /*莱文斯坦距离：
    可以向下走（修改a串如删除a[i]）
       向右走(修改b串如删除b[j]。这样是不是就有走格子的感觉)
    对于第一行的初始化：其实就是拿a[i]和b[0~j]逐一比较，这个时候只能往右走即只能j+1。那么无非2种情况
    1.a[0] = b[j]这个时候最简单的计算方法是把b[j]前面的元素全部删除。这样a串就和b串一样了。数值为j
    2.a[0] != b[j]这个时候自己尝试举几个例子。a/abb（值：2 删除2个b 和上面一种情况j的值2相等这是一个巧合） a/bbb（值：3 删除2个b再把b改为a） a/bab（删除2个b）。这个时候发现不能简单的用数值j来表示，跟前一个的数值相关minDist[0][j-1]+1
    3.而要判断j！=0 是因为minDist[0][j-1]+1越界的问题
    4.这样还剩[0][0]这个格子，且不相等的情况

     for (int j = 0; j < m; ++j) { // 初始化第0行:a[0..0]与b[0..j]的编辑距离
     if (a[0] == b[j]) minDist[0][j] = j;
     else if (j != 0) minDist[0][j] = minDist[0][j-1]+1;
     else minDist[0][j] = 1;
     }
    */

    //1.回溯法解决莱文斯坦距离
    func LevenshteinDistanceBackTrace(_ stringA: String, _ stringB: String, _ i: Int, _ j: Int, _ edis: inout Int , _ mindis: inout Int){

        if i == stringA.count || j == stringB.count {
            if i < stringA.count {
                edis = edis + stringA.count - i
            }
            if j < stringB.count {
                edis = edis + stringB.count - j
            }
            if edis < mindis {
                mindis = edis
            }
            return
        }

        if stringA[stringA.index(stringA.startIndex, offsetBy: i)] == stringB[stringB.index(stringB.startIndex, offsetBy: j)] {
            //字符匹配
            LevenshteinDistanceBackTrace(stringA, stringB, i+1, j+1, &edis, &mindis)
        }else{
            //不匹配
            var dis = edis + 1
            LevenshteinDistanceBackTrace(stringA, stringB, i+1, j, &dis, &mindis)// 删除a[i]或者b[j]前添加一个字符
            LevenshteinDistanceBackTrace(stringA, stringB, i, j+1, &dis, &mindis)// 删除b[j]或者a[i]前添加一个字符
            LevenshteinDistanceBackTrace(stringA, stringB, i+1, j+1, &dis, &mindis)// 将a[i]和b[j]替换为相同字符
        }
    }

    //2.DP解决莱文斯坦距离(状态转移表法)
    func LevenshteinDistanceDP(_ stringA: String, _ stringB: String) -> Int {

        let i = stringA.count
        let j = stringB.count

        var martix = Array(repeating: Array(repeating: -1, count: j), count: i)

        //按上面的注释来初始化第一列，第一行
        for k in 0..<j {// 初始化第0行:a[0..0]与b[0..j]的编辑距离

            if stringA[stringA.index(stringA.startIndex, offsetBy: 0)] == stringB[stringB.index(stringB.startIndex, offsetBy: k)] {
                martix[0][k] = k
            }else if(k != 0){
                martix[0][k] = martix[0][k-1] + 1
            }else{
                martix[0][k] = 1
            }

        }

        for l in 0..<i { // 初始化第0列:a[0..i]与b[0..0]的编辑距离

            if stringB[stringB.index(stringB.startIndex, offsetBy: 0)] == stringA[stringA.index(stringA.startIndex, offsetBy: l)] {
                martix[l][0] = l
            }else if(l != 0){
                martix[l][0] = martix[l-1][0] + 1
            }else{
                martix[l][0] = 1
            }

        }

        //按行填表
        for r in 1..<i {

            for c in 1..<j {

                if stringA[stringA.index(stringA.startIndex, offsetBy: r)] == stringB[stringB.index(stringB.startIndex, offsetBy: c)] {//如果相等 取左+1，右+1，左上对角线（不+1）最小值
                    martix[r][c] = min(martix[r-1][c] + 1, martix[r][c-1] + 1, martix[r-1][c-1])
                }else{
                    martix[r][c] = min(martix[r-1][c] + 1, martix[r][c-1] + 1, martix[r-1][c-1] + 1)
                }
            }

        }

        return martix[i-1][j-1]
    }

    //3.最长公共子串
    /*
    王铮的感觉很复杂。MJ的好理解且转移方程也去除了(i-1,j)->(i,j);(i,j-1)->(i,j)的情况

    假设：
     i ∈ [1,str1.length]
     j ∈ [1,str2.length]

     dp(i,j) 是以str1[i-1]，str2[j-1]结尾的最长公共子串的长度
     dp(i,0) dp(0,j)均为0
     备注：(为什么不这样定义：dp(i,j) 是以str1[i]，str2[j]结尾的最长公共子串的长度？ 因为这样i，j的取值范围应该是
     i ∈ [0,str1.length)
     j ∈ [0,str2.length),而后面转移方程dp(i,j) = dp(i-1,j-1) + 1，当求dp(0,0)的时候岂不是求dp(-1,-1),但是我们都是定义一个二维数组来画表，数组下标怎么能为负数。)
    状态转移方程
    if str1[i] == str2[j] {//说明至少有一个公共子串，那么 i，j2个字符都用掉了，还能不能使公共子串更长呢，这就要看(i-1,j-1)
        dp(i,j) = dp(i-1,j-1) + 1
    } else {//说明以str1[i]结尾 又以str2[j]结尾的子串是不存在的
        dp(i,j) = 0
    }
    以上只是我们随意选取str1和str2的一个字符作为结尾的情况
    而我们是双层for循环，i，j这样就考虑到了所有的字符结尾的组合情况
    我们的最终解就是所有的dp(i,j)中最大的 max(dp(i,j))
    */
    func maxLongSubstring(_ str1: String, _ str2: String) -> Int{//二维数组画表

        if str1.count == 0 || str2.count == 0{
            return 0
        }

        var result = 0

        var martix = Array(repeating: Array(repeating: 0, count: str2.count+1), count: str1.count+1)//+1 是因为如上i，j的取值范围决定的

        for i in 1...str1.count {

            for j in 1...str2.count {

                if str1[str1.index(str1.startIndex, offsetBy: i-1)] != str2[str2.index(str2.startIndex, offsetBy: j-1)] {
                    continue //因为二维数组初始化的时候已经置0了，可直接跳过
                }

                martix[i][j] = martix[i-1][j-1] + 1

                result = max(result, martix[i][j])
            }
        }

        return result

    }

    func maxLongSubstring2(_ str1: String, _ str2: String) -> Int {

         if str1.count == 0 || str2.count == 0{
             return 0
         }

         var result = 0

        /*
         //一维数组优化
         0 1 0 0 1 0
         0 0 0 0 0 2
         */
         var martix = Array(repeating: 0, count: str2.count+1)//+1 是因为如上i，j的取值范围决定的

         for i in 1...str1.count {

            var cur = 0

             for j in 1...str2.count {

                let leftTop = cur//上一层的左上对角线
                cur = martix[j]//cur往右走

                 if str1[str1.index(str1.startIndex, offsetBy: i-1)] != str2[str2.index(str2.startIndex, offsetBy: j-1)] {
                     martix[j] = 0
                 }else{
                    martix[j] = leftTop + 1//这里开始martix赋值到下一行
                 }

                 result = max(result, martix[j])
             }
         }

         return result

    }

    func maxLongSubstring3(_ str1: String, _ str2: String) -> Int {

     //一维数组再优化，不要lefttop记住，从右往左算 倒着遍历 这样左上对角线的值就没有被覆盖
     if str1.count == 0 || str2.count == 0{
         return 0
     }

     var result = 0

     var martix = Array(repeating: 0, count: str2.count+1)//+1 是因为如上i，j的取值范围决定的

     for i in 1...str1.count {

        for j in (1...str2.count).reversed() {

//             if str1[str1.index(str1.startIndex, offsetBy: i-1)] != str2[str2.index(str2.startIndex, offsetBy: j-1)] {
//                 martix[j] = 0
//             }else{
//                martix[j] = martix[j-1] + 1//这里martix[j-1]还是上一行的值
//             }

            if str1[i-1] != str2[j-1] {
                martix[j] = 0
            }else{
               martix[j] = martix[j-1] + 1//如果是从后往前遍历：这里martix[j-1]还是上一行的值
            }

             result = max(result, martix[j])
         }
     }

     return result

    }

    func longestPalindrome33(_ s: String) -> String {
            let cs = s.cString(using: .ascii)!
            let n = strlen(cs)
            // 二维数组`c`用来缓存长度大于等于2的回文子串判定
            // 默认值为false
            var c: [[Bool]] = Array(repeating: Array(repeating: false, count: n),
                                    count: n)
            // 确保n > 1，否则n <= 1的话直接返回字符串即可
            // 因为它肯定是回文子串
            guard n > 1 else { return s }

            // 保存一个最长回文子串的长度和子串范围索引
            var maxlen = 0
            var rng: (Int, Int) = (0, 0)

            // 寻找从2到n长度的回文子串
            for l in 2...n {
                // 开始遍历索引
                for i in 0..<n-l+1 {
                    // 只有首尾相等时才有可能是回文子串
                    if cs[i] == cs[i+l-1] && (l <= 3 || c[i+1][i+l-2]) {
                        // 保存计算结果
                        c[i][i+l-1] = true
                        if l > maxlen {
                            rng = (i, i+l-1)
                            maxlen = l
                        }
                    }
                }
            }
            return String(cString: cs[rng.0...rng.1].map{$0} + [0])
        }

    //使用cString，不使用String就不会超时
    func longestPalindrome4(_ s: String) -> String {

//        var res = ""

        //转成数组，方便下面操作字符串的下标
//        let sCharts = Array(s)
        let cs = s.cString(using: .ascii)!
        let n = strlen(cs)
        var rng: (first: Int, second: Int) = (0, 0)
        //优化一下,类似于最长公共子串，用一维数组倒着遍历j。如果顺着遍历就会覆盖下一层
        var dp = Array(repeating: false, count: s.count)

        for i in (0...n-1).reversed() {

            for j in (i..<n).reversed() {
                //j-1 < 3是字符串长度为0，1，2 几种特殊情况只需要判断头尾是否相等
                dp[j] = cs[i] == cs[j] && ((j-i < 3) || dp[j-1])

                //每次保存下当前最长的串
                if dp[j] && j - i + 1 > rng.second - rng.first {
                    //操作下标
                    rng = (i,j)
//                    res = String(s[i..<j+1])
                }
            }

        }
        return String(cString: cs[rng.0...rng.1].map{$0} + [0])

    }
}

public extension String {
  subscript(value: Int) -> Character {
    self[index(at: value)]
  }
}

public extension String {
  subscript(value: NSRange) -> Substring {
    self[value.lowerBound..<value.upperBound]
  }
}

public extension String {
  subscript(value: CountableClosedRange<Int>) -> Substring {
    self[index(at: value.lowerBound)...index(at: value.upperBound)]
  }

  subscript(value: CountableRange<Int>) -> Substring {
    self[index(at: value.lowerBound)..<index(at: value.upperBound)]
  }

  subscript(value: PartialRangeUpTo<Int>) -> Substring {
    self[..<index(at: value.upperBound)]
  }

  subscript(value: PartialRangeThrough<Int>) -> Substring {
    self[...index(at: value.upperBound)]
  }

  subscript(value: PartialRangeFrom<Int>) -> Substring {
    self[index(at: value.lowerBound)...]
  }
}

private extension String {
  func index(at offset: Int) -> String.Index {
    index(startIndex, offsetBy: offset)
  }
}


//两数之和 二分 + N Queens
//最长上升子序列 ++ 递归回溯(14~16)+ DFS/BFS 橘子岛屿问题 +全排列DFS（谷歌） + 李拉钩 + 其他题
//KMP 争哥
//207 210课程表 拓扑排序，有向无环图
