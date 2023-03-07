//
//  PoiListView.swift
//  PoiApp
//
//  Created by Rafa Garrido on 6/3/23.
//

import SwiftUI

struct PoiListView: View {
    
    @ObservedObject var poiVM = PoiViewModel(service: PoiService())
    
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        NavigationView {
            Group {
                
                /*
                La variable state del viewModel es la que va a controlar el estado de las peticiones a la api y a core data, de manera
                 que será la que, mediante un switch, indique si hay que mostrar la vista de loading, error o los datos cargados
                 */
                switch poiVM.state{
                    case .loading:
                        VStack {
                            ProgressView()
                            Text("Fetching data...")
                                .padding(10)
                        }
                    
                    case .failed(error: let error):
                        ErrorView(error: error)
                    
                    case .success:
                    
                        List( poiVM.filteredPois, id: \.id ){ poi in
                            NavigationLink(destination: PoiDetailView(poi: poi)){
                                PoiCellView(poi: poi)
                            }

                        }
                        .listStyle(InsetListStyle())
                        //barra de búsqueda
                        .searchable(text: $poiVM.searchText)
                        //botón para recargar los datos
                        .toolbar{
                            ToolbarItem(placement: .navigationBarTrailing){
                                Button(action: {
                                    poiVM.refreshData(context: context)
                                }, label: {
                                    Image(systemName: "arrow.clockwise.circle")
                                        .font(.title)
                                })
                            }
                        }
                }
            }
            .navigationTitle("POI List")
            .navigationBarTitleDisplayMode(.inline)
            
            
            
            
        }
        .onAppear{
            poiVM.checkPoiList(context: context)
        }
    }
}

