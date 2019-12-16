//
//  ContentView.swift
//  CoursesModelView
//
//  Created by Abilio Gambim Parada on 09/12/2019.
//  Copyright © 2019 Abilio Gambim Parada. All rights reserved.
//

import UIKit
import SwiftUI

let apiUrl = "https://api.letsbuildthatapp.com/static/courses.json"

struct Course: Identifiable, Decodable {
    let id = UUID()
    let name: String
}

class CoursesViewModel: ObservableObject{
    @Published var messages = "This message"
    
    @Published var courses: [Course] = [
        
    ]
    
    func changeMessage(){
        self.messages = "ok"
    }
    
    func fetchCourses(){
        guard let url = URL(string: apiUrl) else { return }
        URLSession.shared.dataTask(with: url) {
            (data, resp, error) in
            
            DispatchQueue.main.async {
                do{
                    let newCourses = try JSONDecoder().decode([Course].self, from: data!)
                    
                    self.courses.append(contentsOf: newCourses)
                    
                } catch{
                    
                }
            }
            
            
        }.resume()
    }
}


struct ContentView: View{
    
    @ObservedObject var coursersVM = CoursesViewModel()
    @State private var isPressed = false
    
    var body: some View{
        NavigationView{
            ListOrEmpthy(coursersVM: coursersVM)
            .navigationBarTitle("Swift UI")
            .navigationBarItems(trailing:
                Button(action: {
                    self.coursersVM.fetchCourses()
                    self.isPressed = !self.isPressed
                }, label: {
                    Text("Fetch")
                })
                    .foregroundColor(.white)
                    .padding(6)
                    .background(isPressed ? Color.green : Color.red)
                    .cornerRadius(12)
            ).animation(.easeIn)
        }
        
    }
    
}

struct ListOrEmpthy: View {
    @ObservedObject var coursersVM = CoursesViewModel()
    
    
    var body: some View{
        Section{
            if(coursersVM.courses.isEmpty){
                Text("Press Fetch")
            } else{
                List(coursersVM.courses){ course in
                    Text(course.name)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.blue, alignment: .center)
                        .cornerRadius(12)
                        .padding(4)
                }
            }
        }
    }
    
    
    
    
}
