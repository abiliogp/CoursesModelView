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
//https://docs.openaq.org/#api-Latest-GetLatest

struct Course: Identifiable, Decodable {
    let id = UUID()
    let name: String
    let price: Int
}

class CoursesViewModel: ObservableObject{
    
    @Published var courses: [Course] = []
    
    
    
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
        Group{
            if(coursersVM.courses.isEmpty){
                VStack{
                    Text("Press Fetch")
                }
            } else{
                List(coursersVM.courses){ course in
                    VStack(alignment: .leading){
                        Text(course.name)
                            .foregroundColor(.primary)
                            .font(.headline)
                            .padding(4)
                        Divider()
                        PriceCell(price: course.price)

                    }.padding(10)
                        .background(Color.secondary, alignment: .leading)
                    .cornerRadius(12)

                }
            }
        }
    }
    
}


struct PriceCell: View {
    var price = 0
    
    var body: some View{
        Group{
            if(price > 75){
                TextPrice(price: price, color: Color.red)
            } else if(price > 50){
                TextPrice(price: price, color: Color.orange)
            } else if(price > 25){
                TextPrice(price: price, color: Color.yellow)
            } else{
                TextPrice(price: price, color: Color.green)
            }
        }
    }
}

struct TextPrice: View {
    var price: Int
    var color: Color
    
    var body: some View{
        Text("Price: $\(price)")
        .font(.subheadline)
        .foregroundColor(.secondary)
            .background(color, alignment: .leading)
            .cornerRadius(4)
        .padding(4)
    }
}
