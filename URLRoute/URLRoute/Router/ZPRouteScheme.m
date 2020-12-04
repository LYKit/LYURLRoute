//
//  ZPRouteScheme.m
//  ZPURLRoute
//
//  Created by 赵学良 on 2018/9/24.
//  Copyright © 2018年 zhaoxueliang. All rights reserved.
//

#import "ZPRouteScheme.h"
#import "NSDictionary+ZPURLQuery.h"
#import "NSString+ZPRemoveUnderscoreAndInitials.h"
#import "ZPURLRouteConfig.h"
#import "ZPRouteConfig.h"

NSString * const URLRouteVersion = @"URLRouteVersion";

@interface ZPRouteScheme ()

@property (nonatomic, strong, readwrite) NSURL *originalURL;
@property (nonatomic, strong, readwrite) NSURL *useableURL;
@property (nonatomic, strong, readwrite) NSString *query;
@property (nonatomic, strong, readwrite) NSString *scheme;
@property (nonatomic, strong, readwrite) NSString *module;           //模块
@property (nonatomic, strong, readwrite) NSString *page;             //页面
@property (nonatomic, strong, readwrite) NSDictionary *parameter;    //参数

@end

@implementation ZPRouteScheme

- (instancetype)initWithURL:(NSURL *)URL {
    self = [self init];
    if (self) {
        self.originalURL = URL;
        NSURL *aURL = self.originalURL;
        self.scheme = aURL.scheme;
        //根据Scheme，生成不同的属性
        if ([self.scheme isEqualToString:ZPRouteConfig.routeSchemeClient] ||
            [self.scheme isEqualToString:ZPRouteConfig.routeSchemeWeb] ||
            [self.scheme isEqualToString:ZPRouteConfig.routeSchemeFile] ||
            [self.scheme isEqualToString:ZPRouteConfig.routeSchemeSECWeb]) {
            self.useableURL = aURL;
        }
        else if ([self.scheme isEqualToString:ZPRouteConfig.routeSchemeExternal] ) {
            NSString *newScheme = aURL.host;
            NSString *newPath = aURL.path;
            NSString *newQuery = aURL.query;
            NSString *newURLString = [NSString stringWithFormat:@"%@:/%@?%@", newScheme, newPath, newQuery];
            self.useableURL = [NSURL URLWithString:newURLString];
            
            if ([self.scheme isEqualToString:ZPRouteConfig.routeSchemeClient]) {
                self.scheme = self.useableURL.scheme;
            }
        }
        else {
            self.scheme = nil;
            self.useableURL = nil;
        }
        self.module = [self.useableURL.host removeUnderscoreAndInitials];
        NSString *path = self.useableURL.path;
        self.page = [[path.length ? path : nil substringFromIndex:1] removeUnderscoreAndInitials];
        self.query = self.useableURL.query;

        NSDictionary *urlDict = [NSDictionary dictionaryWithURLQuery:self.useableURL.query];
        
        // 处理参数
        NSMutableDictionary *muteURLDict = [NSMutableDictionary dictionaryWithDictionary:urlDict];
        [urlDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [muteURLDict setObject:obj forKey:[key removeUnderscoreAndInitials]];
        }];
        
        self.parameter = muteURLDict;
    }
    return self;
}

+ (BOOL)isStandardURL:(NSURL *)url {
    NSString *scheme = url.scheme;
    NSString *host = url.host;
//    BOOL isStandard = [ZPRouteScheme isStandardScheme:scheme] && [ZPRouteScheme isStandardHost:host];
    BOOL isStandard = [ZPRouteScheme isStandardScheme:scheme];

    return isStandard;
}

+ (BOOL)isStandardScheme:(NSString *)scheme {
    return [scheme isEqualToString:ZPRouteConfig.routeSchemeClient] ||
    [scheme isEqualToString:ZPRouteConfig.routeSchemeExternal] ||
    [scheme isEqualToString:ZPRouteConfig.routeSchemeWeb] ||
    [scheme isEqualToString:ZPRouteConfig.routeSchemeFile] ||
    [scheme isEqualToString:ZPRouteConfig.routeSchemeSECWeb];
}


+ (BOOL)isStandardHost:(NSString *)host {
    return [host isEqualToString:ZPRouteConfig.routeHostClient];
}
@end
