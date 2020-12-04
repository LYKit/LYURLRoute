//
//  UIViewController+PO_RouteURL.m
//  ZPURLRoute
//
//  Created by 赵学良 on 2018/9/24.
//  Copyright © 2018年 zhaoxueliang. All rights reserved.
//

#import "UIViewController+PO_RouteURL.h"
#import "NSObject+ZPSwizzle.h"

static BOOL bALLPlistsLoaded = NO;
static id po_observer = nil;

@implementation UIViewController (PO_RouteURL)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL openRouteURL = @selector(openRouteURL:options:parameter:);
        SEL po_openRouteURL = @selector(po_openRouteURL:options:parameter:);
        [self swizzleInstanceSelector:openRouteURL withNewSelector:po_openRouteURL];
    });
}


// plist规则 都加载完后再执行
- (void)po_openRouteURL:(NSURL *)url options:(NSDictionary *)options parameter:(NSDictionary *)parameter{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"PLISTSALLLOADED"] isEqualToString:@"1"]) {
        [self po_openRouteURL:url options:options parameter:parameter];
    } else {
        if (bALLPlistsLoaded) {
            [self po_openRouteURL:url options:options parameter:parameter] ;
        } else {
            if (po_observer) {
                [[NSNotificationCenter defaultCenter] removeObserver:po_observer];
            }
            po_observer = [[NSNotificationCenter defaultCenter] addObserverForName:@"PLISTSALLLOADED" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
                bALLPlistsLoaded = YES;
                [self po_openRouteURL:url options:options parameter:parameter];
                [[NSNotificationCenter defaultCenter] removeObserver:po_observer];
                po_observer = nil;
            }];
        }
    }
}

@end
