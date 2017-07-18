#import <Foundation/Foundation.h>

typedef void (^WXHttpCallback)(BOOL isSuccessed, NSDictionary *result);

@interface WXUtil : NSObject

/**
 *  GET方法请求数据
 *
 *  @param url     请求的URL
 *  @param params  请求参数
 *  @param (BOOL isSuccessed, Result *result))callback  回调方法
 */
+ (void)doGetWithUrl:(NSString *)url params:(NSDictionary *)params callback:(WXHttpCallback) callback;

/**
 *  POST方法请求数据
 *
 *  @param url      请求的URL
 *  @param params   请求参数
 *  @param (BOOL isSuccessed, Result *result))callback  回调方法
 */
+ (void)doPostWithUrl:(NSString *)url params:(NSDictionary *)params callback:(WXHttpCallback)callback;


@end
