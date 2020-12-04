//
//  ZPRouteConfig.m
//  ZPURLRoute
//
//  Created by 赵学良 on 2019/4/3.
//  Copyright © 2019年 com.58. All rights reserved.
//

#import "ZPRouteConfig.h"
#import "ZPURLRouteConfig.h"

NSString * const kRouteSchemeClient     = @"scheme";       //默认跳转native页面
NSString * const kRouteSchemeExternal   = @"external";      //跳转外部
NSString * const kRouteSchemeWeb        = @"http";          //跳转web
NSString * const kRouteSchemeSECWeb     = @"https";         //跳转安全web
NSString * const kRouteSchemeFile       = @"file";          //文件 （暂不可用）
NSString * const kRouteHostClient     = @"client";          //默认module
NSString * const kRouteURLDataKey     = @"data";            //URL.query数据所在key

@interface ZPRouteConfig ()

@property (class, nonatomic, assign, readonly) Class<ZPRouteConfigDelegate> delegate;

@end

@implementation ZPRouteConfig

static Class<ZPRouteConfigDelegate> _delegate = nil;
+ (Class<ZPRouteConfigDelegate>)delegate {
    return _delegate;
}
+ (void)setDelegate:(Class<ZPRouteConfigDelegate>)value {
    _delegate = value;
}

+ (NSString *)routeSchemeWeb {
    return kRouteSchemeWeb;
}

+ (NSString *)routeSchemeSECWeb {
    return kRouteSchemeSECWeb;
}

+ (NSString *)routeSchemeFile {
    return kRouteSchemeFile;
}

static NSString *_routeSchemeClient = nil;
+ (NSString *)routeSchemeClient {
    return _routeSchemeClient?:kRouteSchemeClient;
}
+ (void)setRouteSchemeClient:(NSString *)value {
    _routeSchemeClient = value;
}

static NSString *_routeSchemeExternal = nil;
+ (NSString *)routeSchemeExternal {
    return _routeSchemeExternal?:kRouteSchemeExternal;
}
+ (void)setRouteSchemeExternal:(NSString *)value {
    _routeSchemeExternal = value;
}

static NSString *_routeHostClient = nil;
+ (NSString *)routeHostClient {
    return _routeHostClient?:kRouteHostClient;
}
+ (void)setRouteHostClient:(NSString *)value {
    _routeHostClient = value;
}

static NSString *_routeURLDataKey = nil;
+ (NSString *)routeURLDataKey {
    return _routeURLDataKey?:kRouteURLDataKey;
}
+ (void)setRouteURLDataKey:(NSString *)value {
    _routeURLDataKey = value;
}


+ (BOOL)isLogin {
    if ([self.delegate respondsToSelector:@selector(routeAllowJumpNotLogin)]) {
        if ([self.delegate routeAllowJumpNotLogin]) {
            return YES;
        }
    }
    if ([self.delegate respondsToSelector:@selector(routeConfigClientLoginStatus)]) {
        return [self.delegate routeConfigClientLoginStatus];
    }
    return YES;
}

+ (void)registerURLRouteConfigClass:(Class<ZPRouteConfigDelegate>)delegate {
    self.delegate = delegate;
}

+ (void)registerScheme:(NSString *)scheme {
    self.routeSchemeClient = scheme;
}

+ (void)registerModule:(NSString *)module {
    self.routeHostClient = module;
}

+ (void)registerExternal:(NSString *)external {
    self.routeSchemeExternal = external;
}

+ (void)registerQueryName:(NSString *)queryName {
    self.routeURLDataKey = queryName;
}


+ (void)addRouteWithPlistPath:(NSString *)path {
    [ZPURLRouteConfig addRouteWithPlistPath:path];
}


+ (void)addRouteWithPlistPaths:(NSArray *)paths {
    [ZPURLRouteConfig addRouteWithPlistPaths:paths];
}

+ (void)addRouteDictionary:(NSDictionary *)routeDictionary {
    [ZPURLRouteConfig addRouteDictionary:routeDictionary];
}


+ (void)routeWillJump:(NSString *)url scheme:(ZPRouteScheme *)scheme info:(NSDictionary *)info {
    if ([self.delegate respondsToSelector:@selector(routeWillJump:scheme:customInfo:)]) {
        [self.delegate routeWillJump:url scheme:scheme customInfo:info];
    }
}

+ (void)routeFailed:(NSString *)url scheme:(ZPRouteScheme *)scheme fromPage:(UIViewController *)controller{
    if ([self.delegate respondsToSelector:@selector(routeFailed:scheme:fromPage:)]) {
        [self.delegate routeFailed:url scheme:scheme fromPage:controller];
    }
}

+ (void)routeSuccess:(NSString *)url scheme:(ZPRouteScheme *)scheme fromPage:(UIViewController *)controller {
    if ([self.delegate respondsToSelector:@selector(routeSuccess:scheme:fromPage:)]) {
        [self.delegate routeSuccess:url scheme:scheme fromPage:controller];
    }
}

+ (void)routeError:(NSString *)url scheme:(ZPRouteScheme *)scheme fromPage:(UIViewController *)fromPage {
    if ([self.delegate respondsToSelector:@selector(routeError:scheme:fromPage:)]) {
        [self.delegate routeError:url scheme:scheme fromPage:fromPage];
    }
}

+ (void)routeToNotLogin:(NSString *)url fromPage:(UIViewController *)controller from:(URLRouteFromType)from {
    if ([self.delegate respondsToSelector:@selector(routeToNotLogin:fromPage:from:)]) {
        [self.delegate routeToNotLogin:url fromPage:controller from:from];
    }
}
@end
