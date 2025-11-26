//
//  EmployeeService.swift
//  EmployeeHub
//
//  Created by Husnain on 07/11/2025.
//

import Foundation
import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth


// responsible for handling database
struct EmployeeAuthService {
    
//    @ObservedObject var employee : Employee
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    
    //saving the employee data with image URL into firestore
    func saveEmployeeDocument(_ employee: Employee, imageURL: String?, userID: String,  completion: @escaping (Bool) -> Void){
        
        let employeeData : [String : Any] = [
            "employeeID" : userID,
            "employeeName" : employee.employeeFullName,
            "userName" : employee.userName,
            "password" : employee.password,
            "age" : employee.age,
            "designation" : employee.designation,
            "department" : employee.department,
            "joiningDate" : employee.joiningDate,
            "salary" : employee.salary,
            "profileImageURL" : imageURL ?? ""
        ]
        
        db.collection("employees").document(userID).setData(employeeData){ error in
            if let error = error {
                print("Error saving employee: \(error)")
                completion(false)
            }
            else{
                print("Employee saved successfully")
                completion(true)
            }
        }
    }
    
    //Registering new employee using Firebase Auth
    func registerEmployee(_ employee: Employee, completion: @escaping (Bool) -> Void){
        
        //create user in firebase auth
        let email = "\(employee.userName)@employeehub.com"
        let password = employee.password
        
        Auth.auth().createUser(withEmail: email, password: password){ result ,error in
            if let error = error {
                print("Auth signup error: \(error.localizedDescription)")
                completion(false)
                return
            }
            print("Auth User created successfully!")
            
            guard let uid = result?.user.uid else {
                completion(false)
                return
            }
            
            let storageRef = self.storage.child("employees/\(uid).jpg")
            
            //convert image to data
            if let imageData = employee.profileImg?.jpegData(compressionQuality: 0.7){
                
                //upload to firebase storage
                storageRef.putData(imageData, metadata: nil) { _, error in
                    if let error = error {
                        print("Error uploading image: \(error)")
                        completion(false)
                        return
                    }
                    
                    //get download URL
                    storageRef.downloadURL{ url, error in
                        guard let imageURL = url?.absoluteString else {
                            print("Failed to get download URL")
                            completion(false)
                            return
                        }
                        
                        //save employee data to firestore
                        saveEmployeeDocument(employee, imageURL: imageURL, userID: uid, completion: completion)
                        
                    }
                    
                }
            }
            //no image stored
            else{
                saveEmployeeDocument(employee, imageURL: nil, userID: uid, completion: completion)
            }
        }
    }
    
    //Signing in existing employee
    func signInEmployee(_ userName: String, _ password: String, completion: @escaping (Employee?, Error?) -> Void){
        
        //We are taking username for login. Converting to email for Firebase Auth
        let email = "\(userName)@employeehub.com"
        
        Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
            if let error = error{
                print("Auth sign-in error: \(error.localizedDescription)")
                completion(nil, error)
            }
            
            guard let user = authResult?.user else {
                completion(nil, NSError(domain: "Auth Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not found!"]))
                return
            }
            
            print("Auth User sign-in successful!")
            
            Task {
                do{
                    let employee = try await fetchUserData(user)
                    completion(employee, nil)
                }catch{
                    completion(nil, error)
                }
            }
        }
    }
    
    func fetchUserData(_ user : User) async -> Employee?{
        
        let uid = user.uid
        
        let employeeData = db.collection("employees").document(uid)
        print("employeeData type : \(type(of: employeeData))")
        
        var dataDictionary : [String : Any]? = ["": ""]
        
        do {
            let fetchedEmployee = try await employeeData.getDocument()
            
            if fetchedEmployee.exists {
                dataDictionary = fetchedEmployee.data()
//                print("employeeID : \(dataDescription["employeeID"])")
            }else {
                print("Employee doesn't exist!")
            }
        }
        catch {
            print("Couldn't fetch employee data!")
        }
        
        //Converting the fetched data into an Employee object to return
        let employee = Employee()
        
        employee.id = uid
        print(employee.id)
        employee.employeeFullName = dataDictionary?["employeeName"] as? String ?? ""
        print(employee.employeeFullName)
        employee.userName = dataDictionary?["userName"] as? String ?? ""
        print(employee.userName)
        employee.password = dataDictionary?["password"] as? String ?? ""
        print(employee.password)
        employee.age = dataDictionary?["age"] as? Int ?? 0
        print(employee.age)
        employee.designation = dataDictionary?["designation"] as? String ?? ""
        print(employee.designation)
        employee.department = dataDictionary?["department"] as? String ?? ""
        print(employee.department)
        employee.joiningDate = dataDictionary?["joiningDate"] as? Date ?? Date.now
        print(employee.joiningDate)
        employee.salary = dataDictionary?["salary"] as? Int ?? 0
        print(employee.salary)
        //        employeeta contains profile image url, we need the actual image
        let imageURL = dataDictionary?["profileImageURL"] as? String ?? ""
        print(imageURL)
        
        fetchUserImage(from: imageURL){ image in
            employee.profileImg = image
        }
        
        return employee
    }
}
    
    //getting image from firestore storage
    func fetchUserImage(from url : String, completion: @escaping (UIImage?) -> Void){
        let storageRef = Storage.storage().reference(forURL: url)
        storageRef.getData(maxSize: 5 * 1024 * 1024){ data, error in
            if let data = data {
                completion(UIImage(data: data))
            }else{
                completion(nil)
            }
    }
}
