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
    var emojiList = ["🐱", "🐹", "🍈", "🥦", "🤽🏽‍♀️", "☹️", "😗", "🥔", "🥨", "🐤"]

    //MARK: 设置成对的卡牌数量的计算函数
    var numbersOfPairsOfCard: Int {
        return (flipButtonsList.count + 1) / 2
    }


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
    @IBOutlet weak var washButton: UIButton!        // ... 洗牌按钮
    
    // ... 创建用于数据处理的函数
    /**
     1. 初始化 flipViewModel 需要获取到 flipButtonsList的count 初始化的时候的相互引用会引发重提
     2. 解决的方式是使 flipViewModel 以懒加载的方式加载，这样就不会相互冲突了
     3. (flipButtonsList.count + 1) / 2) 的方式可以规避创建的card数组的总数量小于button数组
     */
    lazy var flipViewModel = FlipCardViewModel.init(numbersOfPairsOfCard: self.numbersOfPairsOfCard)

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // ... 洗牌方法
    @IBAction func washCards(_ sender: UIButton) {
        flipViewModel.washTheCards()
        refreshViewAfterDataExcute()
    }

    // ... 重新开局
    @IBAction func replay(_ sender: UIButton) {

        // ... 需要恢复历史数据
        emojis.removeAll()
        emojiList = ["🐱", "🐹", "🍈", "🥦", "🤽🏽‍♀️", "☹️", "😗", "🥔", "🥨", "🐤"]
        flipCount = 0

        flipViewModel.resetThePlay()
        refreshViewAfterDataExcute()

        // ... 重新开局之后才能洗牌
        sender.isEnabled = true
    }
    // ... 用于实现翻牌的点击方法
    @IBAction func flipButton(_ sender: UIButton) {

        // ... 游戏开始之后就不能洗牌了
        washButton.isEnabled = false


//        guard let buttonEmojiIndex = flipButtonsList.firstIndex(of: sender) else {
//            print("点击的按钮没有加入到翻牌按钮组合中")
//            return
//        }
//        let emojiStr = emojiList[buttonEmojiIndex]
//        print("click on the button emoji is \(emojiStr)")
//        // ... 实现点击之后翻牌的方法
//        sender.setTitle("", for:  .normal)
//        sender.setTitle(emojiStr, for:  .selected)
//        if sender.isSelected == true {
//            // ... 已经翻牌了现在恢复原来的状态
//            sender.isSelected = false
//            sender.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
//        }else {
//            // ... 牌面没有翻开 ... 现在选择翻开
//
//            sender.isSelected = true
//            sender.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//            // ... 每次翻开牌面选择 增加翻牌计数
//            flipCount = flipCount + 1
//        }

        // ... 使用MVC 的方式重新构建翻牌游戏的逻辑
        guard let choseIndex = flipButtonsList.firstIndex(of: sender) else {
            print("该按钮没有加入到切换列表中")
            return
        }
        // ... 刷新计数
        flipCount += 1
        flipViewModel.choseCard(with: choseIndex)
        // ... 之后执行更新UI的操作
        refreshViewAfterDataExcute()
    }

    // ... 此时需要构建一个用于存储 emoji 与 index 的对应关系的变量
    var emojis = [Int: String]()


    // ... 现在需要将 emoji 与 卡牌相互匹配起来
    func emoji(withButtonIndex index: Int) -> String {

        // ... 我们在每次需要获取emoji的时候给对应的index获取响应的emoji

        if emojis[index] == nil {
            let redomIndex = Int(arc4random_uniform(UInt32(emojiList.count)))
            emojis[index] = emojiList[redomIndex]
            // ... 将emoji输入到数组中之后需要将该emoji移除出数组，以免以后复用
            emojiList.remove(at: redomIndex)
        }

        // ... 如果找不到inde对应的emoji 则返回一个指定好的标识符 '?'
        return emojis[index] ?? "?"
    }

    // ... 在点击之后刷新页面的操作
    func refreshViewAfterDataExcute() {

        for buttonIndex in flipButtonsList.indices {
            let button = flipButtonsList[buttonIndex]
            let card = flipViewModel.Cards[buttonIndex]
            // ... 换一种做法： 如果卡牌已经翻面了在判断它e的匹配状况
            button.setTitle("", for:  .normal)
            button.setTitle(emoji(withButtonIndex: card.identified), for:  .selected)
            if card.isFaceUp {
                button.isSelected = true
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }else {
                button.isSelected = false
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0): #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }

//            if card.isMatched {
//                button.isEnabled = false
//                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
//            }else {
//                button.setTitle("", for:  .normal)
//                // ... emoji 是有card 的唯一标示一一对应的
//                button.setTitle(emoji(withButtonIndex: card.identified), for:  .selected)
//                if card.isFaceUp {
//                    button.isSelected = true
//                    button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//                }else {
//                    button.isSelected = false
//                    button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
//                }
//            }
        }

    }

}

