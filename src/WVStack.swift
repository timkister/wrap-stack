import SwiftUI

public struct WVStack: View {
  @usableFromInline var alignment: HorizontalAlignment
  @usableFromInline var columnAlignment: VerticalAlignment
  @usableFromInline var spacing: CGFloat
  @usableFromInline var columnSpacing: CGFloat?
  @usableFromInline let content: [AnyView]
  @State private var width: CGFloat = 0

  @usableFromInline init(
    alignment: HorizontalAlignment?,
    columnAlignment: VerticalAlignment?,
    spacing: CGFloat?,
    columnSpacing: CGFloat?,
    content: [AnyView]
  ) {
    self.alignment = alignment ?? .center
    self.columnAlignment = columnAlignment ?? .top
    self.spacing = spacing ?? 0
    self.columnSpacing = columnSpacing
    self.content = content
  }
  
  // Work-around for https://bugs.swift.org/browse/SR-11628
  @inlinable public init<Content: View>(
    alignment: HorizontalAlignment? = nil,
    columnAlignment: VerticalAlignment? = nil,
    spacing: CGFloat? = nil,
    columnSpacing: CGFloat? = nil,
    content: () -> Content
  ) {
    self.init(
      alignment: alignment,
      columnAlignment: columnAlignment,
      spacing: spacing,
      columnSpacing: columnSpacing,
      content: [AnyView(content())]
    )
  }
  
  @inlinable public init<Content: View>(
    alignment: HorizontalAlignment? = nil,
    columnAlignment: VerticalAlignment? = nil,
    spacing: CGFloat? = nil,
    columnSpacing: CGFloat? = nil,
    content: () -> [Content]
  ) {
    self.init(
      alignment: alignment,
      columnAlignment: columnAlignment,
      spacing: spacing,
      columnSpacing: columnSpacing,
      content: content().map { AnyView($0) }
    )
  }
  
  // Known issue: https://bugs.swift.org/browse/SR-11628
  @inlinable public init(
    alignment: HorizontalAlignment? = nil,
    columnAlignment: VerticalAlignment? = nil,
    spacing: CGFloat? = nil,
    columnSpacing: CGFloat? = nil,
    @ViewArrayBuilder content: () -> [AnyView]
  ) {
    self.init(
      alignment: alignment,
      columnAlignment: columnAlignment,
      spacing: spacing,
      columnSpacing: columnSpacing,
      content: content()
    )
  }

  public var body: some View {
    GeometryReader { p in
      WrapStack(
        height: p.frame(in: .global).height,
        verticalAlignment: columnAlignment,
        horizontalAlignment: alignment,
        spacing: spacing,
        laneSpacing: columnSpacing,
        content: content
      )
      .anchorPreference(
        key: SizePref.self,
        value: .bounds,
        transform: {
          p[$0].size
        }
      )
    }
    .frame(width: width)
    .onPreferenceChange(SizePref.self) {
      width = $0.width
    }
  }
}

struct WVStack_Previews: PreviewProvider {
  @ViewArrayBuilder static func single() -> [AnyView] {
    Color.purple.frame(width: 50, height: 50)
  }
  
