//
//  ReportIncidentView.swift
//  gib-client
//
//  Created by Eugene Ned on 04.04.2023.
//

import SwiftUI
import MapKit

struct ReportIncidentView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject private var incidentsVM = IncidentsViewModel()
    private let locationService = LocationService()
    
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented: Bool = false
    @State private var comment: String = ""
    @State private var coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    @State private var selectedLocation: IdentifiableLocation?
    
    var body: some View {
        NavigationView {
            Form {
                imageSelectionSection
                commentSection
                locationSection
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        reportIncident()
                    } label: {
                        Text("Report")
                    }
                }
            }
            .onAppear {
                updateCurrentLocation()
            }
        }
    }
    
    private var imageSelectionSection: some View {
        Section(header: Text("Image")) {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(minHeight: 0, maxHeight: 200)
                    .cornerRadius(10)
            }
            chooseImageButton
        }
    }
    
    private var commentSection: some View {
        Section(header: Text("Comment")) {
            TextField("Add a comment", text: $comment)
        }
    }
    
    private var locationSection: some View {
        Section(header: Text("Location")) {
            Map(coordinateRegion: $coordinateRegion, interactionModes: .all, showsUserLocation: true, userTrackingMode: nil, annotationItems: selectedLocation.map { [$0] } ?? []) { location in
                MapMarker(coordinate: location.coordinate)
            }
            .frame(height: 200)
            .cornerRadius(10)
        }
    }
    
    private var chooseImageButton: some View {
        Button(action: {
            isImagePickerPresented = true
        }) {
            if let _ = selectedImage {
                Text("Choose Another Image")
            } else {
                Text("Choose Image")
            }
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
    
    private func reportIncident() {
        if let image = selectedImage {
            let imageData = image.jpegData(compressionQuality: 1.0)!
            
            let incident = Incident(
                id: UUID(),
                imageFile: imageData,
                latitude: coordinateRegion.center.latitude,
                longitude: coordinateRegion.center.longitude,
                comment: comment
            )
            
            incidentsVM.addIncident(incident: incident) { result in
                switch result {
                case .success(let success):
                    print(success)
                    dismiss()
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
    }
    
    private func updateCurrentLocation() {
        locationService.onLocationUpdate = { location in
            coordinateRegion.center = location.coordinate
        }
        locationService.startUpdatingLocation()
    }
}

struct ReportIncidentView_Previews: PreviewProvider {
    static var previews: some View {
        ReportIncidentView()
    }
}
