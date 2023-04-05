//
//  Incident.swift
//  gib-client
//
//  Created by Eugene Ned on 04.04.2023.
//

import Foundation

struct Incident: Codable, Identifiable {
    let id: UUID
    let imageFile: Data
    let latitude: Double
    let longitude: Double
    let comment: String
}
