import SwiftUI

struct WrapStack<Content: View>: View {
  let width: CGFloat
  let height: CGFloat
  let verticalAlignment: VerticalAlignment
  let horizontalAlignment: HorizontalAlignment
  let spacing: CGFloat
  let laneSpacing: CGFloat?
  let content: [Content]
  
  private let directionHorizontal: Bool
  private let length: CGFloat
  private let totalLanes: Int
  private let limits: [Int]

  init(
    width: CGFloat? = nil,
    height: CGFloat? = nil,
    verticalAlignment: VerticalAlignment = .center,
    horizontalAlignment: HorizontalAlignment = .center,
    spacing: CGFloat,
    laneSpacing: CGFloat?,
    content: [Content]
  ) {
    self.width = width ?? 0
    self.height = height ?? 0
    self.verticalAlignment = verticalAlignment
    self.horizontalAlignment = horizontalAlignment
    self.spacing = spacing
    self.laneSpacing = laneSpacing
    self.content = content
    let directionHorizontal = width != nil
    let length = directionHorizontal ? width! : height!
    self.directionHorizontal = directionHorizontal
    self.length = length
    
    (totalLanes, limits, _, _) = content.reduce((0, [], 0, length)) {
        (accum, item) -> (Int, [Int], Int, CGFloat) in
        var (lanesSoFar, limits, index, laneLength) = accum
        let itemSize = UIHostingController(rootView: item).view.intrinsicContentSize
        let itemLength = directionHorizontal ? itemSize.width : itemSize.height
        if laneLength + itemLength > length {
          lanesSoFar += 1
          laneLength = itemLength
          limits.append(index)
        } else {
          laneLength += itemLength + spacing
        }
        index += 1
        return (lanesSoFar, limits, index, laneLength)
    }
  }
  
  func lowerLimit(_ index: Int) -> Int {
    limits[index]
  }

  func upperLimit(_ index: Int) -> Int {
    if index == totalLanes - 1 {
      return content.count
    }
    return limits[index + 1]
  }

  func makeRow(_ i: Int) -> some View {
    HStack(alignment: verticalAlignment, spacing: spacing) {
      ForEach(lowerLimit(i) ..< upperLimit(i), id: \.self) {
        content[$0]
      }
    }
    .frame(maxWidth: .infinity, alignment: .init(horizontal: horizontalAlignment, vertical: .center))
    //.clipped()
  }

  func makeColumn(_ i: Int) -> some View {
    VStack(alignment: horizontalAlignment, spacing: spacing) {
      ForEach(lowerLimit(i) ..< upperLimit(i), id: \.self) {
        content[$0]
      }
    }
    .frame(maxHeight: .infinity, alignment: .init(horizontal: .center, vertical: verticalAlignment))
    //.clipped()
  }

  var lanes: some View {
    ForEach(0 ..< totalLanes, id: \.self) { i in
      Group {
        if directionHorizontal {
          makeRow(i)
        } else {
          makeColumn(i)
        }
      }
    }
  }

  var body: some View {
    Group {
      if directionHorizontal {
        VStack(spacing: laneSpacing) {
          lanes
        }
      } else {
        HStack(spacing: laneSpacing) {
          lanes
        }
      }
    }
  }
}
