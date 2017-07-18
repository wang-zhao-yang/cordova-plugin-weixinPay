#import <Cordova/CDV.h>
#import "WXApi.h"

@interface Weixin:CDVPlugin <WXApiDelegate>

@property (nonatomic, strong) NSString *currentCallbackId;
@property (nonatomic, strong) NSString *app_id;

- (void)sendPayReq:(CDVInvokedUrlCommand *)command;

@end
