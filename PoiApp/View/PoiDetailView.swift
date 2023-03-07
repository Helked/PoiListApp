//
//  PoiDetailView.swift
//  PoiApp
//
//  Created by Rafa Garrido on 6/3/23.
//

import SwiftUI
import MapKit

struct MyAnnotationItem: Identifiable {
    var coordinate: CLLocationCoordinate2D
    let id = UUID()
}


struct PoiDetailView: View {
    let poi: POI
    @State private var region: MKCoordinateRegion
    private var anotationItems: [MyAnnotationItem]
    
    init(poi: POI) {
        self.poi = poi
        
        //se inicializa region para que centre el mapa en las coordenadas del poi
        _region = State(initialValue: MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: poi.latitude, longitude: poi.longitude),
                            span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)))
        
        //anotationsItems es un array que guardar los pins que se van a pintar en el mapa
        self.anotationItems = [ MyAnnotationItem(coordinate: CLLocationCoordinate2D(latitude: poi.latitude, longitude: poi.longitude)) ]
    }
    

    var body: some View {
        
        VStack{
            
            if(poi.imageData != nil){
                Image(uiImage: UIImage(data: poi.imageData!)!)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 300, alignment: .topLeading)
      
            }else{
                Image(systemName: "mappin.and.ellipse")
                    .resizable()
                    .frame(width: 200, height: 200, alignment: .center)
                    .foregroundColor(.gray)
            }
            
            Map(coordinateRegion: $region,
                annotationItems: anotationItems) {item in
                    MapMarker(coordinate: item.coordinate)
                }
            .frame(width: 400, height: 300)
            
                       
        }
        .navigationTitle(poi.title ?? "No title")
    }
}
