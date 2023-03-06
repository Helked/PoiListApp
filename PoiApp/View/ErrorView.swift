//
//  ErrorView.swift
//  PoiApp
//
//  Created by Rafa Garrido on 6/3/23.
//

import SwiftUI

struct ErrorView: View {
    
    
    typealias ErrorViewActionHandler = () -> Void
    
    let error: Error
    let handler: ErrorViewActionHandler
    let errorButtonText: String
    
    internal init(error: Error, errorButtonText: String, handler: @escaping ErrorView.ErrorViewActionHandler) {
        self.error = error
        self.handler = handler
        self.errorButtonText = errorButtonText
    }
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.icloud.fill")
                .foregroundColor(.gray)
                .font(.system(size: 50, weight: .heavy))
            Text("Ooops")
                .foregroundColor(.black)
                .font(.system(size: 30, weight: .heavy))
            Text(error.localizedDescription)
                .foregroundColor(.gray)
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
                .padding(.vertical, 4)
            
            Button(action: {
                handler()
            }, label: {
                Text(errorButtonText)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 30)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            })
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: APIError.unknown, errorButtonText: "Retry"){}
            .previewLayout(.sizeThatFits)
    }
}
