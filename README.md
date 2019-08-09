# MKRichPushNotififcationDemo
A demo of notification with image &amp; video in content.

 ## Requirements

- iOS 11.0+
- Xcode 10.1+
- Swift 5

## Usage
- RichPushNotificationsDemo is a simple demo of rich notifications containing image, video in firebase notification.
- All you need is to add `UNNotificationServiceExtension` & `UNNotificationContentExtension` for managing custom rich notifications. Here **Service** is used for saving the image or video in disk and **Content** is used for loading the saved attachment in notification. You can customly manage notifications UI in Content Extension.
- Once you are done with both the extensions, try to run with service or content target and select your app from the list. It will configure your app according to the changes you had in Service & Content Extension.

## NotificationService

    class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler      : ((UNNotificationContent) -> Void)?
    var bestAttemptContent  : UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        //Media
        func failEarly() {
            contentHandler(request.content)
        }
        
        guard let content = (request.content.mutableCopy() as? UNMutableNotificationContent) else {
            return failEarly()
        }
        
      
        guard let attachmentURL = content.userInfo["video_url"] as? String, let url = URL(string: attachmentURL) else {
            return failEarly()
        }
        
        guard let imageData = NSData(contentsOf:url) else { return failEarly() }
        
        // For saving video in disk
        guard let attachment2 = UNNotificationAttachment.create(imageFileIdentifier: "video.mp4", data: imageData, options: nil) else { return failEarly() }
        
        content.attachments = [attachment2]
        contentHandler(content.copy() as! UNNotificationContent)
    }
    
## NotificationViewController
    
    class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    @IBOutlet var label                 : UILabel?
    @IBOutlet weak var imageView        : UIImageView!
    @IBOutlet weak var videoPlayerView  : UIView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let size = view.bounds.size
        preferredContentSize = CGSize(width: size.width, height: size.height / 2)
        
    }
    
    func didReceive(_ notification: UNNotification) {
        let player : AVPlayer = AVPlayer(url: videoUrl)
        let playerLayer : AVPlayerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        player.actionAtItemEnd = .none
        playerLayer.frame = CGRect(x: 0, y: 0, width: self.videoPlayerView.frame.size.width, height: self.videoPlayerView.frame.size.height)
        self.videoPlayerView.layer.addSublayer(playerLayer)
        player.play()
        
    }
    }


## Output
![Notifications - Animated gif demo](RichPushNotificationsDemo/Notification.gif)
