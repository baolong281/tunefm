//
//  StarsView.swift
//  tunefm
//
//  Created by dylan h on 4/23/26.
//

import SwiftUI
import SwiftUI

// renders stars based on rating
struct StarRatingView: View {
    @Binding var rating: Double
    
    // if looking in feed this should not be editable
    var editable: Bool = true

    var size: CGFloat = 20
    var spacing: CGFloat = 6

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(1...5, id: \.self) { i in
                starView(for: i)
                    .frame(width: size, height: size)
                    .contentShape(Rectangle())
                    .gesture(
                        editable ?
                        DragGesture(minimumDistance: 0)
                            .onEnded { value in
                                // value.location is relative to the frame of the star
                                let half = value.location.x < size / 2 // if we are in the first half of the star
                                let newValue = Double(i) - (half ? 0.5 : 0.0)
                                rating = clamp(newValue)
                            }
                        : nil
                    )
                    .foregroundStyle(.yellow)
            }
        }
    }

    private func starView(for index: Int) -> some View {
        let value = rating

        let name: String
        if value >= Double(index) {
            name = "star.fill"
        } else if value >= Double(index) - 0.5 {
            name = "star.leadinghalf.filled"
        } else {
            name = "star"
        }

        // star images included by apple
        return Image(systemName: name)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }

    // rounds to nearest 0.5 increment and clamps in [0, 5]
    private func clamp(_ x: Double) -> Double {
        min(max((x * 2).rounded() / 2, 0), 5)
    }
}


#Preview {
    StarRatingView(rating: .constant(3.5))
}
