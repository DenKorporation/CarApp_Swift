//
//  CarsManager.swift
//  CarApp
//
//  Created by VMWare on 18.04.24.
//

import Foundation
import Firebase

class CarsManager: ObservableObject{
    @Published var cars: [Car] = []
    private var uid: String?
    private var db = Firestore.firestore()

    init(uid: String?) {
        self.uid = uid
        self.setupCarsStateListener()
    }
    
    private func setupCarsStateListener() {
        db.collection("cars").addSnapshotListener { [weak self] (querySnapshot, error) in
            if let snapshot = querySnapshot {
                self?.cars = self?.carListFromSnapshot(snapshot) ?? []
            } else if let error = error {
                self?.cars = []
                print("Error getting car documents: \(error)")
            }
        }
    }
    
    private func carListFromSnapshot(_ snapshot: QuerySnapshot?) -> [Car] {
            guard let snapshot = snapshot else { return [] }
            
            var cars = [Car]()
            for document in snapshot.documents {
                let data = document.data()
                let uid = document.documentID
                if let name = data["name"] as? String,
                   let years = data["years"] as? String,
                   let description = data["description"] as? String,
                   let country = data["country"] as? String,
                   let body = data["body"] as? String,
                   let drive = data["drive"] as? String,
                   let transmission = data["transmission"] as? String {
                    
                    let car = Car(uid: uid, name: name, years: years, description: description,
                                  country: country, body: body, drive: drive, transmission: transmission)
                    cars.append(car)
                }
            }
            return cars
        }
}
