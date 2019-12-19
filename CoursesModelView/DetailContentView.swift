//
//  DetailContentView.swift
//  CoursesModelView
//
//  Created by Abilio Gambim Parada on 17/12/2019.
//  Copyright © 2019 Abilio Gambim Parada. All rights reserved.
//

import Foundation
import SwiftUI

struct DetailContentView: View {
    
    @EnvironmentObject var settings: UserSettings
    
    @State private var selectedStrength = 0
    
    
    var course: Course!
    
    var body: some View{
        Form{
            Section{
                ImageView(withURL: course.bannerUrl)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
            }
            Section{
                Text(course.name)
                PriceCell(price: course.price)
                Text("Fetch \(settings.score)")
                
                Picker(selection: $selectedStrength, label: Text("Strength")) {
                    ForEach(0 ..< Strengths.allValues.count){
                        Text(Strengths.allValues[$0].rawValue)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
            }
        }.navigationBarTitle(course.name)
    }
}
