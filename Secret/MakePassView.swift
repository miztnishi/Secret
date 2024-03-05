//
//  MakePassView.swift
//  Secret
//
//  Created by miztnishi on 2024/01/06
//
//
//抽象化 :https://qiita.com/ukit-tokyo/items/7d77049d139324013bf3


import SwiftUI

struct MakePassView: View {
    @State var isPassLowCase = false
    @State var isPassUpperCase = false
    @State var isPassNumber = false
    @State var isPassSymbol = false
    var numerList = [8,10,12,14,16,24,32]
    @State var selectedNumer = 8
    @State var genaratedStrList:[String] = []
    @Environment(\.dismiss) var dismiss
    @Binding var selectedPassWord:String
    
    
    var body: some View {
        //        Text("s")
        VStack{
            Text("パスワードに含める文字種")
                .font(.headline)
                .padding(5)
            HStack{
                passwordkindsText(tittle: "英字(小)", subTitle: "abc...", isOn: $isPassLowCase)
                passwordkindsText(tittle: "英字(大)", subTitle: "ABC...", isOn: $isPassUpperCase)
                passwordkindsText(tittle: "数字", subTitle: "123...", isOn: $isPassNumber)
                passwordkindsText(tittle: "記号", subTitle: "/-*+!#...", isOn: $isPassSymbol)

            }
            .padding(5)
            
            
            VStack{
                Text("パスワードの文字数")
                    .font(.headline)
                Picker("",selection: $selectedNumer){
                    ForEach(numerList,id:\.self ){ num in
                        Text("\(num)")
                    }
                }
                .pickerStyle(.palette)
                
            }
            .padding(5)
            
            VStack(alignment: .center){
                Button("パスワード候補を生成", action: {
                    self.genaratedStrList = []
                    generatePassword()
                }).disabled(isPassLowCase || isPassUpperCase || isPassNumber || isPassSymbol ? false  : true )
            }
            .padding(5)
            
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) { // カラム数の指定
                    ForEach(genaratedStrList, id: \.self) { passString in
                        Text("\(passString)")
                            .frame(width: 180,height: 100)
                            .background(.gray.opacity(0.1))
                            .cornerRadius(10)
                            .onTapGesture {
                                selectedPassWord = passString
                                dismiss()
                            }
                    }
                }
            }
        }
        
    }
    func generatePassword(){
        var letter = ""
        if isPassLowCase {
            letter += "abcdefghijklmnopqrstuvwxyz"
        }
        if isPassUpperCase {
            letter += "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        }
        if isPassNumber {
            letter += "0123456789"
        }
        if isPassSymbol{
            letter += "/*-+.,#$%&()~|_@"
        }
        
        
        
        //８件候補を作成
        for _ in 0..<8{
            var result = ""
            for _ in 0 ..< selectedNumer {
                result += String(letter.randomElement()!)
            }
            genaratedStrList.append(result)
            
        }
    }
}



#Preview {
    MakePassView(selectedPassWord:.constant("test"))
}

struct passwordkindsText: View {
    let tittle:String
    let subTitle:String
    @Binding var  isOn:Bool
    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .leading){
                    Text(tittle)
                        .font(.footnote)
                        .bold()
                        .underline(color: .gray.opacity(0.8))
                    Text(subTitle)
                        .font(.footnote)
                        .foregroundColor(.blue)
                }.frame(width: 50)
                Toggle("", isOn: $isOn)
                    .toggleStyle(CheckBoxToggleStyle())
            }
        }
    }
}

struct CheckBoxToggleStyle:ToggleStyle{
    func makeBody(configuration: Configuration) -> some View {
        Button{
            configuration.isOn.toggle()
        } label: {
            HStack{
                configuration.label
                Spacer()
                Image(systemName: configuration.isOn
                      ? "checkmark.circle.fill"
                      : "circle")
                .foregroundColor(.blue)
            }
        }
    }
}

