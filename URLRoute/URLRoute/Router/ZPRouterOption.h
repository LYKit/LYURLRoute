//
//  ZPRouterOption.h
//  demo
//
//  Created by 赵学良 on 2020/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** option 基本参数 **/

//是否需要动画，默认@YES
extern NSString *const kURLRouteOpenAnimated;

//动画形式，默认@(URLRouteOpenAnimatedPush)
extern NSString *const kURLRouteOpenAnimatedTransition;

//跳转来源, 默认@(URLRouteFromClient)
extern NSString *const kURLRouteOpenFromType;

//记录业务来源 Value: 默认nil (为 NSString 类型)
extern NSString *const kURLRouteOpenSource;

//完成后回调操作，默认nil
extern NSString *const kURLRouteOpenCompletion;

//回传参数，默认nil
extern NSString *const kZPURLRouteCallParams;

//回传参数
typedef void(^ZPURLRouteCallParamsBlock)(NSDictionary *params);

//跳转完成回调 kURLRouteOpenCompletion
typedef void(^ZPURLRouteOpenCompletion)(void);


typedef NS_ENUM(NSUInteger, URLRouteOpenAnimatedTransition) {
    URLRouteOpenAnimatedPush,
    URLRouteOpenAnimatedPresent
};

// 跳转来源
typedef enum : NSUInteger {
    URLRouteFromClient = 0, // 从app内部跳转
    URLRouteFromPush,   // push消息跳转
    URLRouteFromEvoke,  // 外部唤起app跳转
} URLRouteFromType;


NS_ASSUME_NONNULL_END
