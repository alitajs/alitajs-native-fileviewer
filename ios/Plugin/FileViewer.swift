import Foundation

@objc public class FileViewer: NSObject {
    @objc public func echo(_ value: String) -> String {
        print(value)
        return value
    }
}
