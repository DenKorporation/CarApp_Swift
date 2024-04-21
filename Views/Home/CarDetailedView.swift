//
//  CarDetailed.swift
//  CarApp
//
//  Created by VMWare on 19.04.24.
//

import SwiftUI

import SwiftUI
import FirebaseStorage
import Combine

struct CarDetailedView: View {
    let car: Car
    let folderPath: String
    @State private var imageUrls = [String]()
    @State private var isLoading = true
    @State private var selectedTab: Int = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                VStack(alignment: .center){
                    Text(car.name)
                        .font(.title)
                    Text(car.years)
                        .font(.subheadline)
                }
                if isLoading {
                    ProgressView()
                        .frame(height: 200)
                } else {
                    TabView(selection: $selectedTab) {
                                ForEach(Array(imageUrls.enumerated()), id: \.element) { index, url in
                                    AsyncImage(url: URL(string: url)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(height: 200)
                                    .tag(index)
                                }
                            }
                            .tabViewStyle(PageTabViewStyle())
                            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                            .frame(height: 200)
                }
                
                Text("Описание")
                    .font(.title)
                Text(car.description)
                    .font(.subheadline)
                
                Spacer(minLength: 10)
                
                HStack {
                    Text("Страна")
                        .font(.subheadline)
                    Spacer()
                    Image("flag_\(car.country.lowercased())")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 50)
                }
                
                HStack {
                    Text("Кузов")
                        .font(.subheadline)
                    Spacer()
                    Text(car.body.replacingOccurrences(of: "/", with: "\n"))
                        .multilineTextAlignment(.trailing)
                        .font(.subheadline)
                }
                
                HStack {
                    Text("Привод")
                        .font(.subheadline)
                    Spacer()
                    Text(car.drive)
                        .multilineTextAlignment(.trailing)
                        .font(.subheadline)
                }
                
                HStack {
                    Text("Коробка передач")
                        .font(.subheadline)
                    Spacer()
                    Text(car.transmission.replacingOccurrences(of: "/", with: "\n"))
                        .multilineTextAlignment(.trailing)
                        .font(.subheadline)
                }
            }
            .padding()
        }
        .background(Color.backgroundColor)
        .onAppear(perform: loadImages)
    }
    
    private func loadImages() {
        isLoading = true
        let ref = Storage.storage().reference(withPath: folderPath)
        ref.listAll { (result, error) in
            if let error = error {
                print("Failed with error: \(error.localizedDescription)")
                isLoading = false
            } else {
                for item in result?.items ?? [] {
                    item.downloadURL { url, error in
                        if let url = url {
                            imageUrls.append(url.absoluteString)
                        }
                        if item == result!.items.last {
                            isLoading = false
                        }
                    }
                }
            }
        }
    }
}

struct CarDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        CarDetailedView(car: Car(uid: "", name: "name", years: "years", description: "description", country: "country", body: "body", drive: "drive", transmission: "transmission"), folderPath: "")
    }
}
