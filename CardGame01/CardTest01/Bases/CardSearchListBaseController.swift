//
//  CardSearchListBaseController.swift
//  CardGame01
//
//  Created by mac on 2018/10/17.
//  Copyright © 2018 ALBPersonal. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh

private let TableviewDefauleRowHeight = 60.0

class CardSearchListBaseController: UIViewController {

    // ... 设置其内定的数据处理Model
    lazy var netservice = CardSearchManager.init(of: self)

    lazy var tableview = UITableView.init(frame: self.view.frame, style: .grouped)  // ... 初始化tableview



    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.configTableview()
        // Do any additional setup after loading the view.
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.layoutTableview()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: 布局基本组件Layout
extension CardSearchListBaseController {

    func layoutTableview() {
        self.tableview.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaInsets.bottom)
        }
    }

}

// MARK: 默认组件的设置
extension CardSearchListBaseController {

    public func configTableview() {
        self.view.addSubview(tableview)
        tableview.backgroundView = UIView()
        tableview.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        tableview.separatorStyle =  .none
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = CGFloat(TableviewDefauleRowHeight)

        // ... iOS 11 之后屏蔽tableview默认的自计算高度

        tableview.estimatedRowHeight = 0
        tableview.estimatedSectionFooterHeight = 0
        tableview.estimatedSectionHeaderHeight = 0
        if #available(iOS 11.0, *) {
            tableview.contentInsetAdjustmentBehavior = .never
        }

        self.registerCellForTableview()

        // ... 设置 mjRefresh相关
        tableview.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.netservice.refresh()
        })

        tableview.mj_footer = MJRefreshAutoFooter.init(refreshingBlock: {
            self.netservice.load()
        })

        tableview.mj_header.beginRefreshing()
    }

    public func registerCellForTableview() {

        // ... 默认注册的是单卡设备单行的Cell组件
        tableview.registerCell(SingleCardLineStyleCell.self)

    }


}

// MARK: 方法拓展
extension CardSearchListBaseController {

    // ... tableview的
    func endRefresh() {
        tableview.mj_header.endRefreshing()
        tableview.mj_footer.endRefreshing()
    }
}

extension CardSearchListBaseController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return netservice.list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(SingleCardLineStyleCell.self)
        cell.selectionStyle =  .none
        cell.config(with: netservice.list[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }


}

// ... 因为声明了带有 CardSearchDelegate 的属性所以必须实现的延展
extension CardSearchListBaseController: CardSearchDelegate {

    func recall(withNetType netStatus: NetWorkStatus, IsSuccess success: Bool, Message msg: String) -> Bool {

        if success {
            switch netStatus {
            case  .refresh:
                // .... 刷新列表操作
                tableview.reloadData()
                endRefresh()
                print("01 .. 刷新列表的操作")
            case  .loaddata:
                // .... 加载列表操作
                tableview.reloadData()
                endRefresh()
                print("02 .. 加载列表的操作")
            case  .searchchanged:
                // .... 修改选中条件操作
                tableview.reloadData()
                print("03 .. 修改选中条件的方法")
            case  .unknow:
                print("网络请求异常 .... 获取不到指定的网络请求类型")
            }
            return true
        }

        print(msg)

        return false
    }

}
