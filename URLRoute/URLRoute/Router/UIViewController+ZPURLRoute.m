//
//  UIViewController+ZPURLRoute.m
//  ZPURLRoute
//
//  Created by 赵学良 on 2018/9/24.
//  Copyright © 2018年 zhaoxueliang. All rights reserved.
//


#import "UIViewController+ZPURLRoute.h"
#import <objc/runtime.h>
#import "ZPURLRoute.h"
#import "ZPURLRouteResult.h"
#import "ZPURLBridge.h"
#import "ZPRouteConfig.h"
#import "ZPURLRouteHandle.h"

@implementation UIViewController (ZPURLRoute)

#pragma mark -
- (void)openRouteURL:(NSURL *)url options:(NSDictionary *)options {
    [self openRouteURL:url options:options parameter:nil];
}
- (void)openRouteURL:(NSURL *)url options:(NSDictionary *)options parameter:(NSDictionary *)parameter {
    if (!url) return;
    NSURL *newURL = url;
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    dictionary[kRouteResultLastViewController] = [self p_route_lastViewController];
    dictionary[kRouteResultUseableURL] = newURL;
    [dictionary addEntriesFromDictionary:options];
    [ZPURLRouteHandle routeWillJump:newURL customInfo:parameter];
    [self p_route_openRouteURL:newURL options:dictionary parameter:parameter];
}

#pragma mark -
- (UIViewController *)p_route_lastViewController {
    UIViewController *viewController = nil;
    if ([self isKindOfClass:[UINavigationController class]]) {
        viewController = ((UINavigationController *)self).topViewController;
    }
    else if ([self isKindOfClass:[UIViewController class]]) {
        viewController = self;
    }
    else {
        NSAssert(viewController, ([NSString stringWithFormat:@"ZPURLRoute Tip:缺少Nav"]));
    }
    return viewController;
}

- (void)p_route_openRouteURL:(NSURL *)routeURL options:(NSDictionary *)dict parameter:(NSDictionary *)parameter
{
    __block BOOL jumpSuccess = NO;
    BOOL routeSuccess = [p_route_URLRoute() routeWithURL:routeURL options:dict parameter:parameter completeblock:^(ZPURLRouteResult *result, NSDictionary *otherOptions, BOOL isHold, BOOL holdSuccess) {
        if (isHold) {
            jumpSuccess = holdSuccess;
        } else {
            NSDictionary *options = otherOptions ?: dict;
            switch (result.openType) {
                case URLRouteOpenWeb:
                case URLRouteOpenNative: {
                    UIViewController *viewController = result.viewController;
                    UIViewController *lastViewController = result.lastViewController;

                    if (lastViewController) {
                        //Push前回调，供对象属性参数初始化
                        if ([viewController respondsToSelector:@selector(routeWillPushControllerWithResult:)]) {
                            [viewController routeWillPushControllerWithResult:result.result];
                        }
                        //具体页面打开操作
                        NSArray *allOpenKeys = options.allKeys;
                        BOOL animated = YES;
                        if ([allOpenKeys containsObject:kURLRouteOpenAnimated]) {
                            animated = [options[kURLRouteOpenAnimated] boolValue];
                        }
                        ZPURLRouteOpenCompletion completion = nil;
                        if ([allOpenKeys containsObject:kURLRouteOpenCompletion]) {
                            completion = options[kURLRouteOpenCompletion];
                        }
                        URLRouteOpenAnimatedTransition openType = URLRouteOpenAnimatedPush;
                        if ([allOpenKeys containsObject:kURLRouteOpenAnimatedTransition]) {
                            openType = [options[kURLRouteOpenAnimatedTransition] integerValue];
                        }
                        switch (openType) {
                            case URLRouteOpenAnimatedPush: {
                                //push动画结束后回调
                                [CATransaction setCompletionBlock:^{
                                    if (completion) {
                                        completion();
                                    }
                                }];
                                [CATransaction begin];
                                [lastViewController.navigationController pushViewController:viewController animated:animated];
                                [CATransaction commit];
                                jumpSuccess = YES;
                                
                            } break;
                            case URLRouteOpenAnimatedPresent: {
                                [lastViewController presentViewController:viewController animated:animated completion:completion];
                                jumpSuccess = YES;
                            } break;
                            default:
                                break;
                        }
                        //Push后回调，做一些清理操作
                        if ([viewController respondsToSelector:@selector(routeDidPushControllerWithResult:)]) {
                            [viewController routeDidPushControllerWithResult:result.result];
                        }
                    }
                    else {
                        NSAssert(lastViewController, ([NSString stringWithFormat:@"%@的NavigationController不存在，无法push", NSStringFromClass([self class])]));
                    }
                }
                    break;
                case URLRouteOpenExternal: {
                    NSURL *URL = options[kRouteResultUseableURL];
                    [[UIApplication sharedApplication] openURL:URL];
                    jumpSuccess = YES;
                }
                    break;
                default: break;
            }
        }
    }];
    
    // 跳转规则不满足
    if (!routeSuccess) {
        UIViewController *fromVC = dict[kRouteResultLastViewController];
        [ZPURLRouteHandle routeError:dict[kRouteOriginalURLString] fromPage:fromVC];
    }
   
    // 跳转是否成功
    if (jumpSuccess) {
        UIViewController *fromVC = dict[kRouteResultLastViewController];
        [ZPURLRouteHandle routeSuccess:dict[kRouteOriginalURLString] fromPage:fromVC];
    }
    else {
        UIViewController *fromVC = dict[kRouteResultLastViewController];
        [ZPURLRouteHandle routeFailed:dict[kRouteOriginalURLString] fromPage:fromVC];
    }
}

#pragma mark -
static ZPURLRoute *p_route_URLRoute() {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = ZPURLRoute.new;
    });
    return instance;
}

@end




@implementation UIViewController (ZPURLRouteHoldObject)

- (id)holdObject {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setHoldObject:(id)holdObject {
    objc_setAssociatedObject(self, @selector(holdObject), holdObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end







