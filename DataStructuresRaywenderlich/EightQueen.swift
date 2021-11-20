//
//  EightQueen.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2021/10/18.
//

import Foundation
//个人总结：回溯和DP状态转移方程法 都是类似递归的解题思路 就是根据条件罗列所以的可能性进行递归。
//例如
//1. 0-1背包 不装递归下backTrackBag(i: i+1, cw: cw, items: items, n: n, w: w)
             //装：递归backTrackBag(i: i+1, cw: cw+items[i], items: items, n: n, w: w)
//2.DP状态转移方程跳格子：横跳minLeft = minDestDPEquation(martix, n, i, j-1, &mem)
//                    竖跳minUp = minDestDPEquation(martix, n, i-1, j, &mem)
//3.计算莱文斯坦距离（量化两个字符串的相似度）
/*
 if (a[i] == b[j]) { // 两个字符匹配
    lwstBT(i+1, j+1, edist);
 } else { // 两个字符不匹配
    lwstBT(i + 1, j, edist + 1); // 删除a[i]或者b[j]前添加一个字符
    lwstBT(i, j + 1, edist + 1); // 删除b[j]或者a[i]前添加一个字符
    lwstBT(i + 1, j + 1, edist + 1); // 将a[i]和b[j]替换为相同字符 }
 */

//八皇后问题：回溯算法https://www.cnblogs.com/kangxinxin/p/9968524.html
//所谓递归回溯，本质上是一种枚举法。（重点：枚举所有可能，剪枝不满足的情况）这种方法从棋盘的第一行开始尝试摆放第一个皇后，摆放成功后，递归一层，再遵循规则在棋盘第二行来摆放第二个皇后。如果当前位置无法摆放，则向右移动一格再次尝试，如果摆放成功，则继续递归一层，摆放第三个皇后......

//如果某一层看遍了所有格子，都无法成功摆放，则回溯到上一个皇后，让上一个皇后右移一格，再进行递归。如果八个皇后都摆放完毕且符合规则，那么就得到了其中一种正确的解法
//1.每一行有8种放法，递归row，循环column
//2.判断此列可以放：他的正上方，左斜上方，右斜上方，依次一层层向上

/**
 回溯算法通用的模版如下：
 void backtrack(int k) {
     if (到达边界) {
         更新或者输出结果;
     } else {
         for(循环对于每一种可能进行操作 i) {
             if (限定条件合法)
                 backtrack(k + i);
         }
     }
 }
 */
/**
 N皇后复杂度分析：回溯算法的最坏时间复杂度分别为：
 O(p(n) * n!)
 O(p(n) * 2n)
 O(p(n) * nn)
 其中，p(n)表示生成一个节点所需的时间复杂度。
 其中涉及到子集树，排列树的概念
 1.当我们求解的结果是集合S的某一子集的时候，其对应的解空间是子集树。时间复杂度O(2^n) 如0-1背包
 2.当我们求解的结果是集合S的元素的某一种排列的时候，其对应的解空间就是排列树。时间复杂度O(n!)
 https://blog.csdn.net/u013009552/article/details/107064859/
 https://blog.csdn.net/zjq_1314520/article/details/75126866
 */
//N皇后：老师的回溯写的非常巧妙，利用一维数组，循环中下一次的落子掩盖了上一次错误的落子。有一些解法中为了突出回溯的感觉，使用二维数组存贮0和1来模拟棋盘每个位置的落子与否。此时要注意，如果当前位置落子后，子递归无法满足条件，需要将当前落子置0再继续循环。通过落子和收回的操作来突出回溯的感觉，也很有意思，但不如老师写的高效。
//另外的做法看leetcode:51题
struct EightQueen {


    var result = [Int](repeating: -1, count: 8)//下标是行，数值是列
    mutating func eightQueen(row: Int){

        if row == 8 {//全部放完
            printQueens(result: result)
            return // 8行棋子都放好了，已经没法再往下递归了，所以就return
        }

        //每一行都有8中放法
        for column in 0..<8 {//重点：这里才是回溯的地方，如果第5行入栈选了一列column放棋子，然后第6行入栈，此时第6行无路可放循环一遍之后出栈。此时就回溯到第5行的这个列的循环column+++，此时第5行就换了个地方下棋。如果第5行循环一遍第6行仍是无路可放。此时第5行也出栈，回溯到第四行。
            //这也是为什么在一步步调试的时候if isOK（）这个位置会反复进来的原因

            if isOK(row: row, column: column) {//满足条件
                result[row] = column//第row行的棋子放到了column列
                let next = row + 1
                eightQueen(row: next)//下一行 递归 
            }

        }

    }


