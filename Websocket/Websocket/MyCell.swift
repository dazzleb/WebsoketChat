//
//  myCell.swift
//  Websocket
//
//  Created by 시혁 on 2023/04/12.
//

import Foundation
import UIKit
class MyCell: UITableViewCell {
    // 배열로 는 데이터를 어떻게 받지 ?
    let msg : String
    let msgDate : String
    init(msg : String, msgDate : String ,style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.msg = msg
        self.msgDate = msgDate
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func configure(){
        self.backgroundColor = .white
        //let labelText = "\(self.inputText)"
        let backColor = UIColor(red: 0.200, green: 0.600, blue: 900, alpha: 0.5)
        /// 글 라벨
        let textLabel = TextLabel(talk: "\(msg)",color: backColor)
        
        ///  등록날짜
        let dateLabel : UILabel = {
            let dateLabel = UILabel()
            dateLabel.text = "\(msgDate)"
            dateLabel.font = .systemFont(ofSize: 12, weight: .light)
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            return dateLabel
        }()
        
        let talkStackView : UIStackView = {
            let talkStackView = UIStackView()
            talkStackView.axis = .vertical
            talkStackView.spacing = 8
            talkStackView.translatesAutoresizingMaskIntoConstraints = false
            return talkStackView
        }()
        self.contentView.addSubview(talkStackView)
        
        talkStackView.addArrangedSubview(dateLabel)
        talkStackView.addArrangedSubview(textLabel)
        
        
        NSLayoutConstraint.activate([
//            textLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
//            textLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
//            textLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
//            textLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 300) // 대화창의 커질 수 있는거 제한두기
//
            talkStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            talkStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            talkStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            talkStackView.widthAnchor.constraint(lessThanOrEqualToConstant: 300) // 대화창의 커질 수 있는거 제한두기
        ])
    }
}

