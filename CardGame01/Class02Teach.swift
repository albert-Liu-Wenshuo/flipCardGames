//
//  Class02Teach.swift
//  CardGame01
//
//  Created by mac on 2018/10/12.
//  Copyright © 2018 ALBPersonal. All rights reserved.
//

import Foundation


func learnHowToUseStrip() {

    /** 让我们自己实现一个计算属性 */
    var coculate: Float {
        get {
            // ... 这里是每次当调用到  coculate 函数的时候你想要执行的方法

            /**
             比如说： 有一个cell 每次当你访问coculate的时候它会计算它里面几个 text 所占用的行高最后计算出来
             cellHeight
             */

            return 0.1
        }

        set(newValue) {
            // ... 这里是每次你想要设置 coculate 的时候你想要调用执行的方法

            /**
             比方说你有一个 Card Model 每次设置计算次数的时候 你就会 循环 coculate 次去调用你的洗牌算法
             */

        }
    }

    // ... 注： 如果你的readonly属性只读的话，可以不使用 get 的方式设置函数
    var coculate_readOnly : Int {
        return 1
    }



    /**
     * from 代表range的起点
     * to 代表range的终点
     * by 代表每次增加的步长

     u≈ for (nsinter i = 0.3; i < 12.25; i += 0.3)

     */
    for floatNum in stride(from: 0.3, to: 12.25, by: 0.3) {
        print("the float number is \(floatNum)")
    }
}

func learnHowToUseTuple() {
    // ... Get a Tuple
    let x = ("albert", 24, "man", true)

    // ... 使用自定义命名调用元组
    // ... 对于元组中x在下文中没有使用到的变量 可以使用'_'的方式忽略掉
    let (name, _, _, _) = x
    print("the name contains in the Tuple is \(name)")

    // ... 直接在初始化的时候设置元组的命名的方法
    let newTuple: (name: String, type: String, weight: Float) = ("cat", "animal", 12.2)
    print("cat name = \(newTuple.name) , cat type = \(newTuple.type), car weight is \(newTuple.weight)")


}

/**
 1. 对于 ENUM 的学习
    1. swift 对于 enum 的使用与其他语言的区别在于 swift 的 enum 可以添加关联值
    2. 像 ； swift中的 optional 就是一种简单的 enum
    3. 对于 enum 中的关联值，只能在初始化 enum的时候设置
 */

enum mainEnum {
    case simple
    case simpleWithOption(content: String)
    case contentWithDouble(String, count: Int)
}

func learnHowToUseEnumInSwift() {
    // ... 初始化一个具有关联值的enum

    let enum_01 = mainEnum.contentWithDouble("hello", count: 1)

    print("输出实际的enum值\(enum_01)")

}
