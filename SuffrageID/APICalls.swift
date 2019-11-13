//
//  APICalls.swift
//  SuffrageID
//
//  Created by Jeremy Conkin on 11/15/18.
//  Copyright © 2018 Slalom. All rights reserved.
//

import Foundation

class ContactCreator {

    static let baseURL = "http://10.10.2.79:8080/api/"
    
    static func CreateContact(firstName:String, lastName:String, gender:String, state:String) {
        
        let url = URL(string: baseURL + "voters")
        let parameterDictionary = ["firstName" : firstName, "lastName" : lastName, "state" : state, "gender" : gender]
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                }catch {
                    print(error)
                }
            }
            }.resume()
    }
    
    static func ReadContacts() {
        let url = URL(string: baseURL + "voters")

        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if let data = data {
                do {
                    // Convert the data to JSON
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    
                    if let json = jsonSerialized {
                        print(json)
                    }
                }  catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
