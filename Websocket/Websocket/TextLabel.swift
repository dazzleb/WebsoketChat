//
//  TextLabel.swift
//  Websocket
//
//  Created by 시혁 on 2023/04/12.
//

import Foundation
import UIKit
class TextLabel: UILabel{
    var insets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    var bgColor: UIColor = .systemYellow
    var talkText: String = "" {
       didSet {
           DispatchQueue.main.async {
               self.text = self.talkText
           }
       }
   }
    // Primary initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    convenience init(talk: String, color: UIColor) {
        self.init(frame: .zero)
        //self.insets = insets
        self.bgColor = color
        self.talkText = talk
        configure()
    }
    //MARK: text inset 주기
        override func drawText(in rect: CGRect) {
            //let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
            super.drawText(in: rect.inset(by: insets))
        }
        ///insets을 변경한다고 intrinsicContentSize가 변경되지 않기 때문에, label.text의 내용이 잘리는 현상 발생하거나 top, bottom이 적용 안된 상태로 적용 > intrinsicContentSize 업데이트 필요
        override var intrinsicContentSize: CGSize {
            let size = super.intrinsicContentSize
            return CGSize(width: size.width + insets.left + insets.right,
                          height: size.height + insets.top + insets.bottom)
        }
    
    private func configure() {
        self.numberOfLines = 0
        self.font = .systemFont(ofSize: 14, weight: .bold)
        self.textAlignment = .left
        self.layer.cornerRadius = 14
        self.layer.backgroundColor = bgColor.cgColor
        self.text = talkText
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
