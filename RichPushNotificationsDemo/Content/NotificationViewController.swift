
import UIKit
import UserNotifications
import UserNotificationsUI
import CoreMotion
import AVKit

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    @IBOutlet var label                 : UILabel?
    @IBOutlet weak var imageView        : UIImageView!
    @IBOutlet weak var videoPlayerView  : UIView!
    
    var manager                         = CMMotionManager() // For moving image
    
    //------------------------------------------------------------------------------------
    // MARK:- Function for managing movt. of uiimage
    //------------------------------------------------------------------------------------
    func accelometerUpdate() {
        if manager.isGyroAvailable {
            manager.gyroUpdateInterval = 0.1
            manager.startGyroUpdates()
        }
        
        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.01
            manager.startDeviceMotionUpdates(to: .main) {
                [weak self] (data: CMDeviceMotion?, error: Error?) in
                if let gravity = data?.gravity {
                    let rotation = atan2(gravity.x, gravity.y) - Double.pi
                    self?.imageView.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        accelometerUpdate()
        let size = view.bounds.size
        preferredContentSize = CGSize(width: size.width, height: size.height / 2)
        
    }
    
    func didReceive(_ notification: UNNotification) {
        // MARK:- Image Here
        // If you have to manage image in notification , Below code will be used for setting image in imageview.
        // Also the gif animation is added to that particular image.
        
        /* if let notificationData = notification.request.content.userInfo as? [String: Any] {
         
         // Grab the attachment
         if let urlString = notificationData["attachment_url"], let fileUrl = URL(string: urlString as! String) {
         
         let imageData = NSData(contentsOf: fileUrl)
         let image = UIImage(data: imageData! as Data)!
         
         imageView.image = image
         accelometerUpdate()
         }
         } */
        
        // MARK:- Video Here
        // If you have to manage video in notification, below code will be used for setting videoPlayerView.
        // In this, both simple & streaming url video will be played in attachment.
        guard let strUrl = notification.request.content.userInfo["video_url"] as? String,
            let videoUrl = URL(string: strUrl) else {
                return
        }
        //If you want to try Steaming url video : http://clips.vorwaerts-gmbh.de/VfE_html5.mp4
        print(strUrl)
        
        let player : AVPlayer = AVPlayer(url: videoUrl)
        let playerLayer : AVPlayerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        player.actionAtItemEnd = .none
        playerLayer.frame = CGRect(x: 0, y: 0, width: self.videoPlayerView.frame.size.width, height: self.videoPlayerView.frame.size.height)
        self.videoPlayerView.layer.addSublayer(playerLayer)
        player.play()
        
    }
    
}
