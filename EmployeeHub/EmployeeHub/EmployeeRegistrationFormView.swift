//
//  EmployeeRegistrationFormView.swift
//  EmployeeHub
//
//  Created by Husnain on 06/11/2025.
//

import SwiftUI

struct EmployeeRegistrationFormView: View {
    
    @ObservedObject var employee : Employee
    
    @FocusState.Binding var fieldFocused : Bool
    
    var body: some View {
        
        Form{
            Section("Name"){
                HStack(){
                    TextField("First Name", text: $employee.firstName)
                    //                                .frame(width: 30)
                        .focused($fieldFocused)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: .infinity)
                    TextField("Middle Name", text: Binding(
                        get: { employee.middleName ?? "" },
                        set: { employee.middleName = $0.isEmpty ? nil : $0 }
                    )
                    )
                    .focused($fieldFocused)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: .infinity)
                    TextField("Last Name", text: $employee.lastName)
                        .focused($fieldFocused)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: .infinity)
                }
                .frame(height: 35)
            }
            Section("UserName"){
                TextField("username@co", text: $employee.userName)
                    .focused($fieldFocused)
            }
            Section("Password"){
                TextField("password", text: $employee.password)
                    .focused($fieldFocused)
            }
            
            
            Section("Age"){
                Picker("Select Age", selection: $employee.age){
                    ForEach(18..<100){
                        Text("\($0)")
                            .tag($0)
                    }
                }
                .foregroundStyle(Color(.systemGray2))
                .frame(height: 34)
            }
            
            Section("Designation"){
                Picker("Your Designation", selection: $employee.designation){
                    ForEach(employee.designations, id: \.self){
                        Text("\($0)")
                    }
                }
                .foregroundStyle(Color(.systemGray2))
            }
            Section("Department"){
                Picker("Your Department", selection: $employee.department){
                    ForEach(employee.departments, id: \.self){
                        Text("\($0)")
                    }
                }
                .foregroundStyle(Color(.systemGray2))
            }
            
            Section("Joining Date"){
                DatePicker("Join Date", selection: $employee.joiningDate, displayedComponents: .date)
                    .foregroundStyle(Color(.systemGray2))
            }
            
            Section("Salary"){
                TextField("PKR/-", value: $employee.salary, format: .currency(code: "PKR"))
                    .focused($fieldFocused)
                    .keyboardType(.decimalPad)
//                            .foregroundStyle(Color(.systemGray2))
            }
            
            
        }
        .listSectionSpacing(0)
        .scrollContentBackground(.hidden)
        .background(Color.clear)
        .padding(.bottom, 20)
        //form
    }
}

//#Preview {
//    EmployeeRegistrationFormView(employee: Employee())
//}