  static var previews: some View {
    let data: [(color: Color, width: CGFloat, height: CGFloat)] = [
      (Color.red, width: 150, height: 100),
      (Color.green, width: 50, height: 150),
      (Color.yellow, width: 100, height: 150),
      (Color.orange, width: 50, height: 50),
      (Color.purple, width: 30, height: 50),
      (Color.blue, width: 50, height: 50),
      (Color.gray, width: 50, height: 50),
      (Color.green, width: 50, height: 50),
      (Color.yellow, width: 100, height: 150),
      (Color.orange, width: 50, height: 50),
      (Color.purple, width: 30, height: 50),
      (Color.red, width: 150, height: 100),
      (Color.green, width: 50, height: 150),
      (Color.yellow, width: 100, height: 150),
      (Color.orange, width: 50, height: 50),
      (Color.purple, width: 30, height: 50),
      (Color.blue, width: 50, height: 50),
      (Color.gray, width: 50, height: 50),
      (Color.green, width: 50, height: 50),
      (Color.blue, width: 50, height: 50),
      (Color.gray, width: 50, height: 50),
      (Color.green, width: 50, height: 50),
    ]

    return Group {
      WVStack(alignment: .center, spacing: 10) {
          data.map {
              $0.color.frame(width: $0.width, height: $0.height)
          }
      }
      //.frame(height: 350)
      .border(Color.black, width: 1)

      ScrollView {
        VStack {
          Group {
            Text("Header")
            Spacer()
          }
          Group {
            WVStack { () -> [AnyView] in }

            // FIXME: https://bugs.swift.org/browse/SR-11628
            WVStack {
              Color.red
            }
          }
          Group {
            
            // FIXME: https://bugs.swift.org/browse/SR-11628
            WVStack(content: single)
            
            WVStack {
              Color.red
              Color.gray.frame(width: 80, height: 50)
            }
            
            WVStack {
              Color.red
              Color.gray.frame(width: 80, height: 50)
              Color.green.frame(width: 150, height: 30)
            }
            
            WVStack {
              Color.red
              Color.gray.frame(width: 80, height: 50)
              Color.green.frame(width: 150, height: 30)
              Color.yellow.frame(width: 150, height: 70)
            }
            
            WVStack {
              Color.red
              Color.gray.frame(width: 80, height: 50)
              Color.green.frame(width: 150, height: 30)
              Color.yellow.frame(width: 150, height: 70)
              Color.orange.frame(width: 50, height: 50)
            }
            
            WVStack {
              Color.red
              Color.gray.frame(width: 80, height: 50)
              Color.green.frame(width: 150, height: 30)
              Color.yellow.frame(width: 150, height: 70)
              Color.orange.frame(width: 50, height: 50)
              Color.purple.frame(width: 50, height: 50)
            }
            
            WVStack {
              Color.red
              Color.gray.frame(width: 80, height: 50)
              Color.green.frame(width: 150, height: 30)
              Color.yellow.frame(width: 150, height: 70)
              Color.orange.frame(width: 50, height: 50)
              Color.purple.frame(width: 50, height: 50)
              Color.blue.frame(width: 50, height: 50)
            }
            
            WVStack {
              Color.red
              Color.gray.frame(width: 80, height: 50)
              Color.green.frame(width: 150, height: 30)
              Color.yellow.frame(width: 150, height: 70)
              Color.orange.frame(width: 50, height: 50)
              Color.purple.frame(width: 50, height: 50)
              Color.blue.frame(width: 50, height: 50)
              Color.black.frame(width: 50, height: 50)
            }
            
            WVStack {
              Color.red
              Color.gray.frame(width: 80, height: 50)
              Color.green.frame(width: 150, height: 30)
              Color.yellow.frame(width: 150, height: 70)
              Color.orange.frame(width: 50, height: 50)
              Color.purple.frame(width: 50, height: 50)
              Color.blue.frame(width: 50, height: 50)
              Color.black.frame(width: 50, height: 50)
              Color.pink.frame(width: 50, height: 50)
            }
            
            WVStack {
              Color.red
              Color.gray.frame(width: 80, height: 50)
              Color.green.frame(width: 150, height: 30)
              Color.yellow.frame(width: 150, height: 70)
              Color.orange.frame(width: 50, height: 50)
              Color.purple.frame(width: 50, height: 50)
              Color.blue.frame(width: 50, height: 50)
              Color.black.frame(width: 50, height: 50)
              Color.pink.frame(width: 50, height: 50)
              Color.white.frame(width: 50, height: 50)
            }
          }
          
          Group {
            WVStack(alignment: .trailing, spacing: 10) {[
              Color.red.frame(width: 100, height: 50),
              Color.gray.frame(width: 80, height: 50),
              Color.green.frame(width: 150, height: 30),
              Color.yellow.frame(width: 150, height: 70),
              Color.orange.frame(width: 50, height: 50),
              Color.purple.frame(width: 50, height: 50),
              Color.blue.frame(width: 50, height: 50),
              Color.black.frame(width: 50, height: 50),
              Color.pink.frame(width: 50, height: 50),
              Color.white.frame(width: 50, height: 50),
              ]}
              .frame(width: 350)
              .border(Color.black, width: 1)
          }
          Group {
            Spacer()
            Text("Footer")
          }
        }
      }
    }
  }
}
