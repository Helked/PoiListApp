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
    
    
    /* esta inicialización es para amoldar la respuesta de la API a mi modelo de datos, ya que el ID se obtiene como un String y lo quiero
    guardar como un Int, y para separar el String de geocoordinates en los valores de la latitud y la longitud
     */
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
 
}


