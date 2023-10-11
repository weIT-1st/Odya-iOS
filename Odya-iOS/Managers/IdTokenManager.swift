//
//  IdTokenManager
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/10/11.
//

import SwiftUI
import FirebaseAuth

class IdTokenManager: ObservableObject{
    @AppStorage("WeITAuthToken") var idToken: String?
    
    func refreshToken() async -> Bool {
        return await withCheckedContinuation{ continuation in
//        withCheckedThrowingContinuation{ continuation in
            let currentUser = Auth.auth().currentUser
            
            currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    self.idToken = nil
                    continuation.resume(returning: false)
                    return
                }
                guard let idToken = idToken else {
                    print("Error: Invalid Token")
                    self.idToken = nil
                    continuation.resume(returning: false)
                    return
                }
                
                // idToken을 이용해 서버 로그인
                self.idToken = idToken
                continuation.resume(returning: true)
            }
        }
    }
}
