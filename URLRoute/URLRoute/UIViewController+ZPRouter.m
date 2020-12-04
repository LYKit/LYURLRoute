//
//  UIViewController+ZPRouter.m
//  demo
//
//  Created by 赵学良 on 2020/11/30.
//

#import "UIViewController+ZPRouter.h"
#import "UIViewController+ZPURLRoute.h"
#import "ZPURLBridge.h"
#import "ZPURLRouteResult.h"


@implementation UIViewController (ZPRouter)


- (void)openRouteURLString:(NSString *)aString parameter:(NSDictionary *)parameter options:(NSDictionary *)options {
    [self openRouteURLString:aString parameter:parameter options:options completion:nil callParams:nil];
}

- (void)openRouteURLString:(NSString *)aString
                 parameter:(NSDictionary *)parameter
                   options:(NSDictionary *)options
                completion:(ZPURLRouteOpenCompletion)completion
                callParams:(ZPURLRouteCallParamsBlock)callParams
{
    if (!aString.length) return;
    NSURL *url = [NSURL URLWithString:aString];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:aString forKey:kRouteOriginalURLString];
    [dictionary setValue:completion forKey:kURLRouteOpenCompletion];
    [dictionary setValue:callParams forKey:kZPURLRouteCallParams];
    [dictionary addEntriesFromDictionary:options];
    [self openRouteURL:url options:dictionary parameter:parameter];
}


- (void)openRouteWithKey:(NSString *)page parameter:(NSDictionary *)parameter options:(NSDictionary *)options {
    [self openRouteWithKey:page parameter:parameter options:options completion:nil callParams:nil];
}

- (void)openRouteWithKey:(NSString *)page
               parameter:(NSDictionary *)parameter
                 options:(NSDictionary *)options
              completion:(ZPURLRouteOpenCompletion)completion
              callParams:(ZPURLRouteCallParamsBlock)callParams
{
    NSURL *url = [ZPURLBridge routeURLWithKey:page parameter:nil];
    [self openRouteURLString:url.absoluteString parameter:parameter options:options completion:completion callParams:callParams];
}

@end










@implementation NSObject (ZPObjectRouter)

- (void)openRouteURLString:(NSString *)aString parameter:(NSDictionary *)parameter options:(NSDictionary *)options{
    if ([self isKindOfClass:[UIViewController class]]) {
        UIViewController *controller = (UIViewController*)self;
        [controller openRouteURLString:aString parameter:parameter options:options];
    } else {
        [[UIViewController currentViewController] openRouteURLString:aString parameter:parameter options:options];
    }
}

- (void)openRouteWithKey:(NSString *)page parameter:(NSDictionary *)parameter options:(NSDictionary *)options{
    if ([self isKindOfClass:[UIViewController class]]) {
        UIViewController *controller = (UIViewController*)self;
        [controller openRouteWithKey:page parameter:parameter options:options];
    } else {
        [[UIViewController currentViewController] openRouteWithKey:page parameter:parameter options:options];
    }
}



- (void)openRouteURLString:(NSString *)aString
                 parameter:(NSDictionary *)parameter
                   options:(NSDictionary *)options
                completion:(ZPURLRouteOpenCompletion)completion
                callParams:(ZPURLRouteCallParamsBlock)callParams
{
    if ([self isKindOfClass:[UIViewController class]]) {
        UIViewController *controller = (UIViewController*)self;
        [controller openRouteURLString:aString parameter:parameter options:options completion:completion callParams:callParams];
    } else {
        [[UIViewController currentViewController] openRouteURLString:aString parameter:parameter options:options completion:completion callParams:callParams];
    }
}

- (void)openRouteWithKey:(NSString *)page
               parameter:(NSDictionary *)parameter
                 options:(NSDictionary *)options
              completion:(ZPURLRouteOpenCompletion)completion
              callParams:(ZPURLRouteCallParamsBlock)callParams
{
    if ([self isKindOfClass:[UIViewController class]]) {
        UIViewController *controller = (UIViewController*)self;
        [controller openRouteWithKey:page parameter:parameter options:options completion:completion callParams:callParams];
    } else {
        [[UIViewController currentViewController] openRouteWithKey:page parameter:parameter options:options completion:completion callParams:callParams];
    }
}









// 获取当前显示的Controller
+ (UIViewController *)currentViewController {
    // Find best view controller
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findBestViewController:viewController];
}

+ (UIViewController*)findBestViewController:(UIViewController*)vc {
    if (vc.presentedViewController) {
        return [self findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
        return [self findBestViewController:svc.viewControllers.lastObject];
        else
        return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
        return [self findBestViewController:svc.topViewController];
        else
        return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
        return [self findBestViewController:svc.selectedViewController];
        else
        return vc;
    } else {
        return vc;
    }
}


@end
