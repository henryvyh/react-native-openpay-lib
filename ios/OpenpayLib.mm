#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(OpenpayLib, NSObject)

RCT_EXTERN_METHOD(multiply:(float)a withB:(float)b
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)


RCT_EXTERN_METHOD(initOpenpay:(NSDictionary *)args
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)


RCT_EXTERN_METHOD(getDeviceSessionId:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)


RCT_EXTERN_METHOD(createToken:(NSDictionary *)cardDetails
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)                 
                 

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end
