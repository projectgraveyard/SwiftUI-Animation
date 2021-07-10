import SwiftUI

struct SpinnerView: View {
  struct Leaf: View {
    let rotation: Angle
    let isCurrent: Bool
    let isCompleting: Bool

    var body: some View {
      Capsule()
        .stroke(isCurrent ? Color.white : .gray, lineWidth: 8)
        .frame(width: 20, height: isCompleting ? 20 : 50)
        .offset(
          isCurrent
            ? .init(width: 10, height: 0)
            : .init(width: 40, height: 70)
        )
        .scaleEffect(isCurrent ? 0.5 : 1)
        .rotationEffect(isCompleting ? .zero : rotation)
        .animation(.easeIn(duration: 1.5))
    }
  }

  let leavesCount = 12
  @State var currentIndex = -1
  @State var completed = false
  @State var isVisible = true
  @State var currentOffset = CGSize.zero

  let shootUp =
    AnyTransition.offset(x: 0, y: -1000)
    .animation(.easeIn(duration: 1))
  
  var body: some View {
    VStack {
      if isVisible {
        ZStack {
          ForEach(0..<leavesCount) { index in
            Leaf(
              rotation: .init(degrees: .init(index) / .init(leavesCount) * 360),
              isCurrent: index == currentIndex,
              isCompleting: completed
            )
          }
        }
        .offset(currentOffset)
        .blur(radius: currentOffset == .zero ? 0 : 10)
        .gesture (
          DragGesture().onChanged { gesture in
            currentOffset = gesture.translation
          }
          .onEnded { gesture in
            if currentOffset.height > 150 { complete() }
          }
        )
        .animation(.easeInOut(duration: 1))
        .transition(shootUp)
        .onAppear(perform: animate)
      }
    }
  }
  
  func complete() {
    guard !completed else { return }
    completed = true
    currentIndex = -1
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
      isVisible = false
    }
  }
  
  func animate() {
    var iteration = 0

    Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { timer in
      currentIndex = (currentIndex + 1) % leavesCount

      iteration += 1
      if iteration == 30 {
        timer.invalidate()
        complete()
      }
    }
  }
}

struct SpinnerView_Previews : PreviewProvider {
  static var previews: some View {
    SpinnerView()
  }
}
