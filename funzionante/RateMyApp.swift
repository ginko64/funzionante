//
//  RateMyApp.swift
//  funzionante
//
//  Created by Mario Regeni on 24/11/16.
//  Copyright © 2016 Mario Regeni. All rights reserved.
//

import UIKit


class RateMyApp : UIViewController,UIAlertViewDelegate{
    
    fileprivate let kTrackingAppVersion     = "kRateMyApp_TrackingAppVersion"
    fileprivate let kFirstUseDate			= "kRateMyApp_FirstUseDate"
    fileprivate let kAppUseCount			= "kRateMyApp_AppUseCount"
    fileprivate let kSpecialEventCount		= "kRateMyApp_SpecialEventCount"
    fileprivate let kDidRateVersion         = "kRateMyApp_DidRateVersion"
    fileprivate let kDeclinedToRate			= "kRateMyApp_DeclinedToRate"
    fileprivate let kRemindLater            = "kRateMyApp_RemindLater"
    fileprivate let kRemindLaterPressedDate	= "kRateMyApp_RemindLaterPressedDate"
    
    fileprivate var reviewURL = "https://itunes.apple.com/us/app/negozio-plus/id1179386289?l=it&ls=1&mt=8"
    fileprivate var reviewURLiOS7 = "https://itunes.apple.com/us/app/negozio-plus/id1179386289?l=it&ls=1&mt=8"
    
    
    var promptAfterDays:Double = 30
    var promptAfterUses = 1
    var promptAfterCustomEventsCount = 10
    var daysBeforeReminding:Double = 1
    
    var alertTitle = NSLocalizedString("Negozio Plus", comment: "RateMyApp")
    var alertMessage = ""
    var alertOKTitle = NSLocalizedString("Valuta Negozio Plus", comment: "RateMyApp")
    var alertCancelTitle = NSLocalizedString("No, grazie", comment: "RateMyApp")
    var alertRemindLaterTitle = NSLocalizedString("Ricordamelo più tardi", comment: "RateMyApp")
    var appID = ""
    
    
    class var sharedInstance : RateMyApp {
        struct Static {
            static let instance : RateMyApp = RateMyApp()
        }
        return Static.instance
    }
    
    
    //    private override init(){
    //
    //        super.init()
    //
    //    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    fileprivate func initAllSettings(){
        
        let prefs = UserDefaults.standard
        
