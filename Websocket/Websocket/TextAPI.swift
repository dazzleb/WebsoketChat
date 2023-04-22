//
//  TextAPI.swift
//  Websocket
//
//  Created by 시혁 on 2023/04/17.
//

import Foundation
//        {
//            "id" : "98d2e1a5-382c-4e2a-a1aa-9602edf6c916",
//            "username" : "헬로우",
//            "message" : "하하하 테스트",
//            "createdAt" : "2023-04-01 02:09:22"
//        }
enum TextAPI{
    static let baseURL = "https://phplaravel-574671-3402493.cloudwaysapps.com/api/new-message"
    static func  textPost(inputData textData: [String : Any] ){
        
        let date = Date() // 현재 날짜와 시간을 가져옵니다.
        let dateFormatter = DateFormatter() // DateFormatter 인스턴스 생성
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 출력 포맷 설정
        let dateString = dateFormatter.string(from: date) // 문자열로 변환
    
        let requestParams: [String: Any] = [
            "id": "98d2e1a5-382c-4e2a-a1aa-9602edf6c916",
            "username": textData["username"] as? String ?? "닉네임", // textData 딕셔너리에서 "username" 값을 가져옵니다.
            "message": textData["message"] as? String ?? "말이 전달안댐", // textData 딕셔너리에서 "message" 값을 가져옵니다.
            "createdAt": dateString
        ]
        
        let url = URL(string: baseURL)!
        var urlRequest = URLRequest(url: url)
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestParams, options: [.prettyPrinted]) else { return }
        
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jsonData
        
        URLSession.shared.dataTask(with: urlRequest) { data, URLResponse, err in

            guard let data = data else { return }
                do {
                    let request = try JSONDecoder().decode(Ok.self, from: data)
               // print(request)
                } catch {
                    print("Error decoding data: \(error.localizedDescription)")
                }
            }.resume()
        
    }
}
