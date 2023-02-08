//
//  AnimatableCustomFontModifier.swift
//  SwiftUI-Content
//
//  Created by Leonardo Maffei on 29/01/23.
//

import SwiftUI

struct AnimatableCustomFontModifier: AnimatableModifier {
  var animatableData: CGFloat {
    get { size }
    set { size = newValue }
  }
  var size: CGFloat

  func body(content: Content) -> some View {
    content
      .font(.system(size: size))
  }
}

extension View {
  func animatableFont(size: CGFloat) -> some View {
    modifier(AnimatableCustomFontModifier(size: size))
  }
}
