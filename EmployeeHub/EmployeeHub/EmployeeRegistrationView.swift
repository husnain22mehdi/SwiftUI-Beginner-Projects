//
//  EmployeeRegistrationView.swift
//  EmployeeHub
//
//  Created by Husnain on 05/11/2025.
//

import SwiftUI
import PhotosUI


//enum FieldIsEmpty : Bool {
//    case name
//    case userName
//    case passowrd
//    case designation
//}

enum EmployeeAlert : Identifiable{
    
    case emptyField(fieldName: String)
    case invalidUsername
    case invalidPassword
    case noImage
    case success
    
    var id : UUID {
        switch self {
        case .emptyField(let fieldName):
            return UUID()
        case .invalidUsername:
            return UUID()
        case .invalidPassword:
            return UUID()
        case .noImage:
            return UUID()
        case .success:
            return UUID()
        }
    }
    
    var message : String {
        switch self {
        case .emptyField(let fieldName):
            return "\(fieldName) can't be empty!"
        case .invalidUsername:
            return "Invalid username format!"
        case .invalidPassword:
            return "Invalid password format!"
        case .noImage:
            return "Profile picture required for sign up!"
        case .success:
            return "Sign up is completed!"
        }
    }
    
    var title : String {
        switch self {
        case .success:
            return "Success"
        default:
            return "Registration Failed"
        }
    }
}


struct EmployeeRegistrationView: View {
    
    
    @ObservedObject var employee : Employee
    
    //    @State private var selectedItem : PhotosPickerItem?
    //    @State private var selectedImage : UIImage?
    @State private var showPicker = false
    @State private var showCamera = false
    @State private var showChoiceSheet = false
    @State private var emptyField = ""
    
    var employeeService = EmployeeService()
    
    @FocusState.Binding var fieldFocused : Bool

    @State private var showingAlert = false
    @State private var alertToShow : EmployeeAlert?
    
//    //enum for custom alert messages
//    enum AlertMessage : String {
//        case fieldEmpty = " can't be empty!"
//        case invalidUserName = "Invalid username format!"
//        case invalidPassword = "Invalid password format!"
//        case success = "Sign up is completed!"
//    }
    
    
    func fieldsNotEmpty() -> Bool {
        if employee.employeeFullName.isEmpty {
            emptyField = "Name"
            return false
        }
        else if employee.userName.isEmpty {
            emptyField = "Username"
            return false
        }
        else if employee.password.isEmpty {
            emptyField = "Password"
            return false
        }
        else if employee.designation.isEmpty {
            emptyField = "Designation"
            return false
        }
        else if employee.department.isEmpty {
            emptyField = "Department"
            return false
        }
        else {
            return true
        }
    }
    
    func validUserName() -> Bool {
        return employee.userName.count > 8
    }
    
    func validPassword() -> Bool {
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: employee.password)
    }
    
    func validProfileImage() -> Bool {
        if let img = employee.profileImg{
            return true
        }
        return false
    }
    
    //checking validations
    func validateData() -> Bool{
        if !fieldsNotEmpty() {
            alertToShow = .emptyField(fieldName: emptyField)
            return false
        }
        if !validUserName() {
            alertToShow = .invalidUsername
            return false
        }
        if !validPassword() {
            alertToShow = .invalidPassword
            return false
        }
        if !validProfileImage() {
            alertToShow = .noImage
            return false
        }
        alertToShow = .success
        return true
    }
    
    
    var body: some View {
        
        NavigationStack{
            //1st vstack
            VStack(spacing: 20){
                
                Spacer()
                    .frame(height: 30)
                
                Text("Add Profile Picture")
                    .font(.headline)
                
                //2nd vstack
                VStack{
                    if let img = employee.profileImg {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 140)
                            .clipShape(Circle())
                    }
                    else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .opacity(0.7)
                            .frame(width: 140, height: 140)
                        //                            .border(.black)
                    }
                }
                //                    Button("Add Profile Pic") {
                //                        showChoiceSheet = true
                //                    }
                .onTapGesture {
                    showChoiceSheet = true
                }
                .actionSheet(isPresented: $showChoiceSheet){
                    
                    var buttons : [ActionSheet.Button] =
                    [
                        .default(Text("Camera")) {showCamera = true},
                        .default(Text("Photo Library")) {showPicker = true},
                        .cancel()
                    ]
                    
                    
                    if employee.profileImg != nil {
                        buttons.insert(.destructive(Text("Delete")) {employee.profileImg = nil}, at: 2)
                    }
                    
                    return ActionSheet(title: Text("Select Image"), message: nil, buttons: buttons)
                }
                //2nd vstack
                
                EmployeeRegistrationFormView(employee: employee, fieldFocused: $fieldFocused)
                
            }
            .sheet(isPresented: $showPicker){
                ImagePicker(sourceType: .photoLibrary, selectedImage: $employee.profileImg)
            }
            .sheet(isPresented: $showCamera){
                ImagePicker(sourceType: .camera, selectedImage: $employee.profileImg)
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Save"){
                        
                        if validateData(){
                            employeeService.saveEmployee(employee){ success in
                                if success{
                                    print("Employee Added to firebase")
                                }
                                else{
                                    print("Error adding employee to firebase")
                                }
                            }
                        }
                                              
                    }
                }
                ToolbarItemGroup(placement: .keyboard){
                    Spacer()
                    Button("Done"){
                        fieldFocused = false
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .navigationTitle("Register Employee")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGray6))
            .alert(item: $alertToShow){ alert in
                
                Alert(title: Text(alert.title), message: Text(alert.message), dismissButton: .cancel())
            }
            //1st vstack
        }
        //navigation stack
    }
    //body


}
//struct

//#Preview {
//    EmployeeRegistrationView(employee: Employee(), fieldFocused: $fieldFocused)
//}
