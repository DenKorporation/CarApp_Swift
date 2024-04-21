//
//  HomeView.swift
//  CarApp
//
//  Created by VMWare on 17.04.24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var navigateToFavourites = false
    @State private var navigateToSettings = false
    
    init() {
      let coloredAppearance = UINavigationBarAppearance()
      coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = primaryColor
        coloredAppearance.titleTextAttributes = [.foregroundColor: secondaryColor]
      coloredAppearance.largeTitleTextAttributes = [.foregroundColor: secondaryColor]
      
      UINavigationBar.appearance().standardAppearance = coloredAppearance
      UINavigationBar.appearance().compactAppearance = coloredAppearance
      UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
      
      UINavigationBar.appearance().tintColor = .white
    }
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: FavouritesView(), isActive: $navigateToFavourites) {
                    EmptyView()
                }
                NavigationLink(destination: ProfileView(), isActive: $navigateToSettings) {
                    EmptyView()
                }
                
                CarList(onlyFavourites: false)
            }
            .navigationBarTitle("Все машины", displayMode: .inline)
            .navigationBarItems(
                leading: Image("car_logo").resizable().aspectRatio(contentMode: .fit
                                                            ).frame(width: 50, height: 50),
                trailing: menuButton
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
            

        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    
    var menuButton: some View {
        Menu {
            Button(action: handleFavourites) {
                Label("Избранное", systemImage: "heart.fill")
            }
            Button(action: handleSettings) {
                Label("Профиль", systemImage: "gearshape")
            }
            Button(action: handleLogout) {
                Label("Выйти", systemImage: "rectangle.portrait.and.arrow.right")
            }
            
        } label: {
            HStack {
                Image(systemName: "line.horizontal.3")
                    .foregroundColor(Color.secondaryColor)
                Text("Меню")
                    .foregroundColor(Color.secondaryColor)
            }
        }
    }
    
    func handleFavourites() {
        navigateToFavourites = true
    }

    func handleSettings() {
        navigateToSettings = true
    }

    func handleLogout() {
        authManager.signOut(){error in
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AuthManager())
    }
}
