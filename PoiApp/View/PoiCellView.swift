//
//  PoiCellView.swift
//  PoiApp
//
//  Created by Rafa Garrido on 6/3/23.
//

import SwiftUI
import UIKit

struct PoiCellView: View {
    var poi: POI
    private let width : CGFloat = 100
    private let height : CGFloat = 100
    var body: some View {
        HStack (spacing: 10, content: {
            
            if(poi.imageData != nil){
                Image(uiImage: UIImage(data: poi.imageData!)!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: self.width, height: self.height, alignment: .center)
                    .clipped()
                    .cornerRadius(15)
            }else{
                Image(systemName: "mappin.and.ellipse")
                    .resizable()
                    .frame(width: self.width, height: self.height, alignment: .center)
                    .clipped()
                    .cornerRadius(15)
                    .foregroundColor(.gray)
            }
            
            Text(poi.title ?? "No title")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.black)
        })
    }
}

