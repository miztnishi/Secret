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
    
    init(searchString:String ,searchBy:SearchBy ) {
        let predict = switch searchBy {
        case .service:
            #Predicate<Item>{ item in
                item.service.localizedStandardContains(searchString)
                || searchString.isEmpty
            }
            
        case .mail:
            #Predicate<Item>{ item in
                item.mail.localizedStandardContains(searchString)
                || searchString.isEmpty
            }
        }
        _items = Query(filter: predict)
    }
    var body: some View {
        List {
            ForEach(items) { item in
                Section {
                    if item.isShow{
                        VStack(alignment: .leading){
                            HStack{
                                Text("e-mail      ")
                                Text(":")
                                Text(item.mail)
                                    .textSelection(.enabled)
                            }
                            Divider()
                            HStack{
                                Text("password")
                                Text(":")
                                Text(item.password)
                                    .textSelection(.enabled)
                            }
                        }
                    }
                } header: {
                    Text(item.service)
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
        .listStyle(.plain)
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
        .modelContainer(for: Item.self, inMemory:  false)
}
