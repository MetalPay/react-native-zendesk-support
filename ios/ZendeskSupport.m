#import <React/RCTBridgeModule.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCT_EXTERN_MODULE(ZendeskSupport, NSObject)

RCT_EXTERN_METHOD(initialize:(NSDictionary *)config withResolver:(RCTPromiseResolveBlock)resolve withRejector:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(identifyAnonymous:(nullable NSString *)name withEmail:(nullable NSString *)email withResolver:(RCTPromiseResolveBlock)resolve withRejector:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(showHelpCenter:(nullable NSDictionary *)options withResolver:(RCTPromiseResolveBlock)resolve withRejector:(RCTPromiseRejectBlock)reject)

+ (BOOL)requiresMainQueueSetup
{
    return NO;
}

@end

NS_ASSUME_NONNULL_END
