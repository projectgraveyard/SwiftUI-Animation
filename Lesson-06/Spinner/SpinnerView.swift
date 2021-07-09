import SwiftUI

struct SpinnerView: View {
  struct Leaf: View {
    let rotation: Angle
    let isCurrent: Bool
    
    var body: some View {
      Capsule()
        .stroke(isCurrent ? Color.white : Color.gray, lineWidth: 8)
        .frame(width: 20, height: 50)
        .offset(isCurrent ? .init(width: 10, height: 0) : .init(width: 40, height: 70))
        .scaleEffect(isCurrent ? 0.5 : 1)
        .rotationEffect(rotation)
        .animation(.easeIn(duration: 1.5))
    }
  }
  
  let leavesCount = 12
  @State var currentIndex = -1
  
  var body: some View {
    VStack {
      ZStack {
        ForEach(0 ..< leavesCount) { index in
          Leaf(
            rotation: .init(degrees: .init(index) / .init(leavesCount) * 360),
            isCurrent: index == currentIndex
          )
        }
      }
      .onAppear(perform: animate)
    }
  }
  
  func animate() {
    Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { timer in
      currentIndex = (currentIndex + 1) % leavesCount
    }
  }
}

struct SpinnerView_Previews : PreviewProvider {
  static var previews: some View {
    SpinnerView()
  }
}
