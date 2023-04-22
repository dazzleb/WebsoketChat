//
//  UserCell.swift
//  Websocket
//
//  Created by 시혁 on 2023/04/12.
//

import Foundation
import UIKit
class UserCell: UITableViewCell {
    let msg : String
    let msgDatae : String
    let msgUsername : String
    let msgProfile : String
    init(msg : String, msgDate: String, msgUsername: String, msgProfile: String,style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.msg = msg
        self.msgDatae = msgDate
        self.msgUsername = msgUsername
        self.msgProfile = msgProfile
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func configure(){
        self.backgroundColor = .white
        let backColor =  UIColor(red: 0.879, green: 0.223, blue: 0.42, alpha: 0.5)
        //let infoImg = UIImageView(image: UIImage(named: "info1"))
        //infoImg.contentMode = .scaleAspectFit
        /// 글 라벨
        let textLabel = TextLabel(talk: "\(self.msg)",color: backColor)
    
        ///  등록날짜
        let dateLabel : UILabel = {
            let dateLabel = UILabel()
            dateLabel.text = "\(self.msgDatae)"
            dateLabel.font = .systemFont(ofSize: 12, weight: .light)
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            return dateLabel
        }()
        /// 닉네임
        let nicknameLabel : UILabel = {
            let nicknameLabel = UILabel()
            nicknameLabel.text = "\(self.msgUsername)"
            nicknameLabel.font = .systemFont(ofSize: 12, weight: .light)
            nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
            return nicknameLabel
        }()
        // 데이트 와 닉네임 담는 스택뷰
        let bottomStackView : UIStackView = {
            let bottomStackView = UIStackView()
            bottomStackView.axis = .horizontal
            bottomStackView.spacing = 4
            bottomStackView.translatesAutoresizingMaskIntoConstraints = false
            return bottomStackView
        }()
        // 바텀스택뷰와 텍스트 담는 스택뷰
        let talkStackView : UIStackView = {
            let talkStackView = UIStackView()
            talkStackView.axis = .vertical
            talkStackView.translatesAutoresizingMaskIntoConstraints = false
            return talkStackView
        }()
        
        self.contentView.addSubview(talkStackView)
        
        bottomStackView.addArrangedSubview(nicknameLabel)
        bottomStackView.addArrangedSubview(dateLabel)
        
        talkStackView.addArrangedSubview(bottomStackView)
        talkStackView.addArrangedSubview(textLabel)
        
        
        NSLayoutConstraint.activate([
            talkStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            talkStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            talkStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            talkStackView.widthAnchor.constraint(lessThanOrEqualToConstant: 300)
        ])
    }
}
