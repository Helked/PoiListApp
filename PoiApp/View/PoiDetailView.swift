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
    let poi: Poi
    @State private var region: MKCoordinateRegion
    private var anotationItems: [MyAnnotationItem]
    
    init(poi: Poi) {
        self.poi = poi
        _region = State(initialValue: MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: poi.latitude, longitude: poi.longitude),
                            span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)))
        self.anotationItems = [ MyAnnotationItem(coordinate: CLLocationCoordinate2D(latitude: poi.latitude, longitude: poi.longitude)) ]
    }
    

    var body: some View {
        
        VStack{
            Text(poi.title)
           
            Map(coordinateRegion: $region,
                            annotationItems: anotationItems) {item in
                            MapMarker(coordinate: item.coordinate)
                        }
            .frame(width: 400, height: 300)
            
                       
        }
    }
}
