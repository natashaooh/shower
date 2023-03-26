import SwiftUI

struct ContentView: View {
    @State private var text: String = ""
    @State private var fontSize: CGFloat = 70
    @State private var isSliderShown = true
    @State private var hideSliderTimer: Timer?
    private let hideSliderAfterInactivityInterval: TimeInterval = 3
    private let placeholders = [
        "What can I get you?",
        "Can I get you a drink?",
        "Where to?",
        "What's your cell number?",
        "How's your name spelled?"
    ]
    @State private var placeholderText = ""
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ZStack {
                    ZStack(alignment: .leading) {
                        if text.isEmpty {
                           VStack {
                                Text(placeholderText)
                                    .padding(EdgeInsets(top: 23, leading: 21, bottom: 20, trailing: 20))
                                    .font(.system(size: fontSize, weight: .bold))
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
                            .textContentType(.name)
                            .scrollDismissesKeyboard(.immediately)
                            .opacity(text.isEmpty ? 0.85 : 1)
                    }
                    
                    VStack {
                        Spacer()
                        ZStack {
                            Rectangle()
                                .fill(Color.clear)
                                .contentShape(Rectangle())
                                .frame(height: 40)
                                .gesture(TapGesture().onEnded {
                                    withAnimation(.easeIn(duration: 0.2)) {
                                        isSliderShown = true
                                    }
                                    startHideSliderTimer()
                                })
                            Slider(value: $fontSize, in: 30...100, step: 5)
                                .padding(.horizontal)
                                .padding(.bottom)
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
        placeholderText = placeholders.randomElement() ?? ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