    func isOK(row: Int, column: Int) -> Bool {

        var leftUp = column - 1, rightUp = column + 1

        for i in (0..<row).reversed() {//逐行往上考察每一行

            if result[i] == column {//正上方
                return false
            }

            /**
             //对角线其实有方便的判断方法(列差=行差)
             if abs(result[i] - column) == abs(i - row) {
                 return false
             }
             */
            if leftUp >= 0 && (result[i] == leftUp) { //考察左上对角线：第i行leftup列有棋子吗？
                return false
            }

            if rightUp < 8 && (result[i] == rightUp) {
                //考察右上对角线：第i行rightup列有棋子吗？
                return false
            }

            //每上一层row，对角线上的点开始移动
            leftUp -= 1
            rightUp += 1
        }

        return true
    }

    func printQueens(result: Array<Int>){

        print(result)

        var root = ""

        for row in 0..<8 {

            for column in 0..<8{

                if result[row] == column{
                   root = root + "Q "
                }else {
                   root = root + "* "
                }

            }

            root = root + "\n"
        }

        print(root)
    }

    // cw表示当前已经装进去的物品的重量和；i表示考察到哪个物品了； w背包重量；items表示每个物品的重量；n表示物品个数// 假设背包可承受重量100，物品个数10，物品重量存储在数组a中，那可以这样调用函数：
    // f(0, 0, a, 10, 100)
    /**
     开始不装:1-----重:0
     开始不装:2-----重:0
     开始不装:3-----重:0
     到头了前:3-----重:0
     到头了后:3-----重:0
     开始装:3-----重:3
     到头了前:3-----重:3
     到头了后:3-----重:3
     开始装:2-----重:6
     开始不装:3-----重:6
     到头了前:3-----重:6
     到头了后:3-----重:6
     开始装:3-----重:9
     到头了前:3-----重:9
     到头了后:3-----重:9
     开始装:1-----重:2
     开始不装:2-----重:2
     开始不装:3-----重:2
     到头了前:3-----重:2
     开始装:3-----重:5
     到头了前:3-----重:5
     开始装:2-----重:8
     开始不装:3-----重:8
     到头了前:3-----重:8
     */
    var maxvalue = Int.min
    mutating func backTrackBag(i: Int, cw: Int, items: Array<Int>, n: Int, w: Int)  {

        if cw == w || i == n {

            print("到头了前:\(i)-----重:\(cw)")
            if cw > maxvalue {
                maxvalue = cw
            print("到头了后:\(i)-----重:\(maxvalue)")
            }
            return //以前理解的没错，第一次f(3,0) return后 就出栈了 ，接下来栈区自顶向下是f(2,0)，f(1,0)，f(0,0).那么第一次if cw + items[i] <= w这里的i就是2，后面再调用backTrackBag(i: i+1, cw: cw+items[i], items: items, n: n, w: w) 就是调用的i就是3：backTrackBag(i: 3, cw: cw+items[i], items: items, n: n, w: w)
        }

        print("开始不装:\(i+1)-----重:\(cw)")
        backTrackBag(i: i+1, cw: cw, items: items, n: n, w: w)//不装

        if cw + items[i] <= w {// 已经超过可以背包承受的重量的时候，就不要再装了
            print("开始装:\(i+1)-----重:\(cw+items[i])")
            backTrackBag(i: i+1, cw: cw+items[i], items: items, n: n, w: w)
        }

    }

    //DP解决0-1背包
    func dpBag(_ items: Array<Int>, _ nums: Int, _ w: Int) -> Int{

        //一共n（物品总数）行，每一行0～w（总重限制）个状态
        var dpStatus: [[Bool]] = [[Bool]](repeating: [Bool](repeating: false, count: w+1), count: nums)
        //第一个元素特殊处理
        dpStatus[0][0] = true

        if items[0] <= w {
            dpStatus[0][items[0]] = true
        }

        for row in 1..<nums {//状态转移

            //当前物品不加入的状态，直接继承上一个状态
            for i in 0...w {//循环所有可能的重量，找出上一层的状态
                if dpStatus[row-1][i] == true {
                    dpStatus[row][i] = true
                }
            }

            //当前物品加入
            for i in 0...w-items[row] {

                if dpStatus[row-1][i] == true{

                    dpStatus[row][i + items[row]] = true
                }
            }

        }

        //找出最后一层中的最大值（因为他是继承了所有的状态）
        for i in (0...w).reversed() {

            if dpStatus[nums-1][i] == true {
                return i
            }
        }

        return 0
    }


