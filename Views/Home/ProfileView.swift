//
//  ProfileView.swift
//  CarApp
//
//  Created by VMWare on 18.04.24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var usersManager: UsersManager
    @State private var navigateToFavourites = false
    @State private var navigateToList = false
    @State private var showingDatePicker = false
    @State private var showingActionSheet = false
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var address: String = ""
    @State private var phoneNumber: String = ""
    @State private var birthday: Date = Date()
    @State private var selectedGender: Int = 0
    @State private var carCountry: String = "DE"
    @State private var carBody: String = ""
    @State private var carDrive: String = ""
    @State private var transmission: String = ""
    
    
    
    let carCountries = ["US", "DE", "GB", "FR", "IT", "ES", "CZ", "SE", "RU", "CN", "JP", "KR"]
    let carBodyTypes = ["", "Седан", "Хэтчбек", "Универсал", "Купе", "Кабриолет", "Внедорожник", "Кроссовер", "Минивэн", "Пикап", "Лифтбек", "Лимузин", "Фургон"]
    let carDriveTypes = ["", "FWD", "RWD", "AWD", "4WD", "EV"]
    let transmissionTypes = ["", "Механическая", "Автоматическая", "Роботизированная", "Вариатор", "Полуавтоматическая", "Двухсцепной робот"]
    let genders = ["Мужчина", "Женщина"]
    
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
                NavigationLink(destination: HomeView(), isActive: $navigateToList) {
                    EmptyView()
                }
            
                ScrollView{
                    VStack(spacing: 20){
                        Text("Данные пользователя")
                            .font(.title3)
                            .foregroundColor(.primary)
                    
                        TextField("Имя", text: $firstName)
                            .keyboardType(.alphabet)
                            .frame(height: 55)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding([.horizontal], 20)
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                        
                        TextField("Фамилия", text: $lastName)
                            .keyboardType(.alphabet)
                            .frame(height: 55)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding([.horizontal], 20)
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                        
                        VStack {
                            HStack {
                                Text("Дата рождения: ")
                                    .font(.system(size: 17))
                                
                                Button(action: {
                                
                                    self.showingDatePicker = true
                                }) {
                                    HStack {
                                        Text(birthday, formatter: dateFormatter)
                                            .font(.system(size: 17))
                                            .foregroundColor(.blue)
                                        
                                        Image(systemName: "calendar")
                                            .foregroundColor(.blue)
                                    }
                                }
                                Spacer()
                            }
                        }
                        
                        TextField("Адрес", text: $address)
                            .keyboardType(.alphabet)
                            .frame(height: 55)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding([.horizontal], 20)
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                        
                        TextField("Номер телефона", text: $phoneNumber)
                            .keyboardType(.phonePad)
                            .frame(height: 55)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding([.horizontal], 20)
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                        
                        Text("Пол:")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        
                        HStack {
                           Spacer()
                           Picker("Пол", selection: $selectedGender) {
                               ForEach(0..<genders.count, id: \.self) { index in
                                   Text(self.genders[index])
                               }
                           }
                           .pickerStyle(SegmentedPickerStyle())
                           Spacer()
                        }
                        
                        Text("Предпочтения")
                            .font(.title3)
                            .foregroundColor(.primary)
                        VStack(spacing: 20){
                            HStack {
                                Text("Страна\nпроизводства:")
                                    .frame(width: 150)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(Color.textColor)
                                    .font(.system(size: 17))
                                Spacer()
                                Button(action: {
                                    self.showingActionSheet = true
                                }) {
                                    HStack {
                                        Image("flag_\(carCountry.lowercased())")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 20)
                                        Text(getCountryName(countryCode: carCountry) ?? "Undefined")
                                            .foregroundColor(.black)
                                    }
                                }
                                .frame(width: 200)
                                .sheet(isPresented: $showingActionSheet) {
                                    CountryPickerView(selectedCountryCode: $carCountry, showingActionSheet: $showingActionSheet, countryCodes: carCountries)
                                }
                            
                            }
                            
                            HStack {
                                Text("Тип кузова:")
                                    .frame(width: 150)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(Color.textColor)
                                    .font(.system(size: 17))
                                Spacer()
                                Picker("Выберите тип кузова", selection: $carBody) {
                                    ForEach(carBodyTypes, id: \.self) { bodyType in
                                        Text(bodyType.isEmpty ? "Нет предпочтений" : bodyType).tag(bodyType).foregroundColor(Color.textColor)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(width: 200)
                                .overlay(
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(.gray), alignment: .bottom
                                )
                            }

                            HStack {
                                Text("Тип привода:")
                                    .frame(width: 150)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(Color.textColor)
                                    .font(.system(size: 17))
                                Spacer()
                                Picker("Выберите тип привода", selection: $carDrive) {
                                    ForEach(carDriveTypes, id: \.self) { driveType in
                                        Text(driveType.isEmpty ? "Нет предпочтений" : driveType).tag(driveType)
                                            .foregroundColor(Color.textColor)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(width: 200)
                                .overlay(
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(.gray), alignment: .bottom
                                )
                            }

                            HStack {
                                Text("Коробка\nпередач:")
                                    .frame(width: 150)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(Color.textColor)
                                    .font(.system(size: 17))
                                Spacer()
                                Picker("Выберите тип Коробки передач", selection: $transmission) {
                                    ForEach(transmissionTypes, id: \.self) { transmissionType in
                                        Text(transmissionType.isEmpty ? "Нет предпочтений" : transmissionType).tag(transmissionType)
                                            .foregroundColor(Color.textColor)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(width: 200)
                                .overlay(
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(.gray), alignment: .bottom
                                )
                            }
    
                            HStack {
                                Spacer()
                                Button("Обновить") {
                                    Task{
                                        do{
                                            try await usersManager.updateUserData(firstname: firstName, lastname: lastName, birthday: birthday, gender: genders[selectedGender], address: address, phone: phoneNumber, carCountry: carCountry, carBody: carBody, carDrive: carDrive, transmission: transmission)
                                        } catch {
                                            print(error.localizedDescription)
                                        }
                                    }
                                    navigateToList = true
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(Color.primaryColor)
                                .foregroundColor(.white)
                                .cornerRadius(20)
    
                                Button("Удалить аккаунт") {
                                    Task{
                                        await authManager.deleteUserAuth()
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                                Spacer()
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitle("Профиль", displayMode: .inline)
            .navigationBarItems(
                leading: Image("car_logo").resizable().aspectRatio(contentMode: .fit
                                                            ).frame(width: 50, height: 50),
                trailing: menuButton
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
            

        }
        .sheet(isPresented: $showingDatePicker){
            DatePicker("Выберите дату", selection: $birthday, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 10)
                .padding()
            Button("Готово") {
                self.showingDatePicker = false
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .onAppear(){
            self.loadUserData()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    func loadUserData() {
        if let user = usersManager.currentUserData{
            firstName = user.firstname
            lastName = user.lastname
            address = user.address
            phoneNumber = user.phone
            birthday = user.birthday
            selectedGender = user.gender == genders[0] ? 0 : 1
            carCountry = user.carCountry
            carBody = user.carBody
            carDrive = user.carDrive
            transmission = user.transmission
        }
    }
    
    func getCountryName(countryCode: String) -> String? {
        let locale = Locale(identifier: countryCode)
//        let locale = Locale(identifier: "ru_RU")
        return locale.localizedString(forRegionCode: countryCode)
    }
    
    private var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            return formatter
        }
    
    var menuButton: some View {
        Menu {
            Button(action: handleFavourites) {
                Label("Избранное", systemImage: "heart.fill")
            }
            Button(action: handleList) {
                Label("Список", systemImage: "list.bullet")
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

    func handleList() {
        navigateToList = true
    }

    func handleLogout() {
        authManager.signOut(){error in
            
        }
    }
}

struct CountryPickerView: View {
    @Binding var selectedCountryCode: String
    @Binding var showingActionSheet: Bool
    var countryCodes: [String]

    var body: some View {
        List(countryCodes, id: \.self) { countryCode in
            Button(action: {
                self.selectedCountryCode = countryCode
                self.showingActionSheet = false
            }) {
                HStack {
                    Image("flag_\(countryCode.lowercased())")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 20)
                    Text(getCountryName(countryCode: countryCode) ?? "Undefined")
                        .foregroundColor(.black)
                }
            }
        }
    }
    func getCountryName(countryCode: String) -> String? {
        let locale = Locale(identifier: countryCode)
//        let locale = Locale(identifier: "ru_RU")
        return locale.localizedString(forRegionCode: countryCode)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
