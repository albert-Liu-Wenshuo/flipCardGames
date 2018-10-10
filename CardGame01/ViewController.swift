//
//  ViewController.swift
//  CardGame01
//
//  Created by mac on 2018/10/10.
//  Copyright © 2018 ALBPersonal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // ... 创建了用于承载翻牌之后显示的内容的emoji列表
    var emojiList = ["😀", "⚾️", "🐭", "🐭", "🥦", "⚾️", "😀", "🏹", "🥔", "🥔", "🥦", "🏹"]

    var flipCount = 0 {
        // ... didSet ... 用于在属性更改之后进行更新的操作
        // ... 使用这样的方式可以避免在每次修改 'flipCount' 的时候添加相同的修改代码
        didSet {
            flipCountLabel.text = "翻牌计数： \(flipCount)"
        }
    }

    // ... 可以使用拖拽全部对象的方式将 storyboard 上面的组件在代码中创建一个数组 [Outlet Collection]
    @IBOutlet var flipButtonsList: [UIButton]!      // ... 存储全部p翻牌按钮的数组
    @IBOutlet weak var flipCountLabel: UILabel!     // ... 用于记录翻牌次数的label

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // ... 用于实现翻牌的点击方法
    @IBAction func flipButton(_ sender: UIButton) {
        guard let buttonEmojiIndex = flipButtonsList.firstIndex(of: sender) else {
            print("点击的按钮没有加入到翻牌按钮组合中")
            return
        }
        let emojiStr = emojiList[buttonEmojiIndex]
        print("click on the button emoji is \(emojiStr)")
        // ... 实现点击之后翻牌的方法
        sender.setTitle("", for:  .normal)
        sender.setTitle(emojiStr, for:  .selected)
        if sender.isSelected == true {
            // ... 已经翻牌了现在恢复原来的状态
            sender.isSelected = false
            sender.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        }else {
            // ... 牌面没有翻开 ... 现在选择翻开

            sender.isSelected = true
            sender.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            // ... 每次翻开牌面选择 增加翻牌计数
            flipCount = flipCount + 1
        }
    }


}

