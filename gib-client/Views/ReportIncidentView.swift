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
                if showValidationHint {
                    validationHint
                }
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
                        if reportingIncident {
                            loader
                        } else {
                            Text("Report")
                        }
                    }
                    .disabled(reportingIncident)
                }
            }
            .onAppear {
                updateCurrentLocation()
            }
            .alert(isPresented: $showAlert) {
                errorAlert
            }
        }
    }
    
    @State private var showValidationHint = false
    
    private var validationHint: some View {
        Text("Please fill all the fields in order to make report")
            .foregroundColor(Color(.systemRed))
    }
    
    @State private var showAlert = false
    
    private var errorAlert: Alert {
        Alert(title: Text("Something went wrong"),
              message: Text("Failed to report your incident, please try again"),
              dismissButton: .default(Text("Got it!")))
    }
    
    @State private var reportingIncident = false
    
    private var loader: some View {
        ProgressView()
            .tint(Color(.systemBlue))
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
        if let image = selectedImage, !comment.isEmpty {
            let imageData = image.jpegData(compressionQuality: 0.1)!
            
            let incident = Incident(
                id: UUID(),
                imageFile: imageData,
                latitude: coordinateRegion.center.latitude,
                longitude: coordinateRegion.center.longitude,
                comment: comment
            )
            withAnimation { reportingIncident = true }
            
            incidentsVM.addIncidentJSONRPC(incident: incident) { result in
                switch result {
                case .success(let response):
                    switch response.result {
                    case .success(let result):
                        break
                    case .failure(let error):
                        print(error.message)
                    }
                    withAnimation { reportingIncident = false }
                    dismiss()
                case .failure(let error):
                    print(error.localizedDescription)
                    withAnimation { reportingIncident = false }
                    showAlert = true
                }
            }
        } else {
            withAnimation { showValidationHint = true }
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
