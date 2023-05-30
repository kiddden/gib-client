//
//  ContentView.swift
//  gib-client
//
//  Created by Eugene Ned on 04.04.2023.
//

import SwiftUI

struct MainView: View {
    @ObservedObject private var incidentsVM = IncidentsViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if loadingIncidents {
                    loader
                } else {
                    listOfIncidents
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
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
            .onAppear {
                DispatchQueue.main.async {
                    incidentsVM.getAllIncidentsJSONRPC {
                        withAnimation { loadingIncidents = false }
                    }
                }
            }
        }
    }
    
    
    //    @ViewBuilder
    //    private var content: some View {
    //
    //    }
    
    @State private var loadingIncidents = true
    
    private var loader: some View {
        ProgressView().scaleEffect(2)
    }
    
    @State private var showSheet = false
    
    private var listOfIncidents: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(incidentsVM.incidents.reversed(), id: \.id) { incident in
                    IncidentRow(incident: incident)
                }
            }
        }
        .background(Color(.secondarySystemBackground))
        .refreshable {
            await refresh()
        }
    }
    
    private func refresh() async {
        DispatchQueue.main.async {
            self.incidentsVM.getAllIncidentsJSONRPC { }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
