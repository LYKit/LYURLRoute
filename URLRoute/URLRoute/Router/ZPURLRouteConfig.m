//
//  ZPURLRouteConfig.m
//  ZPURLRoute
//
//  Created by 赵学良 on 2019/6/24.
//  Copyright © 2019年 com.58. All rights reserved.
//
#import "ZPURLRouteConfig.h"
#import "ZPRouteConfig.h"
#import "P_RouteYYModel.h"

NSString * const kRouteConfigClass      = @"_class";
NSString * const kRouteConfigBundle     = @"_bundle";
NSString * const kRouteConfigNib        = @"_nib";
NSString * const kRouteConfigExtend     = @"_extend";
NSString * const kRouteConfigHold       = @"_hold";
NSString * const kRouteConfigLoginHold  = @"LoginHold";

// 待完善
NSString * const kRouteConfigCheckKeys  = @"_checkKeys";
NSString * const kRouteConfigPassKeys   = @"_passKeys";

@interface ZPURLRouteConfig ()

@property (nonatomic, strong) NSMutableDictionary *p_routeDictionary;

@end

@implementation ZPURLRouteConfig

+ (instancetype)defaultRouteConfig {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = self.new;
    });
    return instance;
}

+ (void)addRouteDictionary:(NSDictionary *)routeDictionary {
    if ([routeDictionary isKindOfClass:[NSDictionary class]]) {
        [routeDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSDictionary   *obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:ZPRouteConfig.routeSchemeClient] && [obj isKindOfClass:[NSDictionary class]])
            {
                ZPURLRouteConfig *routeConfig = [ZPURLRouteConfig defaultRouteConfig];
                NSMutableDictionary *oldModules = [routeConfig.p_routeDictionary[ZPRouteConfig.routeSchemeClient] mutableCopy] ?: [NSMutableDictionary dictionary];
                
                [obj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSDictionary   *obj, BOOL * _Nonnull stop) {
                    NSMutableDictionary *moduleDict = [oldModules[key] mutableCopy] ?: [NSMutableDictionary dictionary];
                    [moduleDict addEntriesFromDictionary:obj];
                    oldModules[key] = moduleDict;
                }];
                if (oldModules) {
                    routeConfig.p_routeDictionary[key] = oldModules;
                }
            }
            else {
                ZPURLRouteConfig *routeConfig = [ZPURLRouteConfig defaultRouteConfig];
                NSMutableDictionary *oldDict = [routeConfig.p_routeDictionary[key] mutableCopy] ?: [NSMutableDictionary dictionary];
                NSDictionary *newDict = routeDictionary[key];
                if (newDict) {
                    [oldDict addEntriesFromDictionary:newDict];
                }
                if (oldDict) {
                    routeConfig.p_routeDictionary[key] = oldDict;
                }
            }
        }];
    }
}

+ (void)addRouteWithPlistPath:(NSString *)path {
    if ([path isKindOfClass:[NSString class]]) {
        NSData *plistData = [NSData dataWithContentsOfFile:path];
        if (plistData) {
            NSDictionary *dictionary = [NSPropertyListSerialization propertyListWithData:plistData
                                                                                 options:NSPropertyListImmutable
                                                                                  format:nil
                                                                                   error:nil];
            [self addRouteDictionary:dictionary];
        }
        else {
            NSAssert(plistData, ([NSString stringWithFormat:@"%@文件不存在", path]));
        }
    }
}

+ (void)addRouteWithPlistPaths:(NSArray *)paths {
    [paths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self addRouteWithPlistPath:obj];
    }];
}

+ (NSDictionary *)routeDictionary {
    ZPURLRouteConfig *routeConfig = [ZPURLRouteConfig defaultRouteConfig];
    NSDictionary *routeDictionary = [routeConfig.p_routeDictionary copy];
    return routeDictionary;
}


#pragma mark -
- (NSMutableDictionary *)p_routeDictionary {
    return _p_routeDictionary ?: ({
        _p_routeDictionary = [NSMutableDictionary dictionary];
    });
}

@end

