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

/**
 实现 Card 可以实现 == 方法以及 可以在字典中作为Key
 1. 字典中的Key 需要 实现 Hashable 协议 == 已保证字典的key都是唯一的
 2. 实现Hashabled需要是实现 Equatable 协议 而实现 Equatable 就可以实现 == 方法
 */
struct Card: Hashable {

    /**
        实现 Hashable 协议的方法
        对于存储属性都为Hashable的structs，以及具有all-Hashable关联值的enum类型 系统可以实现默认的
        func hash(into hasher: inout Hasher) 函数
        对于其他的类型可以通过实现 func hash(into hasher: inout Hasher) 使其实现 Hashable

     注:
        默认系统实现的 func hash(into hasher: inout Hasher) 函数 会因为任何一个属性的值的改变变动其哈希值
        如果你希望你的struct 不会因为某些值的改变变得 ！= 则你需要自定义 hash函数

     自定义方法
     实现 Equatable 需要实现 ' static func == (lhs: Card, rhs: Card) -> Bool '方法
     func hash(into hasher: inout Hasher) {
     // identified: 需要实现相等与哈希判断的属性
     hasher.combine(identified)
     }
     */

    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(identified)
    }


    var isFaceUp = false        // ... card 是否被翻面
    var isMatched = false       // ... card 是否匹配成功
    /** 设置Card自己的唯一标示并将其与Card的hashValue关联起来 */

    private var identified : Int       // ... card 的唯一标识符

    // ... 可以使用静态方法的方式实现对于唯一标识符的赋值

    /**
     1. 静态方法指的是由类本身而非类的对象调用的方法
     2. 在静态方法中可以直接调用类中的静态对象
     3. 可以通过静态方法和静态变量的组合实现每次创建类的identified唯一
     */

    private static var static_identified = 0        // ... 初始化默认当前的唯一标示为 0
    private static func createIdentified() -> Int {
        static_identified += 1
        return static_identified
    }

    // ... 实现自定义的struct 初始化方法
    /**
     1. 'with' 是 当前方法的形式参数
     2. 'identified' 是 当前方法的实际参数
     3. swift 使用形式参数与实际参数结合的方式实现方法名称尽可能的易读
     */
    init() {
        self.identified = Card.createIdentified()
    }

}
