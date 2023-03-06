//
//  PoiCellView.swift
//  PoiApp
//
//  Created by Rafa Garrido on 6/3/23.
//

import SwiftUI

struct PoiCellView: View {
    var poi: Poi
    private let width : CGFloat = 100
    private let height : CGFloat = 100
    var body: some View {
        HStack (spacing: 10, content: {

            AsyncImage(
                url: URL(string: poi.image),
                        content: { image in
                            image.resizable()
                                .scaledToFill()
                                .frame(width: self.width, height: self.height, alignment: .center)
                                .clipped()
                                .cornerRadius(15)
                                 
                        },
                        placeholder: {
                            ProgressView()
                                .frame(width: self.width, height: self.height)
                                .clipped()
                        }
            )
            
            
            Text(poi.title)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.black)
        })
    }
}

struct PoiRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        PoiCellView(poi: .dummyData)
            .previewLayout(.sizeThatFits)
    }
}
