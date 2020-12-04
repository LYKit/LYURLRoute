//
//  ZPURLRouteHold.m
//  ZPURLRoute
//
//  Created by 赵学良 on 2018/9/24.
//  Copyright © 2018年 zhaoxueliang. All rights reserved.
//

#import "ZPURLRouteHold.h"
#import "ZPURLRouteHandle.h"
#import "UIViewController+ZPURLRoute.h"

NSString * const kRouteHoldLastViewController = @"ZPURLRouteHoldLastViewController";
NSString * const kRouteHoldViewController = @"kRouteHoldViewController";
NSString * const kRouteHoldParameter = @"kRouteHoldParameter";



@interface ZPURLRouteHold ()

@property (nonatomic, strong) ZPURLRouteResult *routeResult;
@property (nonatomic, copy)ZPURLRouteHoldCompleteBlock completeBlock;

@end

@implementation ZPURLRouteHold

- (void)dealHoldWithRouteResult:(ZPURLRouteResult *)routeResult completeBlock:(ZPURLRouteHoldCompleteBlock)completeBlock {
    //检查passKeys
    [self.passKeys enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
        if ([propertyName isKindOfClass:[NSString class]]) {
            id lastViewController = routeResult.lastViewController;
            SEL selector = NSSelectorFromString(propertyName);
            if ([lastViewController respondsToSelector:selector]) {
                id viewController = routeResult.viewController;
                id propertyValue = [lastViewController valueForKey:propertyName];
                if ([viewController respondsToSelector:selector]) {
                    [viewController setValue:propertyValue forKey:propertyName];
                }
            }
        }
    }];
    //检查属性
    [self.checkKeys enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
        if ([propertyName isKindOfClass:[NSString class]]) {
            NSDictionary *param = routeResult.parameter;
            id obj = param[propertyName];
            if (!obj) {
                NSAssert(obj, ([NSString stringWithFormat:@"链接未提供页面%@值", propertyName]));
            }
        }
    }];
    //自定义操作
    BOOL holdSuccess = NO;
    if (self.holdController.length > 0) {
        Class cls = NSClassFromString(self.holdController);
        id<ZPURLRouteHoldProtocol> holdObj = cls.new;
        if ([holdObj respondsToSelector:@selector(holdWithParameters:)]) {
            //push动画结束回调
            ZPURLRouteOpenCompletion complete = routeResult.parameter[kURLRouteOpenCompletion];
            [CATransaction setCompletionBlock:^{
                if (complete) {
                    complete();
                }
            }];
            [CATransaction begin];
            holdSuccess = [holdObj holdWithParameters:routeResult.result];
            [CATransaction commit];
        }
    }
    // 正常回调
    if (holdSuccess && completeBlock) {
        completeBlock(routeResult, routeResult.parameter, YES, YES);
    } else {
        completeBlock(routeResult, routeResult.parameter, YES, NO);
    }
}

@end
