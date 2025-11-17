//
//  EmployeeRegistrationView.swift
//  EmployeeHub
//
//  Created by Husnain on 05/11/2025.
//

import SwiftUI
import PhotosUI




struct EmployeeRegistrationView: View {
    
    
    @ObservedObject var employee : Employee
    
    //    @State private var selectedItem : PhotosPickerItem?
    //    @State private var selectedImage : UIImage?
    @State private var showPicker = false
    @State private var showCamera = false
    @State private var showChoiceSheet = false
    
    var employeeService = EmployeeService()
    
    @FocusState.Binding var fieldFocused : Bool
    
    
    //checking validations
    func checkValidations() -> Bool{
        return false
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
