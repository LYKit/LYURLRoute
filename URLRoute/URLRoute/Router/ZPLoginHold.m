//
//  ZPLoginHold.m
//  bangjob
//
//  Created by 赵学良 on 2019/4/25.
//  Copyright © 2019年 com.58. All rights reserved.
//

#import "ZPLoginHold.h"
#import "ZPRouteResultModel.h"
#import "ZPRouteConfig.h"
#import "UIViewController+ZPRouter.h"
#import "ZPURLRouteHandle.h"

static id po_observer = nil;
NSString * const kLYLoginResponseSuccessNotification = @"kLYLoginResponseSuccessNotification";

@interface ZPLoginHold ()
@property (nonatomic, strong) ZPRouteResultModel *currentResult;

@end

@implementation ZPLoginHold


- (BOOL)holdWithParameters:(ZPRouteResultModel *)result
{
    [ZPURLRouteHandle routeToNotLogin:result.urlStr fromPage:result.fromController from:result.fromType];
    
    self.currentResult = result;

    /*
    if 完成登录，继续跳转
     */
    if (ZPRouteConfig.isLogin) {
        [result.fromController openRouteURLString:result.urlStr parameter:result.customInfo options:nil];
    } else {
        if (po_observer) {
            [[NSNotificationCenter defaultCenter] removeObserver:po_observer];
        }
        po_observer = [[NSNotificationCenter defaultCenter] addObserverForName:kLYLoginResponseSuccessNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            [result.fromController openRouteURLString:result.urlStr parameter:result.customInfo options:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:po_observer];
            po_observer = nil;
        }];
    }
    
    return NO;
}

@end
