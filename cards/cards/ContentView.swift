import SwiftUI

// MARK: - Payment Successful Card
struct PaymentSuccessfulCard: View {
    var body: some View {
        ZStack {
            // Main teal background card
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.0078, green: 0.6431, blue: 0.5882)) // #02A496
                .frame(width: 320, height: 450)
                .shadow(radius: 10)
            
            VStack(spacing: 20) {
                // Top section with payment status and date/time
                VStack(spacing: 8) {
                    Text("Payment Successful")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("21 Sept 2025, 09.33 AM")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.top, 30)
                
                Spacer()
                
                // White inner card with ALL transaction details
                VStack(spacing: 20) {
                    // Airplane icon at top center of white card
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.2))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "airplane")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                    
                    // Merchant details
                    VStack(spacing: 8) {
                        Text("Make My Trip")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                        Text("makemytrip@okicici")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    // Transaction amount
                    Text("₹ 7,990")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    // Separator line
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                        .padding(.horizontal, 20)
                    
                    // Category section
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.green.opacity(0.2))
                                .frame(width: 30, height: 30)
                            
                            Image(systemName: "airplane")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                        
                        Text("Travel & Holidays")
                            .font(.subheadline)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Text("Change")
                            .font(.caption)
                            .foregroundColor(Color(red: 0.0, green: 0.5, blue: 0.5))
                    }
                    .padding(.horizontal, 10)
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 15)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                )
                .padding(.bottom, 30)
            }
            .frame(width: 300, height: 420) // keep content nicely inside
        }
    }
}

// MARK: - Split with Friends Card
struct SplitWithFriendsCard: View {
    var body: some View {
        ZStack {
            // Main teal background card with correct color #17A2B8
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.09, green: 0.64, blue: 0.72)) // #17A2B8
                .frame(width: 320, height: 450)
                .shadow(radius: 10)
            
            VStack(spacing: 30) {
                Spacer()
                
                // Group icon in white circle
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 50))
                        .foregroundColor(Color(red: 0.09, green: 0.64, blue: 0.72)) // #17A2B8
                }
                
                // Straight text positioned below the logo
                Text("Split with Friends")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
            }
        }
    }
}

// MARK: - Swipeable Card Container
struct SwipeableCardView: View {
    @State private var currentCardIndex = 0
    @State private var offset: CGSize = .zero
    @GestureState private var isDragging = false
    
    private let cards = ["payment", "split"]
    
    var body: some View {
        ZStack {
            // Background cards (stacked)
            ForEach(0..<cards.count, id: \.self) { index in
                if index >= currentCardIndex {
                    Group {
                        if cards[index] == "payment" {
                            PaymentSuccessfulCard()
                        } else {
                            SplitWithFriendsCard()
                        }
                    }
                    .offset(x: CGFloat(index - currentCardIndex) * 20, y: CGFloat(index - currentCardIndex) * 10)
                    .scaleEffect(1.0 - CGFloat(index - currentCardIndex) * 0.05)
                    .opacity(index == currentCardIndex ? 1.0 : 0.7)
                }
            }
            
            // Foreground card (swipeable)
            if currentCardIndex < cards.count {
                Group {
                    if cards[currentCardIndex] == "payment" {
                        PaymentSuccessfulCard()
                    } else {
                        SplitWithFriendsCard()
                    }
                }
                .offset(x: offset.width, y: offset.height)
                .rotationEffect(.degrees(Double(offset.width / 20)))
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
                            if abs(offset.width) > 100 {
                                // Only allow swiping to next card if we're not on the last card
                                if currentCardIndex < cards.count - 1 {
                                    withAnimation(.easeIn(duration: 0.3)) {
                                        offset.width = offset.width > 0 ? 1000 : -1000
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        currentCardIndex += 1
                                        offset = .zero
                                    }
                                } else {
                                    // If we're on the last card, just snap back
                                    withAnimation(.spring()) {
                                        offset = .zero
                                    }
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
}

// MARK: - Header View
struct HeaderView: View {
    var body: some View {
        HStack {
            // Back button
            Button(action: {}) {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            // Title
            Text("Transactions History")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Spacer()
            
            // Filter button
            Button(action: {}) {
                Image(systemName: "line.3.horizontal.decrease")
                    .font(.title2)
                    .foregroundColor(.black)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
}

// MARK: - Bottom Navigation View
struct BottomNavigationView: View {
    @State private var selectedTab = 2 // Transactions tab is selected
    
    var body: some View {
        HStack(spacing: 0) {
            // Wallet Tab
            Button(action: { selectedTab = 0 }) {
                VStack(spacing: 4) {
                    Image(systemName: "wallet.pass")
                        .font(.title2)
                        .foregroundColor(selectedTab == 0 ? Color(red: 0.0, green: 0.5, blue: 0.5) : .gray)
                    
                    Text("Wallet")
                        .font(.caption)
                        .foregroundColor(selectedTab == 0 ? Color(red: 0.0, green: 0.5, blue: 0.5) : .gray)
                }
            }
            .frame(maxWidth: .infinity)
            
            // Scan Tab
            Button(action: { selectedTab = 1 }) {
                VStack(spacing: 4) {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.title2)
                        .foregroundColor(selectedTab == 1 ? Color(red: 0.0, green: 0.5, blue: 0.5) : .gray)
                    
                    Text("Scan")
                        .font(.caption)
                        .foregroundColor(selectedTab == 1 ? Color(red: 0.0, green: 0.5, blue: 0.5) : .gray)
                }
            }
            .frame(maxWidth: .infinity)
            
            // Transactions Tab
            Button(action: { selectedTab = 2 }) {
                VStack(spacing: 4) {
                    Image(systemName: "doc.text.clock")
                        .font(.title2)
                        .foregroundColor(selectedTab == 2 ? Color(red: 0.0, green: 0.5, blue: 0.5) : .gray)
                    
                    Text("Transactions")
                        .font(.caption)
                        .foregroundColor(selectedTab == 2 ? Color(red: 0.0, green: 0.5, blue: 0.5) : .gray)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(Color.white)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: -2)
    }
}

// MARK: - Main Content View
struct ContentView: View {
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HeaderView()
            
            // Main content area
            Spacer()
            
            // Swipeable cards
            SwipeableCardView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Spacer()
            
            // Bottom navigation
            BottomNavigationView()
        }
        .background(Color.white)
        .ignoresSafeArea(.all, edges: .bottom)
    }
}


