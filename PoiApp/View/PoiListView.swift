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
                switch poiVM.state{
                    case .loading:
                        VStack {
                            ProgressView()
                            Text("Loading")
                                .padding(10)
                        }
                    case .failed(error: let error):
                        ErrorView(error: error)
                    case .success:
                    
//                    List (poiVM.filteredPois, id:\.id) { poi in
//
//                    }
                    
                    
                    List( poiVM.filteredPois, id: \.id ){ poi in
                            NavigationLink(destination: PoiDetailView(poi: poi)){
                                PoiCellView(poi: poi)
                                        }

                        }
                        .listStyle(InsetListStyle())
                        .searchable(text: $poiVM.searchText)
                }
            }
            .navigationTitle("POI List")
            .navigationBarTitleDisplayMode(.inline)
            //refreshbutton
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
        .onAppear{
            poiVM.checkPoiList(context: context)
        }
    }
}

struct PoiListView_Previews: PreviewProvider {
    static var previews: some View {
        PoiListView()
    }
}
