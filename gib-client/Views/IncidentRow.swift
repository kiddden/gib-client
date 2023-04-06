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
    
    init(incident: Incident) {
        self.incident = incident
    }
    
    private var uiImage: UIImage? {
        UIImage(data: incident.imageFile)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
            } else {
                Text("Failed to upload image")
            }
            
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: UIScreen.main.bounds.height/4.5)
        .overlay(commentSection, alignment: .bottom)
        .overlay(mapSection, alignment: .topTrailing)
        .cornerRadius(10)
//        .overlay(
//            RoundedRectangle(cornerRadius: 10)
//                .stroke(.gray, lineWidth: 1)
//        )
        .padding(.horizontal)
        .shadow(radius: 10, x: 0, y: 0)
    }
    
    private var mapWidgetSize: CGFloat = UIScreen.main.bounds.height/10
    
    private var mapSection: some View {
        MapView(latitude: incident.latitude, longitude: incident.longitude) {
            openMapsApp()
        }
            .frame(width: mapWidgetSize, height: mapWidgetSize)
            .shadow(radius: 10, x: 0, y: 0)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray, lineWidth: 1)
            )
            .padding(10)
    }
    
    private var commentSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("Comment")
                    .font(.caption)
                    .opacity(0.8)
                Text(incident.comment)
                    .font(.body)
            }
            Spacer()
        }
        .padding(10)
        .background(.ultraThinMaterial)
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