    //DP解决0-1背包升级：每个物品除了重量还有价值，求最高价值
    func dpBagsValue(_ weight: Array<Int>, _ nums: Int, _ w: Int, _ value: Array<Int> ) -> Int {

        //二维数组里面放的是价值了
        var results: [[Int]] = Array(repeating: Array(repeating: -1, count: w+1), count: nums)

        //处理第一个物品
        results[0][0] = 0

        if weight[0] <= w {
            results[0][weight[0]] = value[0]
        }

        for i in 1..<nums {

            for j in 0...w {

                if results[i-1][j] > 0 {

                    results[i][j] = results[i-1][j]
                }

            }

            for j in 0...w-weight[i] {

                if results[i-1][j] > 0 {

                    //重量相同，但是价值可能不同（第一个物品（2 3） 第二个物品（2 4）。放1不放2 重量为2，价值3 而放2不放1 重量也为2 价值为4）所以取重的那个状态刷新原二维数组
                    //此处加入了物品，那么刷新的是加入了重量的位置
                    if  results[i-1][j] + value[i] > results[i][j + weight[i]]{
                        results[i][j + weight[i]] = results[i-1][j] + value[i]
                    }

                }

            }


        }

        //最后一层状态找最大值
        var maxV = -1

        for i in 0...w {
            if results[nums-1][i] > maxV {
                maxV = results[nums-1][i]
            }
        }

        return maxV
    }

    //DP升级之双十一
    //淘宝的“双十一”购物节有各种促销活动，比如“满 200 元减 50 元”。假设你女朋友的购物车中有 n 个（n>100）想买的商品，她希望从里面选几个，在凑够满减条件的前提下，让选出来的商品价格总和最大程度地接近满减条件（200 元），这样就可以极大限度地“薅羊毛”
    //实际上，它跟第一个例子中讲的 0-1 背包问题很像，只不过是把“重量”换成了“价格”而已。购物车中有 n 个商品。我们针对每个商品都决策是否购买。每次决策之后，对应不同的状态集合。我们还是用一个二维数组 states[n][x]，来记录每次决策之后所有可达的状态。不过，这里的 x 值是多少呢？0-1 背包问题中，我们找的是小于等于 w 的最大值，x 就是背包的最大承载重量 w+1。对于这个问题来说，我们要找的是大于等于 200（满减条件）的值中最小的，所以就不能设置为 200 加 1 了。就这个实际的问题而言，如果要购买的物品的总价格超过 200 太多，比如 1000（假设双十一预算是1000），那这个羊毛“薅”得就没有太大意义了。所以，我们可以限定 x 值为 1001（背包列是0～9.这里是0～1000）
    //也就是我们找200～1000里面的最小值，然后倒推是选择了那几个物品


    /// - Parameters:
    ///   - shoppingCart: 购物车里的物品.
    ///   - n: 物品个数
    ///   - w: 优惠券价值
    ///   - budget: 预算
    func shoppingDouble11(_ shoppingCart: Array<Int>, _ n: Int, _ w: Int, _ budget: Int){

        //列的数量是 预算+1
        var results: [[Bool]] = Array(repeating: Array(repeating: false, count: budget+1), count: n)

        //前半部分跟0-1背包一样
        results[0][0] = true
        if shoppingCart[0] <= budget {
            results[0][shoppingCart[0]] = true
        }

        for i in 1..<n {

            for j in 0...budget {
                if results[i-1][j] == true {
                    results[i][j] = results[i-1][j]
                }
            }

            for j in 0...budget-shoppingCart[i] {

                if results[i-1][j] == true {
                    results[i][j+shoppingCart[i]] = true
                }
            }

        }

        //再最后一行中查询 优惠券～预算之间的最小值
        var money: Int = 0

        for j in w...budget {
            if results[n-1][j] == true {
                //找到的第一个就是最小的
                money = j
                break
            }
        }

        //一层层往上倒推
        for i in (1...n-1).reversed() {

            if money-shoppingCart[i] > 0 && results[i-1][money-shoppingCart[i]] == true {
                //说明此物品已加入
                print("已加入\(shoppingCart[i])元的物品——第\(i+1)个")
                money = money-shoppingCart[i]

            }//else 说明此物品没有加入，是从上面继承的那么money不变

        }

        //处理第一行
        if money != 0 {
            print("已加入\(shoppingCart[0])元的物品——第1个")
        }
    }

    
}

