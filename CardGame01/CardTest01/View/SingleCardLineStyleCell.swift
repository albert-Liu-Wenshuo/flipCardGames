//
//  SingleCardLineStyleCell.swift
//  CardGame01
//
//  Created by mac on 2018/10/17.
//  Copyright © 2018 ALBPersonal. All rights reserved.
//

import UIKit
import SnapKit

class SingleCardLineStyleCell: UITableViewCell {

    // ... 初始化组件的内容
    var cnameLabel = UILabel() {
        didSet(label) {
            label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            label.font = UIFont.systemFont(ofSize: 16, weight:  .medium)
        }
    }

    var enameLabel = UILabel() {
        didSet(label) {
            label.textColor = #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)
            label.font = UIFont.systemFont(ofSize: 14, weight:  .medium)
        }
    }

    var factionLabel = UILabel() {
        didSet(label) {
            label.textColor = #colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0.3921568627, alpha: 1)
            label.font = UIFont.systemFont(ofSize: 14, weight:  .regular)
        }
    }

    var claneLabel = UILabel() {
        didSet(label) {
            label.textColor = #colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0.3921568627, alpha: 1)
            label.font = UIFont.systemFont(ofSize: 14, weight:  .regular)
        }
    }

    var rarityLabel = UILabel() {
        didSet(label) {
            label.textColor = #colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0.3921568627, alpha: 1)
            label.font = UIFont.systemFont(ofSize: 14, weight:  .regular)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createBasicItems()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        itemLayout()
    }

    func createBasicItems() {
        addSubview(cnameLabel)
        addSubview(enameLabel)
        addSubview(factionLabel)
        addSubview(claneLabel)
        addSubview(rarityLabel)
    }

    func itemLayout() {

        cnameLabel.snp.makeConstraints { (cname) in
            cname.left.equalToSuperview().offset(20)
            cname.top.equalToSuperview().offset(20)
        }

        enameLabel.snp.makeConstraints { (ename) in
            ename.left.equalTo(cnameLabel)
            ename.top.equalTo(cnameLabel.snp_bottomMargin).offset(12)
        }

        factionLabel.snp.makeConstraints { (faction) in
            faction.top.equalTo(enameLabel.snp_bottomMargin).offset(20)
            faction.left.equalTo(cnameLabel)
        }

        claneLabel.snp.makeConstraints { (clane) in
            clane.top.equalTo(factionLabel.snp_bottomMargin).offset(12)
            clane.left.equalTo(cnameLabel)
        }

        rarityLabel.snp.makeConstraints { (rarity) in
            rarity.top.equalTo(claneLabel.snp_bottomMargin).offset(12)
            rarity.left.equalTo(cnameLabel)
        }
    }

    func config(with model: SingleCard) {
        // ... 对于获取的数据传递到 cell上面的方法
        cnameLabel.text = model.cname
        enameLabel.text = model.ename
        factionLabel.text = model.faction
        claneLabel.text = model.clane
        rarityLabel.text = model.rarity
    }

}
