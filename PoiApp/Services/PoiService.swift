//
//  PoiService.swift
//  PoiApp
//
//  Created by Rafa Garrido on 6/3/23.
//

import Foundation
import Combine

struct PoiService {
    
    /*
     He creado un servicio que hace uso del tipo de datos genérico de Swift para poder obtener la respuesta de una API
     y que no esté encorsetado en un tipo de dato concreto
     */
    
    func request<T>(from endpoint: PoiApi, decodingType: T.Type) -> AnyPublisher<T, APIError> where T: Decodable {
        
        return URLSession
            .shared
            .dataTaskPublisher(for: endpoint.urlRequest)
            .receive(on: DispatchQueue.main)
            .mapError{ _ in APIError.unknown }
            .flatMap{ data, response -> AnyPublisher <T, APIError> in
                guard let response = response as? HTTPURLResponse else {
                    return Fail(error: APIError.unknown).eraseToAnyPublisher()
                }
                
                if (200...299).contains(response.statusCode){
                    return Just(data)
                        .decode(type: T.self, decoder: JSONDecoder())
                        .mapError { error in APIError.decodingError(error) }
                        .eraseToAnyPublisher()
                } else {
                    return Fail(error: APIError.errorCode(response.statusCode)).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    
}
