//
//  EmployeeRegistrationFormView.swift
//  EmployeeHub
//
//  Created by Husnain on 06/11/2025.
//

import SwiftUI

struct EmployeeRegistrationFormView: View {
    
//    @ObservedObject var employee : Employee
    @ObservedObject var employeeViewModel : EmployeeViewModel
    
    @FocusState.Binding var fieldFocused : Bool
    
    var body: some View {
        
        Form{
            Section("Name"){
                HStack(){
                    TextField("First Name", text: $employeeViewModel.employee.firstName)
                    //                                .frame(width: 30)
                        .focused($fieldFocused)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: .infinity)
                    TextField("Middle Name", text: Binding(
                        get: { employeeViewModel.employee.middleName ?? "" },
                        set: { employeeViewModel.employee.middleName = $0.isEmpty ? nil : $0 }
                    )
                    )
                    .focused($fieldFocused)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: .infinity)
                    TextField("Last Name", text: $employeeViewModel.employee.lastName)
                        .focused($fieldFocused)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: .infinity)
                }
                .frame(height: 35)
            }
            Section("UserName"){
                TextField("username@co", text: $employeeViewModel.employee.userName)
                    .focused($fieldFocused)
            }
            Section("Password"){
                TextField("password", text: $employeeViewModel.employee.password)
                    .focused($fieldFocused)
            }
            
            
            Section("Age"){
                Picker("Select Age", selection: $employeeViewModel.employee.age){
                    ForEach(18..<100){
                        Text("\($0)")
                            .tag($0)
                    }
                }
                .foregroundStyle(Color(.systemGray2))
                .frame(height: 34)
            }
            
            Section("Designation"){
                Picker("Your Designation", selection: $employeeViewModel.employee.designation){
                    ForEach(employeeViewModel.employee.designations, id: \.self){
                        Text("\($0)")
                    }
                }
                .foregroundStyle(Color(.systemGray2))
            }
            Section("Department"){
                Picker("Your Department", selection: $employeeViewModel.employee.department){
                    ForEach(employeeViewModel.employee.departments, id: \.self){
                        Text("\($0)")
                    }
                }
                .foregroundStyle(Color(.systemGray2))
            }
            
            Section("Joining Date"){
                DatePicker("Join Date", selection: $employeeViewModel.employee.joiningDate, displayedComponents: .date)
                    .foregroundStyle(Color(.systemGray2))
            }
            
            Section("Salary"){
                TextField("PKR/-", value: $employeeViewModel.employee.salary, format: .currency(code: "PKR"))
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
