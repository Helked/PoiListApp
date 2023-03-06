//
//  PoiViewModel.swift
//  PoiApp
//
//  Created by Rafa Garrido on 6/3/23.
//

import Foundation
import Combine
import CoreData

class PoiViewModel: ObservableObject {
    
    private let service: PoiService
    private(set) var poiList = [Poi]()
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var state: ResultState = .loading
    @Published var searchText = ""
    
    
    init (service: PoiService){
        self.service = service
    }
    
    
    var filteredPois: [Poi] {
        return searchText == "" ? self.poiList : self.poiList.filter {
            $0.title.lowercased().contains(searchText.lowercased())
        }
    }
    
    func checkPoiList(){
        if self.poiList.isEmpty {
            getPoiList()
        }
    }
    
    func refreshData() {
        self.poiList.removeAll()
        getPoiList()
    }
    
    private func getPoiList() {
        self.state = .loading
        
        let cancellable = service
            .request(from: .getPoiList, decodingType: PoiList.self)
            .sink { result in
                switch result{
                case .finished:
                    self.state = .success
                case .failure(let error):
                    self.state = .failed(error: error)
                }
            } receiveValue: { response in
                self.poiList = response.list
            }
        self.cancellables.insert(cancellable)
    }
    
//    private func savePoisToCoreData(context: NSManagedObjectContext){
//        poiList.forEach { (poi) in
//            let entity = Poi(context: context)
//            
//            entity.id = Int16(poi.id)
//            entity.latitude = poi.latitude
//            entity.longitude = poi.longitude
//            entity.image = poi.image
//            entity.title = poi.title
//            
//        }
//        
//        //save
//        do{
//            try context.save()
//            print("success")
//        }catch{
//            print(error.localizedDescription)
//        }
//        
//    }
    
}