#import "Weixin.h"
#import "WXUtil.h"

@implementation Weixin

- (void)pluginInitialize {
    
}

- (void)prepareForExec:(CDVInvokedUrlCommand *)command {
    [WXApi registerApp:self.app_id];
    self.currentCallbackId = command.callbackId;
    if (![WXApi isWXAppInstalled]) {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"未安装微信"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        [self endForExec];
        return;
    }
}

- (NSDictionary *)checkArgs:(CDVInvokedUrlCommand *)command {
    NSDictionary *params = [command.arguments objectAtIndex:0];
    if (!params) {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"参数错误"] callbackId:command.callbackId];
        [self endForExec];
        return nil;
    }
    return params;
}

- (void)endForExec {
    self.currentCallbackId = nil;
}

- (void)sendPayReq:(CDVInvokedUrlCommand *)command {
    NSDictionary *params = [self checkArgs:command];
    if (params == nil) {
        return;
    }
    self.app_id = [params objectForKey:@"appid"];
    NSString *urlString = [params objectForKey:@"urlString"];
    NSString *method = [params objectForKey:@"method"];
    NSDictionary *postDict = [params objectForKey:@"data"];
    if (method == nil) {
        return;
    }
    method = [method lowercaseString];
    [self prepareForExec:command];
    if ([method isEqualToString:@"post"]) {
        [WXUtil doPostWithUrl:urlString params:postDict callback:^(BOOL success,NSDictionary *dict) {
            [self dealWith:success dict:dict];
        }];
    } else {
        [WXUtil doGetWithUrl:urlString params:postDict callback:^(BOOL success,NSDictionary *dict) {
            [self dealWith:success dict:dict];
        }];
    }
}

- (void)dealWith:(BOOL)isSuccessed dict:(NSDictionary *)dict {
    if (isSuccessed) {
        if (dict != nil) {
            // 调起微信支付
            PayReq *req = [[PayReq alloc] init];
            req.partnerId = [dict objectForKey:@"partnerid"];
            req.prepayId  = [dict objectForKey:@"prepayid"];
            req.nonceStr  = [dict objectForKey:@"noncestr"];
            req.timeStamp = [[dict objectForKey:@"timestamp"] intValue];
            req.package   = [dict objectForKey:@"package"];
            req.sign      = [dict objectForKey:@"sign"];
            [WXApi sendReq:req];
        }
    } else {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"支付失败"];
        [self.commandDelegate sendPluginResult:result callbackId:self.currentCallbackId];
        [self endForExec];
    }
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        CDVPluginResult *result = nil;
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
                result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"%d",response.errCode]];
                break;
            default:
                result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"%d",response.errCode]];
                break;
        }
        [self.commandDelegate sendPluginResult:result callbackId:[self currentCallbackId]];
    }
    [self endForExec];
}

- (void)handleOpenURL:(NSNotification *)notification {
    NSURL *url = [notification object];
    if ([url isKindOfClass:[NSURL class]] && [url.scheme isEqualToString:self.app_id]) {
        [WXApi handleOpenURL:url delegate:self];
    }
}

@end
