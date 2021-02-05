import UIKit
import NotificationCenter



class Notife: NSObject, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestAutorization(){
        
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            print("permisssion granted \(granted)")
            
            guard granted else {return}
            
            self.getNotificationSettings()
        }
        
    }
    
    
    func getNotificationSettings(){
        notificationCenter.getNotificationSettings { (settings) in
            print(settings)
        }
    }
    
    
    
    func newMessage(title: String, mess: String, identifire: String = "Local Notification", url: URL? = nil){
        let content = UNMutableNotificationContent()
        
        
        
        content.title = title
        content.body = mess
        content.sound = .default
        content.badge = 1
       
        
        let triger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        
        let key = "logo"
        let newQueue = DispatchQueue.init(label: "DispatchTest", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        
        newQueue.async {
            if let url = url {
              
                    
                        do{
                            
                            let data = try Data(contentsOf: url)
                            guard let myImage = UIImage(data: data) else { return }
                            

                            if let attachment = UNNotificationAttachment.create(identifier: key, image: myImage, options: nil) {
                                content.attachments = [attachment]
                            }
                            
                        }catch{
                            print(error)
                        }
                
            }
            
          
            let reques = UNNotificationRequest(identifier: identifire, content: content, trigger: triger)
        
            self.notificationCenter.add(reques) { error in
                if let error = error {
                    print("Errror: \(error.localizedDescription)")
                }
            }
        }
       
     
        
    }






    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        
        completionHandler([.banner, .sound])
        
        
    }
    
    
}




extension UNNotificationAttachment {
    static func create(identifier: String, image: UIImage, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tmpSubFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
        do {
            try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
            let imageFileIdentifier = identifier+".png"
            let fileURL = tmpSubFolderURL.appendingPathComponent(imageFileIdentifier)
            guard let imageData = image.pngData() else {
                return nil
            }
            try imageData.write(to: fileURL)
            let imageAttachment = try UNNotificationAttachment.init(identifier: imageFileIdentifier, url: fileURL, options: options)
            return imageAttachment        } catch {
                print("error " + error.localizedDescription)
        }
        return nil
    }
}
