//
//  ContentView.swift
//  Secret
//
//  Created by miztnishi on 2023/12/26
//
//

/*
課金要素
    - 6以上は課金
    - 200円のサブスク
    - +ボタンを押した時の広告表示をなくす
    - 画面下部に広告エリアを非表示
無課金の場合
    - +ボタンを押した時に広告を出す
    - 画面下部に広告エリアを表示
    - 5個まで登録可
*/
//アプリ公開まで https://yakkylab.com/app-process-all/#toc12
//admob : https://admob.google.com/intl/ja/home/



import SwiftUI
import SwiftData
import LocalAuthentication


enum SearchBy:String,Identifiable,CaseIterable,Codable  {
    case service,mail
    var id: Self{self}
}

struct ContentView: View {
    @Environment(\.modelContext)  var modelContext
    @Query private var items: [Item]
    @State private var isShowSheet = false
    @State private var isShowSearchArea = false
    @State private var searchString = ""
    @State private var searchBy = SearchBy.service
    @StateObject var faceAuth = FaceAuth()
    
    var body: some View {
        NavigationStack {
            VStack{
                if isShowSearchArea{
                    HStack() {
                        Picker("",selection: $searchBy){
                            ForEach(SearchBy.allCases){ by in
                                Text(by.rawValue).tag(searchBy.rawValue)
                            }
                        }
                        .pickerStyle(.palette)
                        Text(":")
                        TextField("search", text: $searchString)
                            .padding(.leading,5)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(15)
                    }
//                    .frame(height: 10)
                    .font(.title2)
                }
                ListView(searchString: searchString, searchBy: searchBy)
            }
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        closeItem()
                        isShowSearchArea.toggle()
                        searchString =  ""
                        
                    }) {
                        Label("search", systemImage: "magnifyingglass")
                    }
                }
                ToolbarItem {
                    Button(action: {self.isShowSheet.toggle()}) {
                        Label("Add Item", systemImage: "plus")
                            .sheet(isPresented: $isShowSheet) {
                                CreateItemView().presentationDetents([.medium])
                            }
                    }
                }
                ToolbarItem {
                    Button(action: closeItem) {
                        Label("close all", systemImage: "book.closed")
                    }
                }
                ToolbarItem {
                    EditButton()
                }
            }
            .onDisappear(){
                closeItem()
            }
            .onAppear(){
                faceAuth.authStateChanger()
            }
            //アクティブ時
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { notification in
                
                closeItem()
                faceAuth.authStateChanger()
            }
            //バックグランド時
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { notification in
                
                closeItem()
            }
        }
        
    }

    func closeItem() {
        withAnimation {
            items.forEach({item in item.isShow = false})
            try? modelContext.save()
        }
    }
}

#Preview {
    ForEach(["en", "ja"], id: \.self) { id in
        
        ContentView()
            .modelContainer(Item.preview)
            .environment(\.locale, .init(identifier: id))
    }
}
