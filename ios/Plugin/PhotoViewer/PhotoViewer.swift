import Foundation
import Capacitor
import UIKit

enum PhotoViewerError: Error {
    case failed(message: String)
}
@objc public class PhotoViewer: NSObject {
    var collectionViewController: CollectionViewController?
    var oneImageViewController: OneImageViewController?
    var sliderViewController: SliderViewController?

    // MARK: collectionController

    @objc var collectionController: CollectionViewController? {
        return collectionViewController
    }
    // MARK: oneImageController

    @objc var oneImageController: OneImageViewController? {
        return oneImageViewController
    }
    // MARK: oneImageController

    @objc var sliderController: SliderViewController? {
        return sliderViewController
    }

    // MARK: show

    @objc public func show(_ imageList: [[String: String]],
                           mode: String, startFrom: Int,
                           options: [String: Any]) -> Bool {
        if imageList.count > 1  && mode == "gallery" {
            collectionViewController = CollectionViewController()
            collectionViewController?.imageList = imageList
            collectionViewController?.options = options
            return true
        } else if mode == "one" {
            oneImageViewController = OneImageViewController()
            if let imageUrl = imageList[startFrom]["url"] {
                oneImageViewController?.url = imageUrl
                oneImageViewController?.startFrom = startFrom
                oneImageViewController?.options = options
                return true
            }
            return false
        } else if imageList.count > 1 && mode == "slider" {
            let position: IndexPath = [0, startFrom]
            sliderViewController = SliderViewController()
            sliderViewController?.imageList = imageList
            sliderViewController?.position = position
            sliderViewController?.mode = mode
            sliderViewController?.options = options
            return true
        } else {
            return false
        }
    }
}
