//
//  HPManager.swift
//  Harry Potter Wiki
//
//  Created by Halil Ibrahim Andic on 3.01.2023.

import Foundation

//Setup model for incoming data
struct HPModel: Codable {
    let name, description, house, effect: String?
}
