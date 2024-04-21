//
//  CarList.swift
//  CarApp
//
//  Created by VMWare on 19.04.24.
//

import SwiftUI

struct CarList: View {
    @EnvironmentObject var carsManager: CarsManager
    @EnvironmentObject var usersManager: UsersManager
    let onlyFavourites: Bool
    @State private var cars: [Car] = []
    
    var body: some View {
        let cars = filteredCars
        
//        List(cars) { car in
//            CarTile(car: car, userData: usersManager.currentUserData)
//
//        }
        ScrollView {
            VStack(spacing: 20) {
                ForEach(cars, id: \.self) { car in
                    CarTile(car: car, userData: usersManager.currentUserData)
                }
            }
            .padding() 
        }
        
    }
    
    private var filteredCars: [Car] {
        var cars = carsManager.cars
        
        if let favCars = usersManager.currentUserData?.favCars {
            for i in 0..<cars.count {
                cars[i].isFav = favCars.contains(cars[i].uid)
            }
        }
        
        if onlyFavourites {
            cars = cars.filter { $0.isFav }
        }
        
        return cars
    }
}

struct CarList_Previews: PreviewProvider {
    static var previews: some View {
        CarList(onlyFavourites: false)
    }
}
