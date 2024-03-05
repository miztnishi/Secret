//
//  faceAuth.swift
//  Secret
//  
//  Created by miztnishi on 2023/12/28
//  
//

import Foundation
import LocalAuthentication

enum AuthenticationState {
    case loggedin
    case loggedout
}

final class FaceAuth: ObservableObject {
    @Published private(set) var state: AuthenticationState = .loggedout
    var context: LAContext = LAContext()
    let reason = "Face IDを使用する場合は設定より\nアクセスの許可を変更してください。"
    @MainActor
    func authStateChanger() {
        if state == .loggedin {
            state = .loggedout
        } else {
            context = LAContext()
            context.localizedCancelTitle = "パスワード入力で認証を行う"
            var error: NSError?
            guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
                print(error?.localizedDescription ?? "このデバイスでは生体認証を行うことができません")
                return
            }
            Task {
                do {
                    try await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason)
                    state = .loggedin
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
