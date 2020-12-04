//
//  ZPURLRouteHandle.m
//  bangjob
//
//  Created by 赵学良 on 2019/6/24.
//  Copyright © 2019年 com.58. All rights reserved.
//

#import "ZPURLRouteHandle.h"
#import "ZPRouteScheme.h"
#import "UIViewController+ZPURLRoute.h"
#import "ZPRouteConfig.h"

@implementation ZPURLRouteHandle


+ (void)routeWillJump:(NSURL *)url customInfo:(NSDictionary *)customInfo{
    ZPRouteScheme *scheme = [[ZPRouteScheme alloc] initWithURL:url];
    [ZPRouteConfig routeWillJump:url.absoluteString scheme:scheme info:customInfo];
}

+ (void)routeFailed:(NSString *)url fromPage:(UIViewController *)fromPage{
    ZPRouteScheme *scheme = [[ZPRouteScheme alloc] initWithURL:[NSURL URLWithString:url]];
    [ZPRouteConfig routeFailed:url scheme:scheme fromPage:fromPage];
}

+ (void)routeSuccess:(NSString *)url fromPage:(UIViewController *)fromPage {
    ZPRouteScheme *scheme = [[ZPRouteScheme alloc] initWithURL:[NSURL URLWithString:url]];
    [ZPRouteConfig routeSuccess:url scheme:scheme fromPage:fromPage];
}

+ (void)routeError:(NSString *)url fromPage:(UIViewController *)fromPage {
    ZPRouteScheme *scheme = [[ZPRouteScheme alloc] initWithURL:[NSURL URLWithString:url]];
    [ZPRouteConfig routeError:url scheme:scheme fromPage:fromPage];
}

+ (void)routeToNotLogin:(NSString *)url fromPage:(UIViewController *)controller from:(URLRouteFromType)from {
    [ZPRouteConfig routeToNotLogin:url fromPage:controller from:from];
}
@end
