//
//  UIViewController+ZPRouter.h
//  demo
//
//  Created by 赵学良 on 2020/11/30.
//

#import <UIKit/UIKit.h>
#import "ZPRouterOption.h"

@interface UIViewController (ZPRouter)

/**
 *  aString  例如：scheme://module/page[?][data=json]
 *  parameter 除了url参数外，其他需要传递的自定义参数
 *  options: {
        kURLRouteOpenAnimated:@(YES), // 跳转是否需要动画，默认YES
        kURLRouteOpenAnimatedTransition:@(URLRouteOpenAnimatedPresent), //            push还是present跳转，默认push
        kURLRouteOpenFromType:@(URLRouteFromClient) // 跳转源，客户端/push/外部唤起，默认客户端
        kURLRouteOpenSource:@"soure_xxx" // 业务源
    }
 *  completion 跳转完成回调
 *  callParams 参数回传
 */
- (void)openRouteURLString:(NSString *)aString parameter:(NSDictionary *)parameter options:(NSDictionary *)options;

- (void)openRouteURLString:(NSString *)aString
                 parameter:(NSDictionary *)parameter
                   options:(NSDictionary *)options
                completion:(ZPURLRouteOpenCompletion)completion
                callParams:(ZPURLRouteCallParamsBlock)callParams;


/** 客户端内部跳转
    page  url:scheme://module/page 中的page标识
    parameter 传递的自定义参数
    options  同上
 */
- (void)openRouteWithKey:(NSString *)page
               parameter:(NSDictionary *)parameter
                 options:(NSDictionary *)options;

- (void)openRouteWithKey:(NSString *)page
               parameter:(NSDictionary *)parameter
                 options:(NSDictionary *)options
              completion:(ZPURLRouteOpenCompletion)completion
              callParams:(ZPURLRouteCallParamsBlock)callParams;

@end















@interface NSObject (ZPObjectRouter)
- (void)openRouteURLString:(NSString *)aString parameter:(NSDictionary *)parameter options:(NSDictionary *)options;

- (void)openRouteWithKey:(NSString *)page parameter:(NSDictionary *)parameter options:(NSDictionary *)options;

- (void)openRouteURLString:(NSString *)aString
                 parameter:(NSDictionary *)parameter
                   options:(NSDictionary *)options
                completion:(ZPURLRouteOpenCompletion)completion
                callParams:(ZPURLRouteCallParamsBlock)callParams;

- (void)openRouteWithKey:(NSString *)page
               parameter:(NSDictionary *)parameter
                 options:(NSDictionary *)options
              completion:(ZPURLRouteOpenCompletion)completion
              callParams:(ZPURLRouteCallParamsBlock)callParams;
@end

