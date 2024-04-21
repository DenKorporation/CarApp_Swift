//
//  UsersManager.swift
//  CarApp
//
//  Created by VMWare on 18.04.24.
//

import Foundation
import Firebase

class UsersManager: ObservableObject{
    @Published var currentUserData: UserData?
    private var uid: String?
    private var db = Firestore.firestore()
    
    private var userCollection: CollectionReference {
        return db.collection("users")
    }
    
    init(uid: String?) {
        self.uid = uid
        self.fetchUserData()
    }
    
    func fetchUserData() {
        guard let uid = uid else { return }
        userCollection.document(uid).addSnapshotListener { [weak self] (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            self?.currentUserData = self?.userDataFromSnapshot(data: data, uid: uid)
        }
    }

    private func userDataFromSnapshot(data: [String: Any], uid: String) -> UserData {
        let firstname = data["firstname"] as? String ?? ""
        let lastname = data["lastname"] as? String ?? ""
        let birthdayTimestamp = data["birthday"] as? Timestamp ?? Timestamp(date: Date())
        let birthday = birthdayTimestamp.dateValue()
        let gender = data["gender"] as? String ?? ""
        let address = data["address"] as? String ?? ""
        let phone = data["phone"] as? String ?? ""
        let carCountry = data["carCountry"] as? String ?? ""
        let carBody = data["carBody"] as? String ?? ""
        let carDrive = data["carDrive"] as? String ?? ""
        let transmission = data["transmission"] as? String ?? ""
        let favCars = data["favouriteCars"] as? [String] ?? []

        return UserData(uid: uid, firstname: firstname, lastname: lastname,
                        birthday: birthday, gender: gender, address: address,
                        phone: phone, carCountry: carCountry, carBody: carBody,
                        carDrive: carDrive, transmission: transmission, favCars: favCars)
    }
    
    func createUserData() async throws {
        guard let uid = uid else { return }
        let userData = [
            "firstname": "",
            "lastname": "",
            "birthday": Timestamp(date: Date()),
            "gender": "Мужчина",
            "address": "",
            "phone": "",
            "carCountry": "DE",
            "carBody": "",
            "carDrive": "",
            "transmission": "",
            "favouriteCars": []
        ] as [String : Any]
        try await userCollection.document(uid).setData(userData)
    }

    func updateUserData(firstname: String, lastname: String, birthday: Date, gender: String,
                        address: String, phone: String, carCountry: String, carBody: String,
                        carDrive: String, transmission: String) async throws {
        guard let uid = uid else { return }
        let userData = [
            "firstname": firstname,
            "lastname": lastname,
            "birthday": Timestamp(date: birthday),
            "gender": gender,
            "address": address,
            "phone": phone,
            "carCountry": carCountry,
            "carBody": carBody,
            "carDrive": carDrive,
            "transmission": transmission
        ] as [String : Any]
        try await userCollection.document(uid).updateData(userData)
    }

    func updateUserFavCars(favCars: [String]) async throws {
        guard let uid = uid else { return }
        try await userCollection.document(uid).updateData(["favouriteCars": favCars])
    }

    func deleteUserData() async throws {
        guard let uid = uid else { return }
        try await userCollection.document(uid).delete()
    }
}
