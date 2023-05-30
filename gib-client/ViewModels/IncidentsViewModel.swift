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
    
    // MARK: REST API
    
    func getAllIncidents(completion: @escaping () -> Void) {
        networkService.request(endpoint: "/incidents") { (result: Result<[Incident], NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let incidents):
                    self.incidents = incidents
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
                completion()
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
    
    // MARK: JSONRPC
    
    func getAllIncidentsJSONRPC(completion: @escaping () -> Void) {
        networkService.jsonRpcRequest(endpoint: "/incidents/jsonrpc", method: "getAll", id: "1") { (response: Result<JSONRPCResponse, NetworkError>)  in
            DispatchQueue.main.async {
                switch response {
                case .success(let response):
                    switch response.result {
                    case .success(let incidents):
                        self.incidents = incidents as? [Incident] ?? []
                    case .failure(let error):
                        print("Error: \(error.message)")
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
                completion()
            }
        }
    }
    
    func addIncidentJSONRPC(incident: Incident, completion: @escaping (Result<JSONRPCResponse, NetworkError>) -> Void) {
        
        let file: [String: Any] = [
            "data": incident.imageFile.base64EncodedString(),
            "filename": "image.png"
        ]
        
        let parameters: [String: Any] = [
            "imageFile": file,
            "latitude": incident.latitude,
            "longitude": incident.longitude,
            "comment": incident.comment
        ]
        
        networkService.jsonRpcRequest(endpoint: "/incidents/jsonrpc", method: "create", params: parameters, id: "1", completion: completion)
    }
}
