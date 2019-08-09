
import UserNotifications
import UIKit

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
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
        
        //========= Code for simple image & video url saving in disk as an attachment=============
        //=================== Do not use attachment for streaming url ============================
        // MARK:- Manage attachments and save in disk for accessing it in UNNotificationContentExtension
        // If you have only image_url or video_url, add key in attachmentURL variable and compose URL.
        // Note:- If you have streamning url for video , do not add attachment/ imagedata
        
        guard let attachmentURL = content.userInfo["video_url"] as? String, let url = URL(string: attachmentURL) else {
            return failEarly()
        }
        
        guard let imageData = NSData(contentsOf:url) else { return failEarly() }
        
        // For saving video in disk
        guard let attachment2 = UNNotificationAttachment.create(imageFileIdentifier: "video.mp4", data: imageData, options: nil) else { return failEarly() }
        
        // For saving Image in disk
        //        guard let attachment3 = UNNotificationAttachment.create(imageFileIdentifier: "image.gif", data: imageData, options: nil) else { return failEarly() }
        
        //=======================================================================================
        
        content.attachments = [attachment2]
        contentHandler(content.copy() as! UNNotificationContent)
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
}

//------------------------------------------------------------------------------------
// MARK:- Extension
//------------------------------------------------------------------------------------
extension UNNotificationAttachment {
    
    /// Save the image or video to disk
    static func create(imageFileIdentifier: String, data: NSData, options: [NSObject : AnyObject]?)
        -> UNNotificationAttachment? {
            
            let fileManager = FileManager.default
            let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
            let fileURLPath      = NSURL(fileURLWithPath: NSTemporaryDirectory())
            let tmpSubFolderURL  = fileURLPath.appendingPathComponent(tmpSubFolderName, isDirectory: true)
            
            do {
                try fileManager.createDirectory(at: tmpSubFolderURL!,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
                let fileURL = tmpSubFolderURL?.appendingPathComponent(imageFileIdentifier)
                try data.write(to: fileURL!, options: [])
                let imageAttachment = try UNNotificationAttachment.init(identifier: imageFileIdentifier,
                                                                        url: fileURL!,
                                                                        options: options)
                return imageAttachment
            } catch let error {
                print("error \(error)")
            }
            
            return nil
    }
}
