import Foundation
import Capacitor

extension NSNotification.Name {
    static var photoviewerExit: Notification.Name {return .init(rawValue: "photoviewerExit")}
}

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(FileViewerPlugin)
public class FileViewerPlugin: CAPPlugin, UIDocumentInteractionControllerDelegate {
    
    var savedCall: CAPPluginCall?
    private let photoViewerImp = PhotoViewer()
    var exitObserver: Any?
    
    public override func load() {
        self.addObserversToNotificationCenter()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(exitObserver as Any)
    }
    
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
        guard let imageList = call.options["images"] as? [[String: String]] else {
            let error: String = "Must provide an image list"
            print(error)
            call.reject("Show : \(error)")
            return
        }
        if imageList.count == 0 {
            let error: String = "Must provide a non-empty image list"
            print(error)
            call.reject("Show : \(error)")
            return

        }
        let mode: String = call.getString("mode") ?? "slider"
        let startFrom: Int = call.getInt("startFrom") ?? 0
        let options: JSObject = call.getObject("options", JSObject())
        var mOptions: [String: Any] = [:]
        let keys = options.keys
        if keys.count > 0 {
            if keys.contains("spancount") {
                mOptions["spancout"] = options["spancout"] as? Int
            }
            if keys.contains("share") {
                mOptions["share"] = options["share"] as? Bool
            }
            if keys.contains("title") {
                mOptions["title"] = options["title"] as? String
            }

        }

        // Display
        DispatchQueue.main.async { [weak self] in
            if imageList.count > 1 && mode == "gallery" {
                guard ((self?.photoViewerImp.show(imageList, mode: mode,
                                                  startFrom: startFrom,
                                                  options: options)) != nil),
                      let collectionController = self?.photoViewerImp.collectionController else {
                    call.reject("Show : Unable to show the CollectionViewController")
                    return
                }
                collectionController.modalPresentationStyle = .fullScreen
                self?.bridge?.viewController?.present(collectionController, animated: true, completion: {
                    call.resolve(["result": true])
                })
            } else if mode == "one" {
                guard ((self?.photoViewerImp.show(imageList, mode: mode,
                                                  startFrom: startFrom,
                                                  options: options)) != nil),
                      let oneImageController = self?.photoViewerImp.oneImageController else {
                    call.reject("Show : Unable to show the OneImageViewController")
                    return
                }
                oneImageController.modalPresentationStyle = .fullScreen
                self?.bridge?.viewController?.present(oneImageController, animated: true, completion: {
                    call.resolve(["result": true])
                })

            } else if mode == "slider" {
                guard ((self?.photoViewerImp.show(imageList, mode: mode,
                                                  startFrom: startFrom,
                                                  options: options)) != nil),
                      let sliderController = self?.photoViewerImp.sliderController else {
                    call.reject("Show : Unable to show the SliderViewController")
                    return
                }
                sliderController.modalPresentationStyle = .fullScreen
                self?.bridge?.viewController?.present(sliderController, animated: true, completion: {
                    call.resolve(["result": true])
                })

            } else {
                call.reject("Show : Mode \(mode) not implemented")
            }
            return

        }

    }
    
    @objc func addObserversToNotificationCenter() {
        // add Observers
        exitObserver = NotificationCenter
            .default.addObserver(forName: .photoviewerExit, object: nil,
                                 queue: nil,
                                 using: photoViewerExit)
    }
    
    // MARK: - PhotoViewerExit

    @objc func photoViewerExit(notification: Notification) {
        guard let info = notification.userInfo as? [String: Any] else { return }
        DispatchQueue.main.async {
            self.notifyListeners("jeepCapPhotoViewerExit", data: info, retainUntilConsumed: true)
            return
        }
    }
    
//    MARK: - UIDocumentInteractionControllerDelegate
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
