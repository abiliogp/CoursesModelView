//
//  ContentView.swift
//  CoursesModelView
//
//  Created by Abilio Gambim Parada on 09/12/2019.
//  Copyright © 2019 Abilio Gambim Parada. All rights reserved.
//

import UIKit
import SwiftUI

struct ContentView: View{
    
    @EnvironmentObject var settings: UserSettings
    
    @ObservedObject var coursersVM = CoursesViewModel()
    @State private var isPressed = false
    
    var body: some View{
        NavigationView{
            ListOrEmpthy(coursersVM: coursersVM)
                .navigationBarTitle("Courses")
                .navigationBarItems(trailing:
                    HStack{
                        Button(action: {
                            self.coursersVM.fetchCourses()
                            self.isPressed = !self.isPressed
                            self.settings.score += 1
                        }, label: {
                            Text("Fetch \(self.settings.score)")
                        })
                            .foregroundColor(.white)
                            .padding(6)
                            .background(isPressed ? Color.green : Color.red)
                            .cornerRadius(12)
                        
                        if(coursersVM.courses.isEmpty == false){
                            Button(action: {
                                self.coursersVM.orderCoursesByLowerPrice()
                            }) {
                                Text("Sort")
                            }
                            
                            EditButton()
                        }
                    }
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
                List {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 10) {
                            ForEach(coursersVM.courses) { course in
                                NavigationLink(destination: DetailContentView(course: course)) {
                                    HorizontalCardCell(course: course)
                                    
                                }.buttonStyle(PlainButtonStyle())
                            }
                        }.padding(.horizontal, 16)
                    }.padding(.horizontal, -16)
                        ForEach(coursersVM.courses){ course in
                            NavigationLink(destination: DetailContentView(course: course)) {
                                CardCell(course: course)
                            }
                        }.onDelete(perform: delete)
                            .onMove(perform: move)
                    
                    
                }
            }
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        coursersVM.courses.move(fromOffsets: source, toOffset: destination)
    }
    
    func delete(at offsets: IndexSet) {
        coursersVM.courses.remove(atOffsets: offsets)
    }
}

struct HorizontalCardCell: View {
    var course: Course!
    
    var body: some View{
        VStack{
            ImageView(withURL: course.bannerUrl)
                .scaledToFill()
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 4))
                .frame(width: 150, height: 150, alignment: .center)
            
            VStack{
                Text(course.name)
                    .bold()
                    .font(.callout)
                    .lineLimit(1)
                    .frame(width: 120, height: 20, alignment: .center)
                    .truncationMode(.tail)
                PriceCell(price: course.price)
            }
        }.padding(10)
            .background(Color(UIColor(red:0.76, green:0.76, blue:0.78, alpha:1.0)))
            .cornerRadius(4, antialiased: true)
    }
}

struct CardCell: View {
    var course: Course!
    
    var body: some View{
        HStack {
            VStack(alignment: .leading){
                Text(course.name)
                    .foregroundColor(.primary)
                    .font(.headline)
                    .padding(4)
                Divider()
                PriceCell(price: course.price)
            }
            ImageView(withURL: course.bannerUrl)
                .frame(width: 100, height: 100, alignment: .center)
        }.padding(10)
            .background(Color.secondary, alignment:.leading)
            .cornerRadius(12)
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

struct ImageView: View {
    @ObservedObject var imageLoader: ImageLoader
    
    init(withURL url:String) {
        imageLoader = ImageLoader(urlString:url)
    }
    
    var body: some View {
        Group {
            if imageLoader.data != nil{
                Image(uiImage: UIImage(data:imageLoader.data!) ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else{
                ActivityIndicator()
            }
        }
    }
}

struct ActivityIndicator: UIViewRepresentable {
    
    typealias UIView = UIActivityIndicatorView
    
    fileprivate var configuration = { (indicator: UIView) in }
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIView {
        UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<Self>) {
        uiView.startAnimating()
        configuration(uiView)
    }
}
