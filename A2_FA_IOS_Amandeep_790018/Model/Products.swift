//
//  Products.swift
//  A2_FA_IOS_Amandeep_790018
//
//  Created by user191884 on 2/1/21.
//

import Foundation


class  Products{
    var id: Int
    var name: String
    var describe: String
    var price: Int
    var provider: String
    
    init(id: Int, name: String, describe: String, price: Int, provider: String) {
        self.id = id
        self.name = name
        self.describe = describe
        self.price = price
        self.provider = provider
    }
}
