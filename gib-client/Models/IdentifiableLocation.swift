//
//  IdentifiableLocation.swift
//  gib-client
//
//  Created by Eugene Ned on 06.04.2023.
//

import MapKit

struct IdentifiableLocation: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}
