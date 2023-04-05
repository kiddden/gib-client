//
//  ContentView.swift
//  gib-client
//
//  Created by Eugene Ned on 04.04.2023.
//

import SwiftUI

struct MainView: View {
//    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject private var incidentsVM = IncidentsViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                listOfIncidents
                .frame(minWidth: 0, maxWidth: .infinity)
                .overlay(
                    Button {
                        incidentsVM.getAllIncidents()
                    } label: {
                        Text("Report incident")
                    }
                    .buttonStyle(.bordered)
                , alignment: .bottom)
            }
            .navigationTitle("Incidents list")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSheet = true
                    } label: {
                        Image(systemName: "plus.bubble")
                    }
                }
            }
            .sheet(isPresented: $showSheet) {
                ReportIncidentView()
            }
        }
    }
    
    @State private var showSheet = false
    
    private var listOfIncidents: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(incidentsVM.incidents, id: \.id) { incident in
                    IncidentRow(incident: incident)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
