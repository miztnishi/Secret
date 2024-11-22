//
//  ListView.swift
//  Secret
//
//  Created by miztnishi on 2023/12/28
//
//

import SwiftUI
import SwiftData

struct ListView: View {
    @Environment(\.modelContext)  var modelContext
    @Query private var items: [Item]
    
    init(searchString:String ,searchBy:SearchBy = .service ) {
        let predict: Predicate<Item>
        switch searchBy {
        case .service:
            predict = #Predicate<Item>{ item in
                item.service.localizedStandardContains(searchString)
                || searchString.isEmpty
            }
        case .mail:
            predict = #Predicate<Item>{ item in
                item.mail.localizedStandardContains(searchString)
                || searchString.isEmpty
            }
        }
        _items = Query(filter: predict,sort: \.createdAt)
    }
    var body: some View {
        List {
            ForEach(items) { item in
                Section {
                    if item.isShow{
                            HStack{
                                Text("e-mail      ")
                                Text(":")
                                Text(item.mail)
                                    .textSelection(.enabled)
                                Spacer()
                                Button{
                                    UIPasteboard.general.string = item.mail
                                    print(item.mail)
                                } label:{
                                    Image(systemName: "doc.on.doc.fill")
                                }
                            } .contentShape(Rectangle())
                            
                            HStack{
                                Text("password")
                                Text(":")
                                Text(item.password)
                                    .textSelection(.enabled)
                                Spacer()
                                Button{
                                    UIPasteboard.general.string = item.password
                                    print(item.password)
                                } label:{
                                    Image(systemName: "doc.on.doc.fill")
                                }
                            }.contentShape(Rectangle())
                        }
                } header: {
                    Text(item.service)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                item.isShow.toggle()
                            }
                        }
                        .font(.title3)
                }
                
                
            }
            .onDelete(perform: deleteItems)

        }
        .environment(\.defaultMinListHeaderHeight, 20)
        .listStyle(.automatic)
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ListView(searchString:"", searchBy:.service)
        .modelContainer(Item.preview)
}
