import SwiftUI

struct ContentView: View {
    @State private var text: String = ""
    @State private var fontSize: CGFloat = 70
    @State private var isSliderShown = true
    @State private var hideSliderTimer: Timer?
    private let eraseButtonSize: CGFloat = 60
    @FocusState private var isFocused: Bool
    private let hideSliderAfterInactivityInterval: TimeInterval = 3
    private let placeholders: [(String, UITextContentType?)] = [
        ("Where to?", .fullStreetAddress),
        ("What's your cell number?", .telephoneNumber),
        ("How do you spell your name?", .name),
        ("What can I get you?", nil),
        ("Can I get you a drink?", nil)
    ]
    @State private var placeholderText: String = ""
    @State private var textContentType: UITextContentType?
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                ZStack {
                    ZStack(alignment: .leading) {
                        if text.isEmpty {
                           VStack {
                                Text(placeholderText)
                                    .padding(EdgeInsets(top: 23, leading: 21, bottom: 20, trailing: 20))
                                    .font(.system(size: fontSize, weight: .bold))
                                    .foregroundColor(Color(UIColor.systemGray))
                                Spacer()
                            }
                        }
                        TextEditor(text: $text)
                            .foregroundColor(Color(UIColor.systemGray))
                            .font(.system(size: fontSize, weight: .bold))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .scrollContentBackground(.hidden)
                            .background(Color(.systemGray6))
                            .padding()
                            .minimumScaleFactor(0.5)
                            .textContentType(textContentType)
                            .opacity(text.isEmpty ? 0.85 : 1)
                            .focused($isFocused)
                            .gesture( // Hide keyboard on drag down
                                DragGesture()
                                    .onChanged { value in
                                        if value.translation.height > 0 {
                                            isFocused = false
                                        }
                                    }
                            )
                            .onAppear {
                                        isFocused = true
                                    }
                    }
                    
                    VStack(spacing: 0) {
                        Spacer()
                        ZStack {
                            Rectangle()
                                .fill(LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: Color(.clear), location: 0),
                                        .init(color: Color(.systemGray6), location: 0.5),
                                        .init(color: Color(.systemGray6), location: 1)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                ))
                                .contentShape(Rectangle())
                                .frame(height: 60)
                                .gesture(TapGesture().onEnded {
                                    withAnimation(.easeIn(duration: 0.2)) {
                                        isSliderShown = true
                                    }
                                    startHideSliderTimer()
                                })
                            
                            HStack(spacing: 0) {
                                EraseButtonView(text: $text)
                                    .frame(width: eraseButtonSize, height: eraseButtonSize * 1.5)
                                    .padding(.leading, 10)
                                
                                Slider(value: $fontSize, in: 30...100, step: 1)
                                    .padding(.horizontal)
                                    .cornerRadius(10)
                                    .onChange(of: fontSize) { _ in
                                        resetHideSliderTimer()
                                    }
                                    .onAppear {
                                        startHideSliderTimer()
                                    }
                                    .onDisappear {
                                        invalidateHideSliderTimer()
                                    }
                                    
                            }
                            .opacity(isSliderShown ? 1 : 0)
                        }
                    }
                }
            }
        }
        .onAppear {
            chooseRandomPlaceholder()
        }
    }
    
    private func startHideSliderTimer() {
        hideSliderTimer?.invalidate()
        hideSliderTimer = Timer.scheduledTimer(withTimeInterval: hideSliderAfterInactivityInterval, repeats: false) { _ in
            withAnimation(.easeIn(duration: 0.2)) {
                isSliderShown = false
            }
        }
    }
    
    private func resetHideSliderTimer() {
        hideSliderTimer?.invalidate()
        startHideSliderTimer()
    }
    
    private func invalidateHideSliderTimer() {
        hideSliderTimer?.invalidate()
        hideSliderTimer = nil
    }
    
    private func chooseRandomPlaceholder() {
        if let randomPlaceholder = placeholders.randomElement() {
            placeholderText = randomPlaceholder.0
            textContentType = randomPlaceholder.1
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
