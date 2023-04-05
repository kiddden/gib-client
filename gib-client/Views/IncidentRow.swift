//
//  IncidentRow.swift
//  gib-client
//
//  Created by Eugene Ned on 04.04.2023.
//

import SwiftUI
import MapKit

struct IncidentRow: View {
    
    let incident: Incident
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            MapView(latitude: incident.latitude, longitude: incident.longitude)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: UIScreen.main.bounds.height/7)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Comment")
                    .font(.caption)
                    .opacity(0.8)
                Text(incident.comment)
                    .font(.body)
            }
            .padding()
        }
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
        .shadow(radius: 4)
        .onTapGesture {
            openMapsApp()
        }
    }
    
    private func openMapsApp() {
        print("tap")
        let coordinates = CLLocationCoordinate2DMake(incident.latitude, incident.longitude)
        let regionDistance: CLLocationDistance = 1000
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinates))
        mapItem.name = incident.comment
        
        let options: [String: Any] = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        
        mapItem.openInMaps(launchOptions: options)
    }
}
