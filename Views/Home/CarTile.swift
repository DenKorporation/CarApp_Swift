//
//  CarTile.swift
//  CarApp
//
//  Created by VMWare on 19.04.24.
//

import SwiftUI

struct CarTile: View {
    @EnvironmentObject var usersManager: UsersManager
    let car: Car
    var userData: UserData?
    @State private var showDetails = false

    var body: some View {
        VStack {
            HStack {
                PreviewImage(path: "\(car.name)/preview.jpg")
                    .frame(width: 100)
                
                VStack(alignment: .leading) {
                    Text(car.name)
                        .font(.headline)
                        
                    Text(car.years)
                        .font(.subheadline)
                }
                .foregroundColor(Color.textColor)
                
                Spacer()
                
                Button(action: {
                    Task{
                        await toggleFavorite()
                    }
                }) {
                    Image(systemName: car.isFav ? "heart.fill" : "heart")
                        .foregroundColor(Color.black)
                }
            }
            .padding()
            .background(Color.white)
            .onTapGesture {
                self.showDetails = true
            }
            .sheet(isPresented: $showDetails) {
                CarDetailedView(car: car, folderPath: "\(car.name)/detailed_photos")
            }
            .cornerRadius(10)
            .shadow(radius: 2)
        }
    }

    private func toggleFavorite() async {
        if let index = userData?.favCars.firstIndex(of: car.uid) {
            userData?.favCars.remove(at: index)
        } else {
            userData?.favCars.append(car.uid)
        }
        do{
            try await usersManager.updateUserFavCars(favCars: userData!.favCars)
        }catch{
            print(error.localizedDescription)
        }
    }
}

//struct CarTile_Previews: PreviewProvider {
//    static var previews: some View {
//        CarTile()
//    }
//}
