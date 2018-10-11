//
//  CardModel.swift
//  CardGame01
//
//  Created by mac on 2018/10/11.
//  Copyright © 2018 ALBPersonal. All rights reserved.
//  创建的是 对于翻牌游戏中卡牌内容的抽象

import Foundation

/**
 对于结构体来说与Class最主要的区别
 1. 结构体不会有继承的概念
 2. 结构体是值类型复制，不会传递指针
 3. 结构体有默认的构造方法
 */
struct Card {
    var isFaceUp = false        // ... card 是否被翻面
    var isMatched = false       // ... card 是否匹配成功
    var identified : Int        // ... card 的唯一标识符

    // ... 可以使用静态方法的方式实现对于唯一标识符的赋值

    /**
     1. 静态方法指的是由类本身而非类的对象调用的方法
     2. 在静态方法中可以直接调用类中的静态对象
     3. 可以通过静态方法和静态变量的组合实现每次创建类的identified唯一
     */

    static var curretnIdentified = 0        // ... 初始化默认当前的唯一标示为 0
    static func identified() -> Int {
        curretnIdentified += 1
        return curretnIdentified
    }

    // ... 实现自定义的struct 初始化方法
    /**
     1. 'with' 是 当前方法的形式参数
     2. 'identified' 是 当前方法的实际参数
     3. swift 使用形式参数与实际参数结合的方式实现方法名称尽可能的易读
     */
    init() {
        self.identified = Card.identified()
    }

}
