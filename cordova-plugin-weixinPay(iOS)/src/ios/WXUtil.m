#import "WXUtil.h"
#import "AFNetworking.h"

@implementation WXUtil

// get 方式获取数据
+ (void)doGetWithUrl:(NSString *)url params:(NSDictionary *)params callback:(WXHttpCallback) callback {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
        [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            // 进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            callback(YES, responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callback(NO, nil);
        }];
    });
}

// post 方式获取数据
+ (void)doPostWithUrl:(NSString *)url params:(NSDictionary *)params callback:(WXHttpCallback)callback {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
        [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            // 进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            callback(YES, responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callback(NO, nil);
        }];
    });
}

@end
