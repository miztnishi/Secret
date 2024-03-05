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
    
    init(service:String, mail:String,password:String ,isShow:Bool = false ) {    
        self.mail = mail
        self.password = password
        self.service =  service
        self.isShow = isShow
    }
}
