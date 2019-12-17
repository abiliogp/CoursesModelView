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
            ImageView(withURL: course.bannerUrl)
            
            Section{
                Text(course.name)
                PriceCell(price: course.price)
            }

        }.navigationBarTitle(course.name)

        
    }
}
