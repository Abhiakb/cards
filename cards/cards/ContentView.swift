import SwiftUI

struct SwipeCardView: View {
    let title: String
    var onRemove: (_ liked: Bool) -> Void
    
    @State private var offset: CGSize = .zero
    @GestureState private var isDragging = false
    
    var body: some View {
        ZStack {
            // Background image (static, not swipable)
            Image("background")
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 400)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 8)

            // Overlay card (this is swipable)
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.9))
                .frame(width: 300, height: 400)
                .overlay(
                    VStack {
                        Text(title)
                            .font(.title)
                            .bold()
                            .padding(.top, 40)
                        Spacer()
                    }
                )
                .overlay(
                    VStack {
                        HStack {
                            if offset.width > 0 {
                                Text("LIKE")
                                    .font(.headline)
                                    .foregroundColor(.green)
                                    .padding()
                                    .background(Color.white.opacity(0.7))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding()
                                Spacer()
                            }
                            if offset.width < 0 {
                                Spacer()
                                Text("NOPE")
                                    .font(.headline)
                                    .foregroundColor(.red)
                                    .padding()
                                    .background(Color.white.opacity(0.7))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding()
                            }
                        }
                        Spacer()
                    }
                )
                .offset(x: offset.width, y: offset.height)
                .rotationEffect(.degrees(Double(offset.width / 15)))
                .gesture(
                    DragGesture()
                        .updating($isDragging) { _, state, _ in
                            state = true
                        }
                        .onChanged { gesture in
                            withAnimation(.interactiveSpring(response: 0.35, dampingFraction: 0.7, blendDuration: 0.7)) {
                                offset = gesture.translation
                            }
                        }
                        .onEnded { _ in
                            if abs(offset.width) > 120 {
                                let liked = offset.width > 0
                                withAnimation(.easeIn(duration: 0.3)) {
                                    offset.width = liked ? 1000 : -1000
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    onRemove(liked)
                                }
                            } else {
                                withAnimation(.spring()) {
                                    offset = .zero
                                }
                            }
                        }
                )
        }
    }
}

struct ContentView: View {
    @State private var cards = [
        "User 1",
        "User 2",
        "User 3"
    ]
    
    var body: some View {
        ZStack {
            ForEach(cards, id: \.self) { card in
                SwipeCardView(title: card) { liked in
                    withAnimation {
                        cards.removeAll { $0 == card }
                    }
                    print("\(card) \(liked ? "liked ✅" : "disliked ❌")")
                }
            }
        }
    }
}

