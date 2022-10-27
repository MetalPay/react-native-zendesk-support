import SupportSDK
import ZendeskCoreSDK

@objc(ZendeskSupport)
class ZendeskSupport: NSObject {
    
    @objc(initialize:withResolver:withRejector:)
    func initialize(config: NSDictionary, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        guard let appId = config["appId"] as? String,
              let clientId = config["clientId"] as? String,
              let zendeskUrl = config["zendeskUrl"] as? String else {
            return reject("400", "Invalid parameters", nil)
        }
        Zendesk.initialize(appId: appId, clientId: clientId, zendeskUrl: zendeskUrl)
        Support.initialize(withZendesk: Zendesk.instance)
        resolve("Zendesk initialized")
    }
    
    @objc(identifyAnonymous:withEmail:withResolver:withRejector:)
    func identifyAnonymous(name: String?, email: String?, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        guard Zendesk.instance != nil else {
            return reject("500", "Zendesk not initialized", nil)
        }
        let identity = Identity.createAnonymous(name: name, email: email)
        Zendesk.instance?.setIdentity(identity)
        resolve("Anonymous identified")
    }
    
    @objc(showHelpCenter:withResolver:withRejector:)
    func showHelpCenter(options: NSDictionary?, resolve: @escaping RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        guard Zendesk.instance != nil else {
            return reject("500", "Zendesk not initialized", nil)
        }
        guard Zendesk.instance?.identity != nil else {
            return reject("500", "Zendesk missing identity", nil)
        }
        DispatchQueue.main.async {
            // Help center configuration
            let helpCenterConfiguration = HelpCenterUiConfiguration()
            helpCenterConfiguration.showContactOptionsOnEmptySearch = options?["hideContactSupport"] as? Bool ?? false
            if let groupType = options?["groupType"] as? UInt,
               let overviewGroupType = ZDKHelpCenterOverviewGroupType(rawValue: groupType) {
                helpCenterConfiguration.groupType = overviewGroupType
            }
            if let groupIds = options?["groupIds"] as? [NSNumber] {
                helpCenterConfiguration.groupIds = groupIds
            }
            
            // Ticketing configuration
            let requestConfiguration = RequestUiConfiguration()
            if let subject = options?["subject"] as? String {
                requestConfiguration.subject = subject
            }
            if let tags = options?["tags"] as? [String] {
                requestConfiguration.tags = tags
            }
            
            // Help center
            let helpCenter = HelpCenterUi.buildHelpCenterOverviewUi(withConfigs: [helpCenterConfiguration, requestConfiguration])
            let navigationController = UINavigationController(rootViewController: helpCenter)
            navigationController.modalPresentationStyle = .fullScreen
            if #available(iOS 13.0, *) {
                UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .first(where: {$0 is UIWindowScene})
                    .flatMap({$0 as? UIWindowScene})?.windows
                    .first(where: {$0.isKeyWindow})?.rootViewController?
                    .present(navigationController, animated: true)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.keyWindow?.rootViewController?.present(navigationController, animated: true)
            }
            resolve("Help center created")
        }
    }
}
