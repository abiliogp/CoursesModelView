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
            }
        }.navigationBarTitle(course.name)
    }
}
