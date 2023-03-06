//
//  ResultState.swift
//  PoiApp
//
//  Created by Rafa Garrido on 6/3/23.
//

import Foundation

enum ResultState {
    case loading
    case success
    case failed(error: Error)
}
