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
    private(set) var poiList = [POI]()
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var state: ResultState = .loading
    @Published var searchText = ""
    
    
    init (service: PoiService){
        self.service = service
    }
    
    
    var filteredPois: [POI] {
        return searchText == "" ? self.poiList : self.poiList.filter {
            $0.title!.lowercased().contains(searchText.lowercased())
        }
    }
    
    
    func refreshData(context: NSManagedObjectContext) {
        self.state = .loading
        self.deleteCoreData(context: context)
        self.poiList.removeAll()
        checkPoiList(context: context)
    }
    
    
    func checkPoiList(context: NSManagedObjectContext){
        fetchCoreData(context: context)
        if self.poiList.isEmpty{
            getPoiList(context: context)
        }else{
            self.state = .success
        }
    }
    
    
    
    private func getPoiList(context: NSManagedObjectContext) {
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
//                self.poiList = response.list
                self.savePoisToCoreData(context: context, poiList: response.list)
            }
        self.cancellables.insert(cancellable)
    }
    
    
    
    
    //MARK: -core data methods
    
    private func savePoisToCoreData (context: NSManagedObjectContext, poiList: [Poi]) {
        
        poiList.forEach { (poi) in
            let entity = POI(context: context)

            entity.id = Int16(poi.id)
            entity.latitude = poi.latitude
            entity.longitude = poi.longitude
            entity.image = poi.image
            entity.title = poi.title
//            do{
//                entity.imageData = try Data(contentsOf: URL(string: poi.image)!)
                let url = URL(string: poi.image)
                let urlRequest = URLRequest(url: url!)
                let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                    entity.imageData = data
                }
                task.resume()

//            }catch{
//                self.state = .failed(error: error)
//            }
            
        }

        //save
        do{
            try context.save()
            
        }catch{
            self.state = .failed(error: error)
        }

    }
    
    private func fetchCoreData(context: NSManagedObjectContext) {
        
        let poiFetch: NSFetchRequest<POI> = POI.fetchRequest()
        let sortById = NSSortDescriptor(keyPath: \POI.id, ascending: true)
        poiFetch.sortDescriptors = [sortById]
        
        do{
            let results = try context.fetch(poiFetch)
//            for result in results {
//                let newPoi = Poi(id: Int(result.id), title: result.title!, latitude: result.latitude, longitude: result.longitude, image: result.image!)
//                self.poiList.append(newPoi)
//            }
            self.poiList = results
        } catch {
            self.state = .failed(error: error)
        }
        
    }
    
    private func deleteCoreData(context: NSManagedObjectContext){
        let poiFetch: NSFetchRequest<POI> = POI.fetchRequest()
        poiFetch.returnsObjectsAsFaults = false
        do {
                let results = try context.fetch(poiFetch)
                for object in results {
                    context.delete(object)
                }
                try context.save()
            } catch let error {
                self.state = .failed(error: error)
            }
    }
    
}
