//
//  ToDo.swift
//  TestTableView
//
//  Created by Elizabeth Yeh on 12/18/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import Foundation

class ToDo
{
    var itemDescription: String
    var isComplete: Bool
    
    init (itemDescription: String, isComplete: Bool)
    {
        self.itemDescription = itemDescription
        self.isComplete = isComplete
    }
}
