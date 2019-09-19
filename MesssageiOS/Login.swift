//
//  Login.swift
//  MesssageiOS
//
//  Created by Ye Yongping on 2019/9/11.
//  Copyright © 2019 Yeyongping. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var chatModel: ChatModel
    @State var account: String  = ""
    @State var passwd: String  = ""
    var body: some View {
        VStack {
            TextField("账号", text: $account)
                .frame(height: 50, alignment: .center)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("密码", text: $passwd)
                .frame(height: 50, alignment: .center)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
                request(account: self.account, passwd: self.passwd) { (result) in
                    switch result {
                    case .success(let token):
                        self.chatModel.storeToken(token: token)
                    case .failure(let err):
                        print(err)
                    }
                }

            }) {
                Text("登录")
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
            }
        }
    }
}

#if DEBUG
struct Login_Previews : PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(ChatModel())
    }
}
#endif