        prefs.set(getCurrentAppVersion(), forKey: kTrackingAppVersion)
        prefs.set(Date(), forKey: kFirstUseDate)
        prefs.set(1, forKey: kAppUseCount)
        prefs.set(0, forKey: kSpecialEventCount)
        prefs.set(false, forKey: kDidRateVersion)
        prefs.set(false, forKey: kDeclinedToRate)
        prefs.set(false, forKey: kRemindLater)
        
    }
    
    func trackEventUsage(){
        
        incrementValueForKey(name: kSpecialEventCount)
        
    }
    
    func trackAppUsage(){
        
        incrementValueForKey(name: kAppUseCount)
        
    }
    
    fileprivate func isFirstTime()->Bool{
        
        let prefs = UserDefaults.standard
        
        let trackingAppVersion = prefs.object(forKey: kTrackingAppVersion) as? NSString
        
        if((trackingAppVersion == nil) || !(getCurrentAppVersion().isEqual(to: trackingAppVersion! as String)))
        {
            return true
        }
        
        return false
        
    }
    
    fileprivate func incrementValueForKey(name:String){
        
        if(appID.characters.count == 0)
        {
            fatalError("Set iTunes connect appID to proceed, you may enter some random string for testing purpose. See line number 59")
        }
        
        if(isFirstTime())
        {
            initAllSettings()
            
        }
        else
        {
            let prefs = UserDefaults.standard
            let currentCount = prefs.integer(forKey: name)
            prefs.set(currentCount+1, forKey: name)
            
        }
        
        if(shouldShowAlert())
        {
            showRatingAlert()
        }
        
    }
    
    fileprivate func shouldShowAlert() -> Bool{
        
        let prefs = UserDefaults.standard
        
        let usageCount = prefs.integer(forKey: kAppUseCount)
        let eventsCount = prefs.integer(forKey: kSpecialEventCount)
        
        let firstUse = prefs.object(forKey: kFirstUseDate) as! Date
        
        let timeInterval = Date().timeIntervalSince(firstUse)
        
        let daysCount = ((timeInterval / 3600) / 24)
        
        let hasRatedCurrentVersion = prefs.bool(forKey: kDidRateVersion)
        
        let hasDeclinedToRate = prefs.bool(forKey: kDeclinedToRate)
        
        let hasChosenRemindLater = prefs.bool(forKey: kRemindLater)
        
        if(hasDeclinedToRate)
        {
            return false
        }
        
        if(hasRatedCurrentVersion)
        {
            return false
        }
        
        if(hasChosenRemindLater)
        {
            let remindLaterDate = prefs.object(forKey: kRemindLaterPressedDate) as! Date
            
            let timeInterval = Date().timeIntervalSince(remindLaterDate)
            
            let remindLaterDaysCount = ((timeInterval / 3600) / 24)
            
            return (remindLaterDaysCount >= daysBeforeReminding)
        }
        
        if(usageCount >= promptAfterUses)
        {
            return true
        }
        
        if(daysCount >= promptAfterDays)
        {
            return true
        }
        
        if(eventsCount >= promptAfterCustomEventsCount)
        {
            return true
        }
        
        return false
        
    }
    
    
    fileprivate func showRatingAlert(){
        
        let infoDocs : NSDictionary = Bundle.main.infoDictionary! as NSDictionary
        let appname : NSString = infoDocs.object(forKey: "CFBundleName") as! NSString
        
        var message = NSLocalizedString("Se ti piace %@ , trova un momento per valutarlo nell'AppStore. Grazie per il Supporto!", comment: "RateMyApp")
        message = String(format:message, appname)
        
        if(alertMessage.characters.count == 0)
        {
            alertMessage = message
        }
        
        
        if #available(iOS 8.0, *) {
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
            
            
            alert.addAction(UIAlertAction(title: alertOKTitle, style:.destructive, handler: { alertAction in
                self.okButtonPressed()
                alert.dismiss(animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: alertCancelTitle, style:.cancel, handler:{ alertAction in
                self.cancelButtonPressed()
                alert.dismiss(animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: alertRemindLaterTitle, style:.default, handler: { alertAction in
                self.remindLaterButtonPressed()
                alert.dismiss(animated: true, completion: nil)
            }))
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let controller = appDelegate.window?.rootViewController
            
            controller?.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertView()
            alert.title = alertTitle
            alert.message = alertMessage
            alert.addButton(withTitle: alertCancelTitle)
            alert.addButton(withTitle: alertRemindLaterTitle)
            alert.addButton(withTitle: alertOKTitle)
            alert.delegate = self
            alert.show()
        }
        
        
    }
    
    internal func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int){
        
        if(buttonIndex == 0)
        {
            cancelButtonPressed()
        }
        else if(buttonIndex == 1)
        {
            remindLaterButtonPressed()
        }
        else if(buttonIndex == 2)
        {
            okButtonPressed()
        }
        
        alertView.dismiss(withClickedButtonIndex: buttonIndex, animated: true)
        
    }
    
    fileprivate func deviceOSVersion() -> Float{
        
        let device : UIDevice = UIDevice.current;
        let systemVersion = device.systemVersion;
        let iOSVerion : Float = (systemVersion as NSString).floatValue
        
        return iOSVerion
    }
    
    fileprivate func hasOS8()->Bool{
        
        if(deviceOSVersion() < 8.0)
        {
            return false
        }
        
        return true
        
    }
    
    fileprivate func okButtonPressed(){
        
        UserDefaults.standard.set(true, forKey: kDidRateVersion)
        let appStoreURL = URL(string:reviewURLiOS7+appID)
        UIApplication.shared.openURL(appStoreURL!)
        
    }
    
    fileprivate func cancelButtonPressed(){
        
        UserDefaults.standard.set(true, forKey: kDeclinedToRate)
        
    }
    
    fileprivate func remindLaterButtonPressed(){
        
        UserDefaults.standard.set(true, forKey: kRemindLater)
        UserDefaults.standard.set(Date(), forKey: kRemindLaterPressedDate)
        
    }
    
    fileprivate func getCurrentAppVersion()->NSString{
        
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! NSString)
        
    }
    
    
    
}

