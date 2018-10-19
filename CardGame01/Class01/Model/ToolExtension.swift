//
//  ToolExtension.swift
//  CardGame01
//
//  Created by mac on 2018/10/15.
//  Copyright © 2018 ALBPersonal. All rights reserved.
//

import Foundation
import UIKit

// MARK: Int arc4random 随机数的实现方法
extension Int {

    func arc4random() -> Int {

        // ... 作为0 是没有随机数的

        switch self {
        case 0:     /** 随机数作为0的时候的返回处理 */
            return 0        // ... 不需要任何处理因为默认情况下 swift 的case 不会向下执行
        case ..<0:  /** 使用开空间的range的方式实现从负无穷到0的闭开区间 */
            return -Int(arc4random_uniform(UInt32(self)))
        default:
            return Int(arc4random_uniform(UInt32(self)))
        }

    }

}

// MARK: collection 中获取唯一元素的方法
// ... 当且仅当 collection 中只有一个元素的时候将这个元素返回；否则返回nil
extension Collection {
    // .... Element 代表当前类型的概念；能够将传入的类型自己正确的解析
//    func oneAndOnly() -> Element? {
//        /**
//         count 是 collection中的函数 用于获取 collection 中元素的个数
//         first 是 collection中的函数 用于获取 collection 中的第一个元素
//         */
//        return count == 1 ? first : nil
//    }

    var oneAndOnly : Element? {
        get {
            return count == 1 ? first : nil
        }
    }
}

/**
 通过static属性设置类的变量
 1. 因为在swift中只有static修饰的属性是属于 Class 本身而不是其对象的
 2. 可以通过设置类的静态对象的计算属性的方式设置独属于类的属性
 */
extension UIView {

    static var className : String {
        get {
            return NSStringFromClass(self)
        }
    }
}

extension UITableView {

    /**
     T 泛型使用的简单说明
     1. 通过返回 T 可以简单的使swift自动识别返回的类型
     2. 在泛型方法内部可能需要 as! T 的方式先将返回参数转成 泛型
     3. 可以通过 (_: T.Type) 方式将 需要传递的泛型的实例传入
     4. 或者直接使用 (_: T) 将泛型对应的类传入
     5. T 前面使用 <T: UITableViewCell> 的方式约束的时候 必须传入 (_: T.Type) 才能使swift 识别 T是否满足条件
     */

    // ... 注册代码创建的Cell的方法
    func registerCell<T: UITableViewCell>(_: T.Type) {

        register(T.self, forCellReuseIdentifier: T.className)

    }

    // ... 获取注册过的代码创建的Cell的方法
    func dequeueReusableCell<T: UITableViewCell>(_: T.Type) -> T {

        let cell = dequeueReusableCell(withIdentifier: T.className) as! T

        return cell

    }

}
