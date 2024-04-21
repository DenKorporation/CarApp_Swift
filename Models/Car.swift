//
//  Car.swift
//  CarApp
//
//  Created by VMWare on 17.04.24.
//

import Foundation

class Car: Identifiable, Codable, Hashable {
    
    let uid: String
    let name: String
    let years: String
    let description: String
    let country: String
    let body: String
    let drive: String
    let transmission: String

    var isFav: Bool = false

    init(uid: String, name: String, years: String, description: String, country: String, body: String, drive: String, transmission: String) {
        self.uid = uid
        self.name = name
        self.years = years
        self.description = description
        self.country = country
        self.body = body
        self.drive = drive
        self.transmission = transmission
    }
    
    static func == (lhs: Car, rhs: Car) -> Bool {
        return lhs.uid == rhs.uid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
}
