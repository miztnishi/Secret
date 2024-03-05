//
//  ContentView.swift
//  Secret
//
//  Created by miztnishi on 2023/12/26
//
//




import SwiftUI
import SwiftData
import LocalAuthentication


enum SearchBy:String,Identifiable,CaseIterable  {
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
                    .frame(height: 10)
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
                ToolbarItem {
                    Button(action: closeItem) {
                        Label("setting", systemImage: "gearshape.fill")
                    }
                }
            }
            .onDisappear(){
                closeItem()
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
    ContentView()
        .modelContainer(for: Item.self, inMemory:  false)
}
