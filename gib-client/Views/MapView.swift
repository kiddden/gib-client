//
//  MapView.swift
//  gib-client
//
//  Created by Eugene Ned on 04.04.2023.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    let latitude: Double
    let longitude: Double
    var onTap: (() -> Void)?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)

        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
//        mapView.isUserInteractionEnabled = false

        let tapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.mapTapped))
        mapView.addGestureRecognizer(tapGestureRecognizer)



        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) { }

    class Coordinator: NSObject, MKMapViewDelegate {
        var mapView: MapView

        init(_ mapView: MapView) {
            self.mapView = mapView
        }

        @objc func mapTapped() {
            mapView.onTap?()
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(latitude: 37.7749, longitude: -122.4194) {
            print("Test")
        }
    }
}
