//
//  ViewController.swift
//  Websocket
//
//  Created by 시혁 on 2023/04/12.
//



// api 작업 진행 - 보내고 받아오는 데이터 모양 잡기



import UIKit

class ViewController: UIViewController {
    
    struct Message {
        enum SenderType {
            case ME, User
        }
        var id : String = "me"
        var username : String
        var profileImage : String
        var message : String
        var createdAt : String
        var type: SenderType
    }
    
    var allText: [Message] = []
    var name : String = ""
    @IBOutlet weak var talkToTableView: UITableView!
    
    @IBOutlet weak var userInputText: UITextField!
    
    @IBOutlet weak var writeButton: UIButton!
    
    @IBOutlet weak var nickNameTF: UITextField!
    
    var websocketTask : URLSessionWebSocketTask? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: - dataSource
        talkToTableView.dataSource = self
        userInputText.delegate = self
        connet()
    }
    
    @IBAction func userEditingText(_ sender: UITextField) {
        
    }
    
    ///전송버튼
    @IBAction func writeOkButton(_ sender: UIButton) {
        //API POST
        //메세지 랑 유저이름 두개를 보내야 한다.
        guard let nickN = nickNameTF.text else { return }
        // 요건 cell 에서 내꺼 유저꺼 이름으로  구분 할려고
        self.name = nickN
        guard let userI = userInputText.text else { return }
        
        //TODO: - 텍스트 필드에 값없으면 등록 x
        if userI.count != 0 {
            
            let inputData = ["username" : nickN,
                             "message" : userI
                                ]
            
            // POST
            TextAPI.textPost(inputData: inputData as [String : Any])
            
            //TODO: - 내가 쓴거 넣기
            //post는 보냈고 현재 nickN 의 data 만 셀로 표현되면 되는데
            allText.append(Message(id: "me", username: nickN, profileImage: "", message: userI, createdAt: "", type: .ME))
            
                print(#fileID, #function, #line, "\(allText)✅" )
            //TODO: - 텍스트 필드 값 초기화
            userInputText.text = ""
            
            //리로드
            DispatchQueue.main.async {
                self.talkToTableView.reloadData()
            }
        }else{
            print("값이 없어요")
        }

    }
    /// 소캣  연결
    fileprivate func connet(){
            //해제
        disconnect()
        
        let session = URLSession(configuration: .default,
                                 delegate: self,
                                 delegateQueue: OperationQueue())
        guard let url = URL(string: "wss://ws-ap3.pusher.com:443/app/bd0b7360f2c92f6cff54") else { return }
        websocketTask = session.webSocketTask(with: url)
        
        //TODO: - 구독 좋아요
        // Pusher 채널을 구독하는 JSON 데이터를 만듭니다.
        let data = #"{"event":"pusher:subscribe","data":{"channel":"public.room"}}"#

        // JSON 데이터를 WebSocket으로 전송합니다.
        websocketTask?.send(.string(data)) { error in
            if let error = error {
                print("Error sending WebSocket message: \(error.localizedDescription)")
            }
        }
        websocketTask?.resume()
        
        receieMsg()
        
    }
    ///  소캣 해제
    fileprivate func disconnect(){
        websocketTask?.cancel(with: .goingAway, reason: nil)
        print(#fileID, #function, #line, "- 해제 완료")
    }
    /// 리시브
    fileprivate func receieMsg(){
        
        websocketTask?.receive(completionHandler: {[weak self]( result: Result<URLSessionWebSocketTask.Message, Error>) in
            guard let self = self else {return}
            switch result {
            case .success(.string(let msg)):
                print(#fileID, #function, #line, "- success(.string) msg: \(msg)")
                /// Data들어 올 때 마다 리로드
                DispatchQueue.main.async {
                    self.talkToTableView.reloadData()
                    self.scrollToBottom()
                }
                guard let data = msg.data(using: .utf8) else {
                        print("Failed to convert message to data")
                        return
                    }
                    
                if let data = msg.data(using: .utf8),
                   let message = try? JSONDecoder().decode(DataConnet.self, from: data) {
                        guard let msgData = message.data else {return}
                            self.didReceiveMessage(msgData)
                    }
                
                self.receieMsg()
                
            case .success(.data(let msg)):
                print(#fileID, #function, #line, "- success(.data) msg: \(msg)")
            case .success(let msg):
                print(#fileID, #function, #line, "- success() msg: \(msg)")
            case .failure(let failure):
                print(#fileID, #function, #line, "- failure: \(failure)")
            }
        })
    }
    /// 센드
    fileprivate func sendMsg(){
       
    }
    /// data 넣기
    fileprivate func didReceiveMessage(_ message: String){
        // 한번더 디코딩
        guard let messageData = message.data(using: .utf8) else { return }
        if let msg = try? JSONDecoder().decode(SoketData.self, from: messageData) {
            //print(#fileID, #function, #line, "msg 입니다 .  \(msg)" )
            //            SoketData(
            //            id: "98f3959c-2e70-49c2-b89d-956cbdd71ac9",
            //            username: "ㅁ임ㄴㅇ",
            //            profileImage: "https://www.gravatar.com/avatar/d6c66cb7e7ffd06f7ecf7136eb2b7326.jpg?s=200&d=robohash",
            //            message: "ㅁㄴㅇㅁㄴㅇ",
            //            createdAt: "2023-04-17 08:19:05")
            
            //TODO: - allText 에 넣기
                // 소켓으로 들어오는 데이터 유저 타입 으로  저장
            self.allText.removeLast() // 요건 안하면 2번씩 찍힘
            self.allText.append(Message(id: msg.id,
                                        username: msg.username,
                                        profileImage: msg.profileImage,
                                        message: msg.message,
                                        createdAt: msg.createdAt,
                                        type: .User))
        }
    }
    func scrollToBottom() {
        if !allText.isEmpty {
            let indexPath = IndexPath(row: allText.count-1, section: 0)
            talkToTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

extension ViewController: UITableViewDataSource{
    //Cell 갯수
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        return allText.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.allText[indexPath.row]
        
        let msg = message.message
        let msgData = message.createdAt
        let msgUsername = message.username
        let msgProfile = message.profileImage
        
        //현재 닉네임 이랑 다르다면
        
        if message.username != self.name {
            let userCell = UserCell(msg: msg, msgDate: msgData, msgUsername: msgUsername, msgProfile: msgProfile, style: .default, reuseIdentifier: "UserCell")
            return userCell
        }else{
            let myCell = MyCell(msg: msg, msgDate: msgData, style: .default, reuseIdentifier: "MyCell")
            return myCell
        }
        
//
//        switch message.id {
//        case "me":
//            let myCell = MyCell(msg: msg, msgDate: msgData, style: .default, reuseIdentifier: "MyCell")
//            return myCell
//        case "98f3a9e9-9d48-4799-b5b2-bc719784199f":
//            let userCell = UserCell(msg: msg, msgDate: msgData, msgUsername: msgUsername, msgProfile: msgProfile, style: .default, reuseIdentifier: "UserCell")
//            return userCell
//        default:
//            let myCell = MyCell(msg: msg, msgDate: msgData, style: .default, reuseIdentifier: "MyCell")
//            return myCell
//        }
    }
}
extension ViewController: URLSessionWebSocketDelegate{
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print(#fileID, #function, #line, "- 연결됨 , session: \(session)")
    }

    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print(#fileID, #function, #line, "- 끊김 , session: \(session), closeCode: \(closeCode), reason: \(reason)")
    }
}
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        writeOkButton(UIButton())
        return true
    }
}

/// 처음 데이터 들어온거 디코딩 용
struct DataConnet: Codable {
    let event, data, channel: String?
}

