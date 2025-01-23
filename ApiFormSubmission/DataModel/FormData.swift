//
//  FormData.swift
//  ApiFormSubmission
//
//  Created by Salman Mhaskar on 22/01/25.
//

import Foundation

struct FormData: Decodable,Hashable{
    var name: String
    var age: Int
    var jobRole: String
    var experience: Int
    var package: Int
}
