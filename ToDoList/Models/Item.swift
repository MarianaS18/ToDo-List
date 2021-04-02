//
//  Item.swift
//  ToDoList
//
//  Created by Mariana Steblii on 02/04/2021.
//

import Foundation

struct Item: Codable {
    var title: String = ""
    var done: Bool = false
}