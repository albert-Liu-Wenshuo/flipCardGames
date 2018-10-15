//
//  Class03Teach.swift
//  CardGame01
//
//  Created by mac on 2018/10/15.
//  Copyright © 2018 ALBPersonal. All rights reserved.
//

import Foundation
import UIKit

// MARK: 创建一个基本的协议 吃饭protocol

/** 可以在协议的初始位置使用 ”class protocol eat{...}“ 将协议设置为只有类可以实现 */
 protocol eat {
    // ... 在protocol 的声明部分是不能带有函数的实现部分内容的
    func openMouse()

    // ... 在protocol 中设置property的时候需要注意标识 {get set}
    var food: String? {get set}

    // ... 如果这个方法的实现中设计到了改变自身的内容的话 如果这个协议被设计为可以为struct实现的话；则需要使用mutating修饰
    // ... 否则的话 struct 没法将添加了 mutating 的同名方法识别成该方法
    mutating func live(with food: String?)

}

// ... 设置一个空协议
protocol kong {

}

// ... 可以设置一个方法同时继承多个协议
 func doubleProtocolMethod(With Object: eat & kong) {
    // ... 该方法中使用的参数需要属于一个同时实现了 eat kong 协议的对象
}

// ... 数组/字典等类型可以将实现了相同协议的不同对象存储到一起
let array = [kong]()


// MARK: 可以为指定的Class / Struct 实现协议的时候设置默认的实现方法

// animal struct 实现了eat协议

struct animal: eat {


    var age = 20.0


    func openMouse() {
        print("animal open it's mouse ... ")
    }

    mutating func live(with food: String?) {
        guard let _ = food else {
            age = 0.0
            print("animal is died ... ")
            return
        }
        age -= 1 / 365.0
    }

    var food: String?

}


// MARK: person Class [并实现了eat协议]

class Person: eat {

    var age = 100.0

    func openMouse() {
        print("human open it's mouse ... ")
    }

    func live(with food: String?) {
        guard let _ = food else {
            age = 0.0
            print("person is died ... ")
            return
        }
        age -= 1 / 365.0
    }

    var food: String? {

        didSet(value) {
            if value == nil {
                print("没有获取到任何食物的 人 就要饿死了")
            }else {
                print("获取到的食物是 \(value ?? "")")
            }
        }
    }
}
