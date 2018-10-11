//
//  FlipCardViewModel.swift
//  CardGame01
//
//  Created by mac on 2018/10/11.
//  Copyright © 2018 ALBPersonal. All rights reserved.
//

import Foundation

class FlipCardViewModel {
    // ... viewModel 类 实际作用就是用于处理 翻牌游戏的简单的业务逻辑

    var numbersOfPairsOfCard : Int // ... 用于保存记录实际的翻牌组对的数量的变量名
    var Cards = [Card]()            // ... 初始化卡牌数组的属性
    var indexOfOneAndOnlyFacedUpCard : Int?     // ... 用于存储唯一一张翻面的卡牌的index



    init(numbersOfPairsOfCard: Int) {
        // ... 翻牌游戏初始化阶段需要做的一些事情

        // ... 当遇到获取的参数名称和设置的变量名称相同的时候； 可以使用self.'参数名称'的方式标识变量
        self.numbersOfPairsOfCard = numbersOfPairsOfCard

        // ... 根据成对的卡牌数量生成对应的卡牌数组

        // ... 当我们在函数中实际上不需要调用某个参数的时候可以使用 '_' 的方式忽略掉这个参数
        for _ in 1...numbersOfPairsOfCard {

            let card = Card.init()
            // ... 因为Card 使用的是结构体的方式创建 == 值传递的方法
            /**
             1. let copyOfCard = Card.init() == let copyOfCard = card
             2. card.append(Card.init()); card.append(Card.init()) == card += [Card.init(), Card.init()]
             3. '2' 提供的是一种array支持的语法糖 .. 可以使用 += 的方式实现append
             */

            Cards += [card, card]

        }
    }

    func choseCard(with CardIndex: Int) {
        // ... 选中卡牌之后的操作逻辑

        /**
         对于选中卡牌的操作中比较重要的逻辑是：

         1. 判断当前翻牌游戏的状态是不是选中了唯一翻面的牌
            是： 进入与第二张牌的匹配判断
            否： 进入当前是否没有翻开的牌判断
                是：当前没有翻开的牌 => 翻开选中的牌
                否：翻开当前的牌 并将之前的所有牌设置为未翻面

         2. 需要判断点击相同的牌的处理是不操作
         */
        if let hisCardIndex = indexOfOneAndOnlyFacedUpCard, hisCardIndex != CardIndex {

            Cards[CardIndex].isFaceUp = true
            if Cards[hisCardIndex].identified == Cards[CardIndex].identified {
                Cards[hisCardIndex].isMatched = true
                Cards[CardIndex].isMatched = true
            }
            indexOfOneAndOnlyFacedUpCard = nil

        }else {

            // ... 遍历全部的c卡牌并做对应的处理
            indexOfOneAndOnlyFacedUpCard = CardIndex

            for index in Cards.indices {
                Cards[index].isFaceUp = false
            }
            Cards[CardIndex].isFaceUp = true

        }
    }

}
