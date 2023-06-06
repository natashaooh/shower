//
//  EraseButtonView.swift
//  Shower
//
//  Created by Natasha Andreeva on 20.05.2023.
//

import SwiftUI

struct EraseButtonView: View {
    @Binding var text: String
    
    var body: some View {
        let cornerRadius: CGFloat = 7
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: cornerRadius) // Adjust the corner radius value as needed
                            .stroke(Color(UIColor.systemGray), lineWidth: 5)
                            .padding(5)
                            .aspectRatio(0.6, contentMode: .fit)
                            .opacity(text.isEmpty ? 0.15 : 1)
                            .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
                            .onTapGesture {
                                if !text.isEmpty {
                                    text = ""
                                }
                            }
                            
//            Path { path in
//                let width = min(geometry.size.width, geometry.size.height)
//                let height = width * 1.5
//                let padding: CGFloat = 10 // Adjust the padding value as needed
//                let paddedWidth = width - (padding * 2)
//                let paddedHeight = height - (padding * 2)
//
//                path.move(to: CGPoint(x: padding, y: padding))
//                path.addRoundedRect(
//                    in: CGRect(x: padding, y: padding, width: paddedWidth, height: paddedHeight),
//                    cornerSize: CGSize(width: cornerRadius, height: cornerRadius)
//                )
//
//            }
//            .stroke(Color(UIColor.systemGray), lineWidth: 10)
            

        }
    }
}

struct EraseButtonView_Previews: PreviewProvider {
    static var previews: some View {
        EraseButtonView(text: .constant(""))
    }
}
