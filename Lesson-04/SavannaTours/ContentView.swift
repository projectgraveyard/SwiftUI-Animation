import SwiftUI

struct ContentView : View {
  @State var zoomed = false
  
  
  var body: some View {
    VStack(spacing: 0) {
      Image("hero")
        .resizable()
        .edgesIgnoringSafeArea(.top)
        .frame(height: 300)
      
      ZStack(alignment: .leading) {
        VStack(alignment: .leading) {
          Text("Savanna Trek")
            .font(.largeTitle)
            .fontWeight(.bold)
            .shadow(radius: 5)
            .foregroundColor(.white)

          Text("15-mile drive followed by an hour-long trek")
            .font(.caption)
            .foregroundColor(.white)
        }
        .offset(
          x: zoomed ? 500 : 30,
          y: -30
        )
        .animation(.default)

        GeometryReader { geometry in
          Image("thumb")
            .clipShape(
              RoundedRectangle(cornerRadius: zoomed ? 40 : 500)
            )
            .overlay(
              Circle()
                .fill(
                  zoomed ? Color.clear : Color(white: 1, opacity: 0.4)
                )
                .scaleEffect(0.8)
            )
            .saturation(zoomed ? 1 : 0)
            .position(
              x: zoomed ? geometry.frame(in: .local) . midX : 600,
              y: 50
            )
            .scaleEffect(zoomed ? 4/3 : 1/3)
            .shadow(radius: 10)
            .animation(.spring())
            .onTapGesture { zoomed.toggle() }
        }
      }
      .background(Color(white: 0.1))
      
      List(0...4, id: \.self) { index in
        VStack(alignment: .leading) {
          Text("Milestone #\(index + 1)")
            .font(.title)
          HStack(alignment: .lastTextBaseline) {
            Text("Savanna National Park (\(index * 12 + 5)km)")
              .font(.subheadline)
            Image(systemName: "pin")
            Spacer()
            Text("South Africa")
              .font(.subheadline)
          }
        }
        .padding()
      }
    }
  }
}

struct ContentView_Previews : PreviewProvider {
  static var previews: some View { ContentView() }
}
