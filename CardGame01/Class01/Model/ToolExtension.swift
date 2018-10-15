//
//  ToolExtension.swift
//  CardGame01
//
//  Created by mac on 2018/10/15.
//  Copyright © 2018 ALBPersonal. All rights reserved.
//

import Foundation

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
