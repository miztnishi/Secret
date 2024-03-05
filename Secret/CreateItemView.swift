//
//  CreateItemView.swift
//  Secret
//
//  Created by miztnishi on 2023/12/27
//
//

import SwiftUI
import SwiftData

struct CreateItemView: View {
    @Environment(\.modelContext)  var modelContext
    @State var item:Item = Item(service: "", mail: "", password: "")
    @Environment(\.dismiss) var dismiss
    @State var isShowSheet = false
    var body: some View {
        VStack{
            
            Text("サービス登録")
                .font(.title)
            
            HStack{
                Text("service    ")
                Text(":")
                TextField("service", text: $item.service)
                    .multilineTextAlignment(.leading)
                    .background(Color.gray.opacity(0.1))
            }
            
            HStack{
                Text("e-mail      ")
                Text(":")
                TextField("e-mail", text: $item.mail)
                    .multilineTextAlignment(.leading)
                    .background(Color.gray.opacity(0.1))
            }
            
            
            HStack{
                Text("password")
                Text(":")
                TextField("password", text: $item.password)
                    .multilineTextAlignment(.leading)
                    .background(Color.gray.opacity(0.1))
            }
        

            VStack{
            Button(action: {self.isShowSheet = true}, label: {
                Text("パスワードを自動生成する")
                    .sheet(isPresented: $isShowSheet) {
                        MakePassView( selectedPassWord: $item.password).presentationDetents([.medium])
                    }
            })
            .padding(5)
            Button(action: {
                modelContext.insert(item)
                dismiss()
            }, label: {
                Text("登録")
            })
            .padding(5)
            .foregroundColor(.white)
            .background(item.mail.isEmpty || item.password.isEmpty || item.service.isEmpty ? .gray : .blue)
            .clipShape(.capsule)
            .disabled(item.mail.isEmpty || item.password.isEmpty || item.service.isEmpty ? true :false)
            }
        }
        .padding()
    }
}



#Preview {
    CreateItemView(item: Item( service: "", mail: "",password: ""))
        
}
