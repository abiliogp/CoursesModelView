//
//  UserSettings.swift
//  CoursesModelView
//
//  Created by Abilio Gambim Parada on 19/12/2019.
//  Copyright © 2019 Abilio Gambim Parada. All rights reserved.
//

import Foundation



class UserSettings: ObservableObject {
    @Published var score = 0

    @Published var dict = [UUID: Strengths]()
}
