//
//  PoiEndpoint.swift
//  PoiApp
//
//  Created by Rafa Garrido on 6/3/23.
//

import Foundation

protocol APIBuilderProtocol {
    var baseUrl: URL { get }
    var path: String { get }
    var urlRequest: URLRequest { get }
}


enum PoiApi {
    case getPoiList
}


extension PoiApi: APIBuilderProtocol {
    var baseUrl: URL {
        return URL(string: API_URL)!
    }
    
    var path: String {
        switch self {
        case .getPoiList:
            return "pois.json"
        }
    }
    
    var urlRequest: URLRequest {
        return URLRequest(url: baseUrl.appending(component: self.path))
    }
}
