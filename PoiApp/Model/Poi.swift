//
//  Poi.swift
//  PoiApp
//
//  Created by Rafa Garrido on 6/3/23.
//

import Foundation


struct PoiList: Decodable{
    var list: [Poi]
}



struct Poi: Decodable, Hashable {
    var id: Int
    var title: String
    var latitude: Double
    var longitude: Double
    var image: String

    
    enum CodingKeys: String, CodingKey{
        case id, title, longitude, latitude, image
        case geocoordinates
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: CodingKeys.title)
        image = try container.decode(String.self, forKey: CodingKeys.image)
        
        let idString = try container.decode(String.self, forKey: CodingKeys.id)
        guard let idInt = Int(idString) else {
            let context = DecodingError.Context(codingPath: container.codingPath + [CodingKeys.id], debugDescription: "Could not parse json key to a Int object")
            throw DecodingError.dataCorrupted(context)
        }
        id = idInt
        
        let geocoordinateString = try container.decode(String.self, forKey: CodingKeys.geocoordinates)
        let coordinateArray = geocoordinateString.components(separatedBy: ",")
        
        guard let latDouble = Double(coordinateArray[0]) else {
            let context = DecodingError.Context(codingPath: container.codingPath + [CodingKeys.geocoordinates], debugDescription: "Could not parse latitude key to a Double object")
            throw DecodingError.dataCorrupted(context)
        }
        latitude = latDouble
        
        guard let longDouble = Double(coordinateArray[1]) else {
            let context = DecodingError.Context(codingPath: container.codingPath + [CodingKeys.geocoordinates], debugDescription: "Could not parse longitude key to a Double object")
            throw DecodingError.dataCorrupted(context)
        }
        longitude = longDouble
    }
    
    init(id: Int, title: String, latitude: Double, longitude: Double, image: String){
        self.id = id
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
        self.image = image
    }
}


extension Poi {
    static var dummyData: Poi {
        .init(id: 1,
              title: "Camp Nou",
              latitude: 41.3809,
              longitude: 2.1206311,
              image: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fc/Camp_Nou_aerial_%28cropped%29.jpg/150px-Camp_Nou_aerial_%28cropped%29.jpg")
    }
}
