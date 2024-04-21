//
//  UserData.swift
//  CarApp
//
//  Created by VMWare on 17.04.24.
//

import Foundation

class UserData {
    let uid: String
    let firstname: String
    let lastname: String
    let birthday: Date
    let gender: String
    let address: String
    let phone: String
    let carCountry: String
    let carBody: String
    let carDrive: String
    let transmission: String
    var favCars: [String]

    init(uid: String, firstname: String, lastname: String, birthday: Date, gender: String, address: String, phone: String, carCountry: String, carBody: String, carDrive: String, transmission: String, favCars: [String]) {
        self.uid = uid
        self.firstname = firstname
        self.lastname = lastname
        self.birthday = birthday
        self.gender = gender
        self.address = address
        self.phone = phone
        self.carCountry = carCountry
        self.carBody = carBody
        self.carDrive = carDrive
        self.transmission = transmission
        self.favCars = favCars
    }
}
