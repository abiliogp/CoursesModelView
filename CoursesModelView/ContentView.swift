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
                    }.padding(10)
                        .background(Color.secondary, alignment:.leading)
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
                    .frame(width:100, height:100)
            } else{
                ActivityIndicator()
            }
        }.frame(width: 100.0, height: 100.0, alignment: .center)
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
