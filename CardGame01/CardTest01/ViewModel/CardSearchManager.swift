//  卡牌搜索的管理类目
//  CardSearchManager.swift
//  CardGame01
//
//  Created by mac on 2018/10/17.
//  Copyright © 2018 ALBPersonal. All rights reserved.
//

import Foundation
import Alamofire

/** 创建这个struct的意义就是讲逻辑处理与所有UI操作相互隔绝开 */

enum NetWorkStatus {
    case refresh
    case loaddata
    case searchchanged
}

struct CardSearchManager {

    // ... 创建必要的刷新组件
    var page = 0        // ... 默认 page = 0
    var pagesize = 30   // ... 默认分页是 30

    // ... 需要一个数组承接内容

    var list = [SingleCard]()

    // ... 需要一个回调的参数
    var delegate : CardSearchDelegate

    // ... 需要保存的搜索状态
    var searchParams: [String: Any]?

    var params: [String: Any] {
        get {
            guard let current_params = searchParams else {
                return ["page": String(page), "size": String(pagesize)]
            }
            return current_params
        }
    }

    // ... 设置一个初始化的方法
    init<T: CardSearchListBaseController>(of targetVC:T) {
        // ... 使用 unowned 解除循环引用
        unowned let delegatorController = targetVC
        self.delegate = delegatorController
    }



    /**
     需要一系列的方法

     1. 搜索卡牌的网络请求的方法
     2. 刷新卡牌列表的方法(刷新；加载；搜索)
     3. 收藏选中的卡牌(取消收藏； 收藏)
     */

    mutating func searchCardList(of params: [String: Any]?)  {

        let url = URL.init(string: "")!

        // ... swift 的新版本声明 weakself 的方式
        let weakSelf = UnsafeMutablePointer(&self)

        Alamofire.request(url, method:  .post, parameters: params).responseJSON { (data) in

            if data.result.isSuccess {
                guard let jsonDic = data.result.value as! [String: Any]?,
                let cardlistDic = jsonDic["cards"] as! [[String: Any]]? else {
                    print("数据解析格式失败 ... 原始数据为\n\(String(describing: data.result.value))")
                    return
                }

                let cards = cardlistDic.map({ (cardic) -> SingleCard? in
                    let cardata = try? JSONSerialization.data(withJSONObject: cardic, options: JSONSerialization.WritingOptions.prettyPrinted)
                    return try? JSONDecoder().decode(SingleCard.self, from: cardata ?? Data())
                })

                // ... 校验cards 不能有nil 的内容
                if cards.contains(where: { (card) -> Bool in
                    return card == nil
                }) {
                    print("..... 有解析异常的数据 ..... ")
                    // .... 返回错误信息
//                    weakSelf.pointee.delegate.recall(withNetType: <#T##NetWorkStatus#>, IsSuccess: <#T##Bool#>, Message: <#T##String#>)
                }else {
                    for index in cards.indices {
                        guard let card = cards[index] else {
                            return
                        }
                        weakSelf.pointee.list.append(card)
                    }
                }

            }else {
                // ... 获取网络请求失败了
                if weakSelf.pointee.page == 0 {
                    weakSelf.pointee.list.removeAll()
                }else {
                    weakSelf.pointee.page -= 1
                }
            }

        }

    }

    mutating func refresh() {
        page = 0
        searchCardList(of: params)
    }

    mutating func load() {
        page += 1
        searchCardList(of: params)
    }

    mutating func changeSearchSelectionDic(with params: [String: Any]) {
        searchParams = params
        searchCardList(of: self.params)
    }


}

// ... 实现回调需要的 protocol
protocol CardSearchDelegate {

    // ... 声明了对于网络请求的回调的函数的声明
    func recall(withNetType netStatus: NetWorkStatus, IsSuccess success: Bool, Message msg: String) -> Bool

}

// ... 设置当实现protocol的是 UIViewController 的时候的默认实现
extension CardSearchDelegate where Self: CardSearchListBaseController {

    func recall(withNetType netStatus: NetWorkStatus, IsSuccess success: Bool, Message msg: String) -> Bool {

        switch netStatus {
        case  .refresh:
            // .... 刷新列表操作
            tableview.reloadData()
            endRefresh()
            print("01 .. ")
        case  .loaddata:
            // .... 加载列表操作
            tableview.reloadData()
            endRefresh()
            print("02 .. ")
        case  .searchchanged:
            // .... 修改选中条件操作
            tableview.reloadData()
            print("03 .. ")
        }

        return true
    }

}
