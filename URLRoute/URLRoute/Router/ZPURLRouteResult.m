//
//  ZPURLRouteResult.m
//  ZPURLRoute
//
//  Created by 赵学良 on 2018/9/24.
//  Copyright © 2018年 zhaoxueliang. All rights reserved.
//

#import "ZPURLRouteResult.h"
#import "ZPRouteScheme.h"
#import "ZPRouteConfig.h"


NSString * const kRouteResultLastViewController = @"kRouteResultLastViewController";
NSString * const kRouteResultExtend = @"kRouteResultExtend";
NSString * const kRouteResultUseableURL = @"kRouteResultUseableURL";
NSString * const kRouteResultOriginalURL = @"kRouteResultOriginalURL";
NSString * const kRouteOriginalURLString = @"kRouteOriginalURLString";

@interface ZPURLRouteResult ()

@property (nonatomic, assign, readwrite) ZPURLRouteOpenType openType;

@end

@implementation ZPURLRouteResult

- (instancetype)initWithScheme:(NSString *)scheme {
    self = [self init];
    if (self) {
        if (!ZPRouteConfig.isLogin) {
            self.openType = URLRouteOpenNotLogin;
        } else if ([scheme isEqualToString:ZPRouteConfig.routeSchemeClient]) {
            self.openType = URLRouteOpenNative;
        }
        else if ([scheme isEqualToString:ZPRouteConfig.routeSchemeExternal]) {
            self.openType = URLRouteOpenExternal;
        } 
        else if ([scheme isEqualToString:ZPRouteConfig.routeSchemeWeb] ||
                 [scheme isEqualToString:ZPRouteConfig.routeSchemeFile] ||
                 [scheme isEqualToString:ZPRouteConfig.routeSchemeSECWeb]) {
            self.openType = URLRouteOpenWeb;
        }
        else {
            self.openType = URLRouteOpenUndefine;
        }
    }
    return self;
}


- (ZPRouteResultModel *)result {
    ZPRouteResultModel *model = [[ZPRouteResultModel alloc] initWithURLScheme:_routeScheme cusParams:_paramsCustom optionParams:_parameter routeParams:_paramsRoute];
    return model;
}

@end
