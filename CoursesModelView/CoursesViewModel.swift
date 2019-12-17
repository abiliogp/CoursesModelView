//
//  CoursesViewModel.swift
//  CoursesModelView
//
//  Created by Abilio Gambim Parada on 17/12/2019.
//  Copyright © 2019 Abilio Gambim Parada. All rights reserved.
//

import Foundation


let apiUrl = "https://api.letsbuildthatapp.com/static/courses.json"
//https://docs.openaq.org/#api-Latest-GetLatest

struct Course: Identifiable, Decodable {
    let id = UUID()
    let name: String
    let price: Int
    let bannerUrl: String
}

class CoursesViewModel: ObservableObject{
    
    @Published var courses: [Course] = []
    
    func fetchCourses(){
        guard let url = URL(string: apiUrl) else { return }
        URLSession.shared.dataTask(with: url) {
            (data, resp, error) in
            
            if let data = data{
                DispatchQueue.main.async {
                    do{
                        let newCourses = try JSONDecoder().decode([Course].self, from: data)
                        
                        self.courses.append(contentsOf: newCourses)
                        
                    } catch{
                        
                    }
                }
            }
        }.resume()
    }
}
