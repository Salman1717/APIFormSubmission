//
//  FormViewModel.swift
//  ApiFormSubmission
//
//  Created by Salman Mhaskar on 20/01/25.
//

import Foundation


class FormViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var age: String = ""
    @Published var jobRole: String = ""
    @Published var package: String = ""
    @Published var experience: String = ""
    @Published var FetchedData :[FormData] = []
    @Published var errorMessage = ""
    
   
    
    func submitFormData() async throws {
        let data = try validateAndConvertData()
        
        // Create a dictionary for JSON serialization
        let jsonParameters: [String: Any] = [
            "name": data.name,
            "age": data.age,
            "jobRole": data.jobRole,
            "experience": data.experience,
            "package": data.package
        ]
        
        guard let url = URL(string: "https://678fcd1749875e5a1a9369db.mockapi.io/salman/api/users"),
              let jsonData = try? JSONSerialization.data(withJSONObject: jsonParameters) else {
            throw NSError(domain: "Error serializing Json Data", code: 2)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 201 {
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Response: \(responseString)")
                    } else {
                        print("Parsing Failed")
                    }
                } else {
                    let errorString = String(data: data, encoding: .utf8) ?? "No response body"
                    print("Server Error: \(httpResponse.statusCode), Body: \(errorString)")
                }
            } else {
                print("Server Error")
            }
        } catch {
            throw error
        }
    }
    
    func fetchApiData() async {
            guard let url = URL(string:"https://678fcd1749875e5a1a9369db.mockapi.io/salman/api/users") else {
                errorMessage = "Invalid URL"
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            //request.setValue(apiKey, forHTTPHeaderField: "X-Master-Key")
            
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        do {
                            // Decode array of FormData
                            let decodedData = try JSONDecoder().decode([FormData].self, from: data)
                            DispatchQueue.main.async {
                                self.FetchedData = decodedData
                                print(self.FetchedData)
                                self.errorMessage = ""
                            }
                        } catch {
                            DispatchQueue.main.async {
                               print("Failed to decode data: \(error.localizedDescription)")
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            print("Server Error: \(httpResponse.statusCode)")
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    print( "Request Failed: \(error.localizedDescription)")
                }
            }
        }
    
    
    private func validateAndConvertData() throws -> FormData {
        guard let Age = Int(age), let package = Int(package), let exp = Int(experience), !name.isEmpty, !jobRole.isEmpty else{
            throw NSError(domain: "Form Data Invalid", code: 1)
        }
        
        let formData = FormData(name: name, age: Age, jobRole: jobRole, experience: exp, package: package)
        
        return formData
    }
}
