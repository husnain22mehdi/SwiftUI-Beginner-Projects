//
//  ContentView.swift
//  EmployeeHub
//
//  Created by Husnain on 05/11/2025.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var employee : Employee
    
    @State private var username = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var goToDashboard = false
    @FocusState var fieldFocused : Bool
    
    //test
    let authService = EmployeeAuthService()
    
    var body: some View {
        NavigationStack {
                //1st vstack
                VStack(alignment: .center){
                    
                    Spacer()
                    
                    Image(systemName: "person.2.badge.key.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 125)
                        .opacity(0.7)
                        .offset(x:5)
                    
                    Spacer()
                    
                    
                    
                    VStack(spacing: 50){
                        TextField("Username ", text: $username)
                            .focused($fieldFocused)
                            .frame(height: 50)
                            .padding(.horizontal, 20)
                            .background(Color.secondary.opacity(0.3))
                            .cornerRadius(5)
                        
                        
                        ZStack{
                            HStack{
                                if showPassword{
                                    TextField("Password", text: $password)
                                        .focused($fieldFocused)
                                }
                                else {
                                    SecureField("Password", text: $password)
                                        .focused($fieldFocused)
                                }
                                Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                                    .opacity(0.3)
                                    .onTapGesture {
                                        showPassword.toggle()
                                    }
                            }
                        }
                        .frame(height: 50)
                        .padding(.horizontal, 20)
                        .background(Color.secondary.opacity(0.3))
                        .cornerRadius(5)
                    }
                    .frame(maxWidth: 350, maxHeight: 175, alignment: .topLeading)
//                    .background(.gray)
                    .offset(y : -10)
//                    .border(.black)
//                        
                    
                    Button("Login"){
                        
                        authService.signInEmployee(username, password){ employee, error in
                            if let error = error {
                                print("Login failed: \(error.localizedDescription)")
                            }
                            else {
//                                self.employee = employee
                                print("Welcome back \(employee!.employeeFullName)!")
                                goToDashboard = true
                                EmployeeDashboardView(employee: employee!)
                            }
                        }
                    }
                    .frame(width: 100, height: 50)
                    .foregroundStyle(.white)
                    .background(.blue)
                    //                .cornerRadius(10)
                    .clipShape(.capsule)
//                    .navigationDestination(isPresented: $goToDashboard){
//                        EmployeeDashboardView(employee: employee)
//                    }
                    
                    Spacer()
                        .frame(maxHeight: 200)
                    
                    HStack{
                        Text("Don't have an account?")
                        NavigationLink("Sign Up"){
                            EmployeeRegistrationView(employee: employee, fieldFocused: $fieldFocused)
                        }
                        .foregroundStyle(.blue)
                        .underline()
                    }
                    .padding(.bottom, 10)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGray6))
                .navigationTitle("EmployeeHub")

                .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()     // pushes button to the right
                                Button("Done") {
                                      // dismiss keyboard
                                    fieldFocused = false
                                }
                            }
                        }
                .offset(y : fieldFocused ? -50 : 0)
                .animation(.easeInOut(duration: 0.25), value: fieldFocused)
                .ignoresSafeArea(.keyboard, edges: .bottom)
                //1st vstack
                //            .border(.black)
        }   //navigationstack
    }   //body
}   //struct

#Preview {
    ContentView(employee: Employee())
}
