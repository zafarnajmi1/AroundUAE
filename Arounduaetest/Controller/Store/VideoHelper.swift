
import UIKit
import MobileCoreServices
import AVFoundation

class VideoHelper {
  
  static func startMediaBrowser(delegate: UIViewController & UINavigationControllerDelegate & UIImagePickerControllerDelegate, sourceType: UIImagePickerControllerSourceType) {
    guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
    
    let mediaUI = UIImagePickerController()
    mediaUI.sourceType = sourceType
    mediaUI.mediaTypes = [kUTTypeMovie as String]
    mediaUI.allowsEditing = true
    mediaUI.delegate = delegate
    mediaUI.videoMaximumDuration = 30
    delegate.present(mediaUI, animated: true, completion: nil)
  }
}
