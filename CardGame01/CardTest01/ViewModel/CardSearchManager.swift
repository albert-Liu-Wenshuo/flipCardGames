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
    case unknow
}

class CardSearchManager {

    // ... 创建必要的刷新组件
    var page = 0        // ... 默认 page = 0
    var pagesize = 30   // ... 默认分页是 30

    // ... 需要一个数组承接内容

    var list = [SingleCard]()

    // ... 需要一个回调的参数
    var delegate : CardSearchDelegate

    // ... 设置修改网络状态的参数
    var search_net_status : NetWorkStatus? {

        didSet(status) {
            guard let _ = status else {
                return
            }
            searchCardList(of: params)
        }
    }


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
        self.search_net_status = NetWorkStatus.unknow

    }



    /**
     需要一系列的方法

     1. 搜索卡牌的网络请求的方法
     2. 刷新卡牌列表的方法(刷新；加载；搜索)
     3. 收藏选中的卡牌(取消收藏； 收藏)
     */

    func searchCardList(of params: [String: Any]?)  {

        let url = URL.init(string: "http://iyindgi.gonlan.com/gwent/card/search/vertical")!

        /**
         对于swift中的几种在闭包使用self的手段

         1. unowned let weakself = self 声明该对self的引用在未来会被销毁；这样可以避免循环引用 使用let 修饰不用 解包
         2. weak var weakself = self 声明该self的引用是弱引用，因为弱引用需要解包，所以调用的时候需要用guard语法糖承接一下
         3. 在自己控制的闭包中 使用 [weak self] 可以直接将内容作为参数穿进去

         注：unowned 声明不会强持有，但是也不会检测是否为 nil 所以当调用的时候可能会出现调用的对象已经被销毁的现象

         @objc private func buttonClick() {
         thirdViewController.closure = { [weak self] in
         guard let `self` = self else { return }
         self.test()
         }
         navigationController?.pushViewController(thirdViewController, animated: true)

         */
        weak var weakself = self

        Alamofire.request(url, method:  .post, parameters: params).responseJSON { (data) in

            guard let strongself = weakself else {
                print("当前对象 CardSearchManager 已经被注销掉")
                return
            }

            if data.result.isSuccess {
                guard let datadic = data.result.value as! [String: Any]? ,
                    let jsonDic = datadic["data"] as! [String: Any]? ,
                    let cardlistDic = jsonDic["cards"] as! [[String: Any]]? else {
                    print("数据解析格式失败 ... 原始数据为\n\(String(describing: data.result.value))")
                    let _ = strongself.delegate.recall(withNetType: strongself.search_net_status ?? NetWorkStatus.unknow, IsSuccess: false, Message: "数据取出失败")
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
                    let _ = strongself.delegate.recall(withNetType: strongself.search_net_status ?? NetWorkStatus.unknow, IsSuccess: false, Message: "解析有异常数据")
                }else {
                    for index in cards.indices {
                        guard let card = cards[index] else {
                            return
                        }
                        strongself.list.append(card)
                    }
                    let _ = strongself.delegate.recall(withNetType: strongself.search_net_status ?? NetWorkStatus.unknow, IsSuccess: true, Message: "解析数据成功")
                }

            }else {
                // ... 获取网络请求失败了
                if strongself.page == 0 {
                    strongself.list.removeAll()
                }else {
                    strongself.page -= 1
                }
                let _ = strongself.delegate.recall(withNetType: strongself.search_net_status ?? NetWorkStatus.unknow, IsSuccess: false, Message: data.result.error as! String)
            }

        }

    }

    func refresh() {
        page = 0
        search_net_status = NetWorkStatus.refresh
    }

    func load() {
        page += 1
        search_net_status = NetWorkStatus.loaddata
    }

    func changeSearchSelectionDic(with params: [String: Any]) {
        searchParams = params
        search_net_status = NetWorkStatus.searchchanged
    }


    // ... 调用回调代理的方法
    func callback(of success: Bool, NetStatus status: NetWorkStatus, Message msg: String) {

        let _ = self.delegate.recall(withNetType: status, IsSuccess: success, Message: msg)

    }

}

// ... 实现回调需要的 protocol
protocol CardSearchDelegate {

    // ... 声明了对于网络请求的回调的函数的声明
    func recall(withNetType netStatus: NetWorkStatus, IsSuccess success: Bool, Message msg: String) -> Bool

}

// ... 设置当实现protocol的是 UIViewController 的时候的默认实现
//extension CardSearchDelegate where Self: CardSearchListBaseController {
//
//    func recall(withNetType netStatus: NetWorkStatus, IsSuccess success: Bool, Message msg: String) -> Bool {
//
//        switch netStatus {
//        case  .refresh:
//            // .... 刷新列表操作
//            tableview.reloadData()
//            endRefresh()
//            print("01 .. ")
//        case  .loaddata:
//            // .... 加载列表操作
//            tableview.reloadData()
//            endRefresh()
//            print("02 .. ")
//        case  .searchchanged:
//            // .... 修改选中条件操作
//            tableview.reloadData()
//            print("03 .. ")
//        case  .unknow:
//            print("网络请求异常 .... 获取不到指定的网络请求类型")
//        }
//
//        return true
//    }
//
//}
