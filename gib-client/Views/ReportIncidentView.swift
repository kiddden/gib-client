//
//  ReportIncidentView.swift
//  gib-client
//
//  Created by Eugene Ned on 04.04.2023.
//

import SwiftUI

struct ReportIncidentView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Text("Test")
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
                        
                    } label: {
                        Text("Report")
                    }
                }
            }
        }
    }
}

struct ReportIncidentView_Previews: PreviewProvider {
    static var previews: some View {
        ReportIncidentView()
    }
}
