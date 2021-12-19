//
//  Alamofire.swift
//  SGS_SideProject
//
//  Created by 한상혁 on 2021/12/19.
//

import Foundation
import Alamofire

enum APIErrors: Error {
    case custom(message: String)
}

//// Alamofire Get
//func getTest() {
//    let url = "https://jsonplaceholder.typicode.com/todos/1"
//    AF.request(url,
//               method: .get,
//               parameters: nil,
//               encoding: URLEncoding.default,
//               headers: ["Content-Type": "application/json", "Accept": "application/json"])
//        .validate(statusCode: 200..<300)
//        .responseJSON { (json) in
//            print(json)
//        }
//}

func RegistrationService(email: String, password: String, completion: @escaping (_ itOK: Bool) -> Void) {
    let url = "http://127.0.0.1/adduser"
    var request = URLRequest(url: URL(string: url)!)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.timeoutInterval = 10
    
    // POST로 보낼 정보
    let params = ["email": email, "password": password] as Dictionary
    
    // httpBody에 parameters 추가
    do {
        try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
    } catch {
        print("http Body Error")
    }
    
    // StatusCode 결과
    AF.request(request).responseString() { (response) in
        switch response.result {
        case .success:
            if let httpStatusCode = response.response?.statusCode {
                switch(httpStatusCode){
                case 200:
                    print("회원가입 성공!")
                    completion(true)
                case 409:
                    print("중복된 이메일이 있습니다!!")
                    completion(false)
                default:
                    print("디폴트...")
                    completion(false)
                }
            }
        case .failure(let error):
            print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
        }
    }
}

func LoginService(email: String, password: String, completion: @escaping (_ itOK: Bool) -> Void
) {
    let url = "http://127.0.0.1/loginuser"
    var request = URLRequest(url: URL(string: url)!)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.timeoutInterval = 10
    
    // POST로 보낼 정보
    let params = ["email": email, "password": password] as Dictionary
    
    // httpBody에 parameters 추가
    do {
        try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
    } catch {
        print("http Body Error")
    }
    
    // StatusCode 결과
    AF.request(request).responseString() { (response) in
        switch response.result {
        case .success:
            if let httpStatusCode = response.response?.statusCode {
                switch(httpStatusCode){
                case 200:
                    print("로그인 성공!")
                    completion(true)
                case 401:
                    print("이메일이나 비밀번호가 틀림!")
                    completion(false)
                default:
                    print("디폴트...")
                    completion(false)
                }
            }
        case .failure(let error):
            print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
        }
    }
}


