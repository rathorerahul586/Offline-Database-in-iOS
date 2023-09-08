//
//  Extensions.swift
//  ToDo
//
//  Created by Rahul Kumar on 30/08/23.
//

import Foundation

extension Date {
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy 'at' h:mm a"
        let formattedDate = dateFormatter.string(from: self)
        return formattedDate
    }
    
}
