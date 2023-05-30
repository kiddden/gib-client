//
//  NetworkService.swift
//  gib-client
//
//  Created by Eugene Ned on 04.04.2023.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case networkError
    case decodingError
}

class NetworkService {
    private let baseURL = "http://localhost:8080"
    
    // MARK: REST API
    
    func request<T: Codable>(endpoint: String, method: String = "GET", parameters: [String: Any]? = nil, headers: [String: String]? = nil, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(.badURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        
        if let parameters = parameters {
            let formData = createFormData(with: parameters)
            request.httpBody = formData
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(.networkError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.networkError))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
    
    private func createFormData(with parameters: [String: Any]) -> Data {
        let formData = NSMutableData()
        
        for (key, value) in parameters {
            if let stringValue = value as? String {
                formData.appendString("--Boundary\r\n")
                formData.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                formData.appendString("\(stringValue)\r\n")
            } else if let fileData = value as? Data {
                formData.appendString("--Boundary\r\n")
                formData.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"file.jpg\"\r\n")
                formData.appendString("Content-Type: image/jpeg\r\n\r\n")
                formData.append(fileData)
                formData.appendString("\r\n")
            }
        }
        
        formData.appendString("--Boundary--\r\n")
        
        return formData as Data
    }
    
    // MARK: JSONRPC
    
    func jsonRpcRequest<T: Codable>(endpoint: String, method: String, params: [String: Any]? = nil, id: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(.badURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonRpcObject: [String: Any] = [
            "jsonrpc": "2.0",
            "method": method,
            "params": params ?? [:],
            "id": id
        ]
        
    
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonRpcObject, options: []) else { return }
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(.networkError))
                return
            }

            guard let data = data else {
                completion(.failure(.networkError))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
}
