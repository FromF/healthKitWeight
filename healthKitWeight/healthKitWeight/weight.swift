//
//  weight.swift
//  healthKitWeight
//
//  Created by 藤　治仁 on 2019/03/11.
//  Copyright © 2019 FromF.github.com. All rights reserved.
//

import UIKit

class weight: NSObject {
    var date:Date?
    var value:Double?
    
    init(date:String , value:String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.locale = Locale(identifier: "ja_JP")
        self.date = formatter.date(from: date)
        self.value = Double(value)
    }
}
