//
//  NSMutableData+Ext.swift
//  gib-client
//
//  Created by Eugene Ned on 04.04.2023.
//

import Foundation

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
