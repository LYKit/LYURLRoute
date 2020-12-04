//
//  ZPURLRouteSupport.m
//  ZPURLRoute
//
//  Created by 赵学良 on 2018/9/24.
//  Copyright © 2018年 zhaoxueliang. All rights reserved.
//

#import "ZPURLRouteSupport.h"
#import "ZPURLRouteConfig.h"
#import "ZPRouteConfig.h"

NSString * const kRoutePrefixKey     = @"ZPDefault";          //内部plist前缀规则命名

@implementation ZPURLRouteSupport

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"PLISTSALLLOADED"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
            NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:resourcePath];
            for (NSString *fileName in enumerator) {
                if ([fileName hasPrefix:kRoutePrefixKey] && [fileName hasSuffix:@"URLRoute.plist"]) {
                    NSString *plistPath = [NSString stringWithFormat:@"%@/%@", resourcePath, fileName];
                    [ZPURLRouteConfig addRouteWithPlistPath:plistPath];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PLISTSALLLOADED" object:nil];
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"PLISTSALLLOADED"];
            });
        });
        
#ifdef DEBUG
        [[ZPURLRouteConfig routeDictionary] enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSDictionary *obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:@"ZPclient"]) {
                [obj enumerateKeysAndObjectsUsingBlock:^(NSString *key1, NSDictionary *obj1, BOOL * _Nonnull stop) {
                    [obj1 enumerateKeysAndObjectsUsingBlock:^(NSString * key2, NSDictionary * obj2, BOOL * _Nonnull stop) {
                        if ([obj2 isKindOfClass:[NSDictionary class]]) {
                            NSString *classString = obj2[@"_class"];
                            if (classString.length) {
                                Class cls = NSClassFromString(classString);
                                if (!cls) {
                                    NSLog(@"%@", [NSString stringWithFormat:@"ZPURLRouteConfig:%@类名不存在，请检查", classString]);
                                }
                            }
                            NSDictionary *hold = obj2[@"_hold"];
                            classString = hold[@"_class"];
                            if (classString.length) {
                                Class cls = NSClassFromString(classString);
                                if (!cls) {
                                    NSLog(@"%@", [NSString stringWithFormat:@"ZPURLRouteConfig:%@类名不存在，请检查", classString]);
                                }
                            }
                        }
                    }];
                }];
            }
        }];
#endif
    });
}

@end
