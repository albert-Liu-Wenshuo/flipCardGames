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
            updateFlipCountLabel()
        }
    }

    func updateFlipCountLabel() {

        let attribute_keyvalues :[NSAttributedString.Key : Any] = [
            NSAttributedString.Key.strokeColor: UIColor.yellow,
            NSAttributedString.Key.strokeWidth: 2.0,
            NSAttributedString.Key.foregroundColor: UIColor.darkText,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight:  .medium)
        ]

        let attstring = NSAttributedString(string: "翻牌计数： \(flipCount)", attributes: attribute_keyvalues)

        flipCountLabel.attributedText = attstring
    }

    // ... 可以使用拖拽全部对象的方式将 storyboard 上面的组件在代码中创建一个数组 [Outlet Collection]
    @IBOutlet var flipButtonsList: [UIButton]!      // ... 存储全部翻牌按钮的数组
    @IBOutlet weak var flipCountLabel: UILabel! {
        // ... 该方法可以在stroyboard初始化该组件之后执行
        didSet {
            updateFlipCountLabel()
        }
    }    // ... 用于记录翻牌次数的label
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
        print(emojis)
    }

    // ... 此时需要构建一个用于存储 emoji 与 index 的对应关系的变量
    var emojis = [Card: String]()


    // ... 现在需要将 emoji 与 卡牌 相互匹配起来
    func emoji(withObjent card: Card) -> String {

        // ... 1. 如果我们没有给这个card设置过对应的emoji
        if emojis[card] == nil {
            // ... 1.1 生成一个随机的 emojiList 的 index
            let redomIndex = emojiList.count.arc4random()       /** 使用函数中定义好的 Int的extension */
            // ... 1.2 将字典 emojis[card] 赋值为对应的 emoji
            emojis[card] = emojiList[redomIndex]
            // ... 1.3 将已经赋值了的 emoji 从 emojis 中移除避免卡牌对应的 emoji 重复
            emojiList.remove(at: redomIndex)
        }

        // ... 如果找不到inde对应的emoji 则返回一个指定好的标识符 '?'
        return emojis[card] ?? "?"
    }

    // ... 在点击之后刷新页面的操作
    func refreshViewAfterDataExcute() {

        for buttonIndex in flipButtonsList.indices {
            let button = flipButtonsList[buttonIndex]
            let card = flipViewModel.Cards[buttonIndex]
            // ... 换一种做法： 如果卡牌已经翻面了在判断它e的匹配状况
            button.setTitle("", for:  .normal)
            button.setTitle(emoji(withObjent: card), for:  .selected)
            if card.isFaceUp {
                button.isSelected = true
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }else {
                button.isSelected = false
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0): #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }

    }

}

