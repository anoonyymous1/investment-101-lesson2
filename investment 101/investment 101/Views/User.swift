//
//  User.swift
//  investment 101
//
//  Created by Celine Tsai on 1/9/23.
//

import Foundation
import SwiftUI

struct User: Identifiable, Codable{
    var id: Int
    var levelProgress: Int
    var moneyLevel: Int
    var username: String
}
