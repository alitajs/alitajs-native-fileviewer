import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(FileViewerPlugin)
public class FileViewerPlugin: CAPPlugin, UIDocumentInteractionControllerDelegate {
    
    var savedCall: CAPPluginCall?
    
    @objc func openDocument(_ call: CAPPluginCall) {
        if let filePath = call.getString("filePath"), let fileURL = URL(string: filePath) {
            let docVC = UIDocumentInteractionController(url: fileURL)
            docVC.delegate = self
            savedCall = call
            DispatchQueue.main.async { [weak self] in
                let canOpen = docVC.presentPreview(animated: true)
                if canOpen {
                } else {
                    self?.savedCall = nil
                    call.reject("无法打开该文件", "cannotOpen")
                }
            }
        } else {
            call.reject("文件路径为空", "filePathEmpty")
        }
    }
    
    @objc func previewImage(_ call: CAPPluginCall) {
        
    }
    
//    MARK: UIDocumentInteractionControllerDelegate
    public func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return (self.bridge?.viewController)!
    }
    
    public func documentInteractionControllerWillBeginPreview(_ controller: UIDocumentInteractionController) {
        if (savedCall != nil) {
            savedCall?.resolve()
            savedCall = nil
        }
    }
}
