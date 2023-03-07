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
    
    //poiList va a ser un array de mi entidad de Core Data
    private(set) var poiList = [POI]()
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var state: ResultState = .loading
    
    @Published var searchText = ""
    
    init (service: PoiService){
        self.service = service
    }
    
    //esta variable me devolverá los POIs filtrados con la búsqueda que se haga en la vista
    var filteredPois: [POI] {
        return searchText == "" ? self.poiList : self.poiList.filter {
            $0.title!.lowercased().contains(searchText.lowercased())
        }
    }
    
    
    //este método borra los datos y los vuelve a pedir
    func refreshData(context: NSManagedObjectContext) {
        self.state = .loading
        self.deleteCoreData(context: context)
        self.poiList.removeAll()
        checkPoiList(context: context)
    }
    
    
    //método para comprobar si hay valores almacenados
    func checkPoiList(context: NSManagedObjectContext){
        fetchCoreData(context: context)
        
        if self.poiList.isEmpty{
            getPoiList(context: context)
        }else{
            self.state = .success
        }
    }
    
    
    //este método conecta con el servicio y recibe los datos obtenidos de la Api
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
                self.savePoisToCoreData(context: context, poiList: response.list)
                self.checkPoiList(context: context)
            }
        self.cancellables.insert(cancellable)
    }
    
    
    
    
    //MARK: -core data methods
    
    //método para almacenar los datos en core data
    private func savePoisToCoreData (context: NSManagedObjectContext, poiList: [Poi]) {
        
        poiList.forEach { (poi) in
            let entity = POI(context: context)
            
            entity.id = Int16(poi.id)
            entity.latitude = poi.latitude
            entity.longitude = poi.longitude
            entity.image = poi.image
            entity.title = poi.title
            do{
                entity.imageData = try Data(contentsOf: URL(string: poi.image)!)
            }catch{
                self.state = .failed(error: error)
            }
            
        }
        
        do{
            try context.save()
        }catch{
            self.state = .failed(error: error)
        }
        

    }
    
    
    //método que obtiene los datos guardados en core data y los guarda en la variable poiList (la lista de los poi)
    private func fetchCoreData(context: NSManagedObjectContext) {
        
        let poiFetch: NSFetchRequest<POI> = POI.fetchRequest()
        let sortById = NSSortDescriptor(keyPath: \POI.id, ascending: true)
        poiFetch.sortDescriptors = [sortById]
        
        do{
            let results = try context.fetch(poiFetch)
            self.poiList = results
        } catch {
            self.state = .failed(error: error)
        }
        
    }
    
    
    //método para eliminar todos los datos de core data de la entidad POI
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
