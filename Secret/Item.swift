//
//  Item.swift
//  Secret
//
//  Created by miztnishi on 2023/12/26
//
//

import Foundation
import SwiftData



@Model
final class Item {
    
    var service:String
    var mail:String
    var password:String
    var isShow:Bool
    var createdAt:Date
    
    init(service:String, mail:String,password:String ,isShow:Bool = false) {
        self.mail = mail
        self.password = password
        self.service =  service
        self.isShow = isShow
        self.createdAt = Date()
    }
}

extension Item {
    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(
            for: Item.self,
            configurations: ModelConfiguration(
                isStoredInMemoryOnly: true
            )
        )
        var samples: [Item] {
            [
                // sample datas
                Item(service:"service1", mail:"mail1",password:"password"),
                Item(service:"service2", mail:"mail2",password:"password"),
                Item(service:"service3", mail:"mail3",password:"password"),
                Item(service:"service4", mail:"mail4",password:"password"),
                Item(service:"service5", mail:"mail5",password:"password"),
                Item(service:"service6", mail:"mail6",password:"password",isShow: true),
                
            ]
        }
        
        samples.forEach { sample in
            container.mainContext.insert(sample)
        }
        
        return container
    }
}
