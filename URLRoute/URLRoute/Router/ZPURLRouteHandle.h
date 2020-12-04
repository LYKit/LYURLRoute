//
//  ZPURLRouteHandle.h
//  bangjob
//
//  Created by 赵学良 on 2019/6/24.
//  Copyright © 2019年 com.58. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ZPRouteResultModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface ZPURLRouteHandle : NSObject

// 路由即将发生跳转
+ (void)routeWillJump:(NSURL *)url customInfo:(NSDictionary *)customInfo;

// 路由跳转失败
+ (void)routeFailed:(NSString *)url fromPage:(UIViewController *)fromPage;

// 路由跳转成功
+ (void)routeSuccess:(NSString *)url fromPage:(UIViewController *)fromPage;

// 路由规则解析失败或者不满足规则
+ (void)routeError:(NSString *)url fromPage:(UIViewController *)fromPage;

// 未登录被拦截
+ (void)routeToNotLogin:(NSString *)url fromPage:(UIViewController *)controller from:(URLRouteFromType)from;

@end

NS_ASSUME_NONNULL_END
