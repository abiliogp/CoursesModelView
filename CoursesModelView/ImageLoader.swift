//
//  ImageLoader.swift
//  CoursesModelView
//
//  Created by Abilio Gambim Parada on 17/12/2019.
//  Copyright © 2019 Abilio Gambim Parada. All rights reserved.
//

import Foundation
import Combine

class ImageLoader: ObservableObject {

    @Published var data: Data?

    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}
