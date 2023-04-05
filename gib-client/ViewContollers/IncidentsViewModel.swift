//
//  IncidentsViewModel.swift
//  gib-client
//
//  Created by Eugene Ned on 04.04.2023.
//

import Foundation

class IncidentsViewModel: ObservableObject {
    private let networkService = NetworkService()

    @Published var incidents: [Incident] = []

    func getAllIncidents() {
        networkService.request(endpoint: "/incidents") { (result: Result<[Incident], NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let incidents):
                    self.incidents = incidents
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    func addIncident(incident: Incident, completion: @escaping (Result<Incident, NetworkError>) -> Void) {
        let parameters: [String: Any] = [
            "imageFile": incident.imageFile,
            "latitude": "\(incident.latitude)",
            "longitude": "\(incident.longitude)",
            "comment": incident.comment
        ]

        let headers = ["Content-Type": "multipart/form-data; boundary=Boundary"]

        networkService.request(endpoint: "/incidents", method: "POST", parameters: parameters, headers: headers, completion: completion)
    }
}
