import SwiftUI

struct ContentView: View {
    // Text editor
    @State private var text: String = ""
    @State private var fontSize: CGFloat = 70
    @FocusState private var isFocused: Bool
    private let placeholders: [(String, UITextContentType?)] = [
        ("Where to?", .fullStreetAddress),
        ("What's your cell number?", .telephoneNumber),
        ("How do you spell your name?", .name),
        ("What can I get you?", nil),
        ("Can I get you a drink?", nil)
    ]
    @State private var placeholderText: String = ""
    @State private var textContentType: UITextContentType?
    
    // Buttons
    private let eraseButtonSize: CGFloat = 35
    private let pasteButtonSize: CGFloat = 30
    @State private var isPlusButtonPressed = false
    @State private var isMinusButtonPressed = false
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var isPressing = false

    private let fontSizeStep: CGFloat = 5
    private let minFontSize: CGFloat = 30
    private let maxFontSize: CGFloat = 150
    private let longPressDelay: TimeInterval = 0.5
    private let longPressInterval: TimeInterval = 0.1

    
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
                                        .init(color: Color(.systemGray6), location: 1)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                ))
                                .contentShape(Rectangle())
                                .frame(height: 60)
                            
                            HStack(spacing: 0) {
                                
                                // Erase button
                                Button {
                                    text = ""
                                } label: {
                                    Image(systemName: "eraser")
                                        .font(.system(size: eraseButtonSize))
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .contentShape(Rectangle())
                                        .accessibility(hidden: true)
                                }
                                    .disabled(text == "")
                                    .accessibilityLabel("Erase")
                                
                                
                                Button {
                                    fontSize = max(minFontSize, fontSize - 10)
                                    
                                } label: {
                                    Image(systemName: "minus")
                                        .font(.system(size: eraseButtonSize))
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .contentShape(Rectangle())
                                        .accessibility(hidden: true)
                                    
                                }
                                    .disabled(fontSize <= minFontSize)
                                    .accessibilityLabel("Decreate Font Size")

//                                    .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity) {
//                                    } onPressingChanged: {
//                                        isPressing in
//                                                self.isPressing = isPressing
//                                        if !isPressing {
//                                            timer.upstream.connect().cancel() // when the isPressing is false that means the game ended
//                                        }
//                                    }
                                
                                
                                
                                // Plus button
                                Button {
                                    fontSize = min(maxFontSize, fontSize + 10)
                                } label: {
                                    Image(systemName: "plus")
                                        .font(.system(size: eraseButtonSize))
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .contentShape(Rectangle())
                                        .accessibility(hidden: true)
                                }
                                    .disabled(fontSize >= maxFontSize)
                                    .accessibilityLabel("Increase Font Size")

                                
                                // Paste button
                                Button {
                                    if (UIPasteboard.general.hasStrings) {
                                        text = UIPasteboard.general.string ?? ""
                                    }
                                } label: {
                                    Image(systemName: "doc.on.clipboard")
                                        .font(.system(size: pasteButtonSize))
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .contentShape(Rectangle())
                                        .accessibility(hidden: true)
                                }
                                    .accessibilityLabel("Paste From Clipboard")
                            }
                            .opacity(isFocused ? 1 : 0)
                        }
                    }
                }
            }
        }
        .onAppear {
            chooseRandomPlaceholder()
        }
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
