import SwiftUI

@available(iOS 14, tvOS 14, macOS 13, *)
public extension Image {
    init(data: Data?) {
        if let imageData = data {
            #if os(macOS)
                if let nsImage = NSImage(data: imageData) {
                    self.init(nsImage: nsImage)
                }
            #else
                if let uiImage = UIImage(data: imageData) {
                    self.init(uiImage: uiImage)
                }
            #endif
        }
        self.init(systemName: "placeholdertext.fill")
    }

    init(data: Data) {
        #if os(macOS)
            if let nsImage = NSImage(data: data) {
                self.init(nsImage: nsImage)
            }
        #else
            if let uiImage = UIImage(data: data) {
                self.init(uiImage: uiImage)
            }
        #endif

        self.init(systemName: "placeholdertext.fill")
    }
}
