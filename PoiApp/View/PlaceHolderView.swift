//
//  PlaceHolderView.swift
//  PoiApp
//
//  Created by Rafa Garrido on 6/3/23.
//

import SwiftUI

struct PlaceholderView: View {
    var body: some View{
        Image(systemName: "photo.fill")
            .foregroundColor(.white)
            .background(Color.gray)
            .frame(width: 100, height: 100)
    }
}

struct PlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceholderView()
            .previewLayout(.sizeThatFits)
    }
}
