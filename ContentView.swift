import SwiftUI

struct ContentView: View {
    @State private var inputUrl: String = ""
    @State private var videoId: String?
    @State private var showScanner = false
    
    var body: some View {
        VStack {
            TextField("YouTube-URL eingeben", text: $inputUrl)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Button("Video anzeigen") {
                    videoId = extractVideoID(from: inputUrl)
                }
                .padding()
                
                Button("QR-Code scannen") {
                    showScanner = true
                }
                .padding()
            }
            
            if let videoId = videoId {
                WebView(url: URL(string: "https://www.youtube-nocookie.com/embed/\(videoId)?rel=0")!)
                    .frame(minHeight: 300)
            }
        }
        .sheet(isPresented: $showScanner) {
            QRScannerView(scannedCode: $inputUrl, isPresented: $showScanner) {
                videoId = extractVideoID(from: inputUrl)
            }
        }
        .padding()
    }
    
    func extractVideoID(from url: String) -> String? {
        if let id = URLComponents(string: url)?
            .queryItems?.first(where: { $0.name == "v" })?.value {
            return id
        }
        
        if let shortId = URL(string: url)?.lastPathComponent, shortId.count == 11 {
            return shortId
        }
        
        return nil
    }
}
