//
//  ZPURLRoute.m
//  ZPURLRoute
//
//  Created by 赵学良 on 2018/9/24.
//  Copyright © 2018年 zhaoxueliang. All rights reserved.
//

#import "ZPURLRoute.h"
#import <UIKit/UIViewController.h>
#import "ZPURLRouteConfig.h"
#import "ZPURLRouteResult.h"
#import "ZPURLRouteHold.h"
#import "ZPRouteScheme.h"

static NSMutableDictionary *routeControllersMap = nil;

@interface ZPURLRoute ()

@property (nonatomic, strong) NSDictionary *routeDictionary;

@end

@implementation ZPURLRoute

+ (instancetype)defaultURLRoute {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = self.new;
    });
    return instance;
}

- (NSDictionary *)routeDictionary {
    return _routeDictionary ?: ({ _routeDictionary = [ZPURLRouteConfig routeDictionary]; });
}

- (BOOL)routeWithURL:(NSURL *)URL options:(NSDictionary *)options  parameter:(NSDictionary *)parameter completeblock:(ZPURLRouteCompleteBlock)completeBlock {
    BOOL isStandard = [ZPRouteScheme isStandardURL:URL];
    if (isStandard) {   //新规则
        NSMutableDictionary *blockParam = [NSMutableDictionary dictionary];
        [blockParam addEntriesFromDictionary:options];
        //根据URL在ZPRoute得到dict，或者是一个对象，可以得到项目、页面
        ZPRouteScheme *routeScheme = [[ZPRouteScheme alloc] initWithURL:URL];
        //根据规则修改成可用URL
        [blockParam addEntriesFromDictionary:routeScheme.parameter];
        [blockParam addEntriesFromDictionary:parameter];
        blockParam[kRouteResultUseableURL] = routeScheme.useableURL;
        blockParam[kRouteResultOriginalURL] = routeScheme.originalURL;
        
        ZPURLRouteResult *routeResult = [[ZPURLRouteResult alloc] initWithScheme:routeScheme.scheme];
        routeResult.lastViewController = blockParam[kRouteResultLastViewController];
        routeResult.parameter = blockParam;
        routeResult.routeScheme = routeScheme;
        routeResult.paramsCustom = parameter;
        
        switch (routeResult.openType) {
            case URLRouteOpenNotLogin: {
                NSDictionary *pageDictionary = self.routeDictionary[kRouteConfigLoginHold];
                if (!pageDictionary) {
                    NSLog(@"%@", [NSString stringWithFormat:@"登录拦截：“%@”不存在", routeScheme.scheme]);
                    return NO;
                }
                routeResult.paramsRoute = pageDictionary;
                routeResult.viewController = [self viewControllerWithPageDictionary:pageDictionary withBundleName:nil];

                ZPURLRouteHold *routeHold = [self routeHoldWithPageDictionary:pageDictionary];
                if (routeHold) {
                    [routeHold dealHoldWithRouteResult:routeResult completeBlock:completeBlock];
                } else {
                    if (completeBlock) completeBlock(routeResult, blockParam, NO, NO);
                }
            }
                break;
            case URLRouteOpenNative: {
                //根据这个对象在routeDictionary里获取对应的ViewController类
                NSDictionary *schemeDictionary = self.routeDictionary[routeScheme.scheme];
                if (!schemeDictionary) {
                    return NO;
                }
                NSDictionary *moduleDictionary = schemeDictionary[routeScheme.module];
                if (!moduleDictionary) {
                    NSLog(@"%@", [NSString stringWithFormat:@"ZPURLRoute module值错误：“%@”不存在", routeScheme.module]);
                    return NO;
                }
                NSDictionary *pageDictionary = moduleDictionary[routeScheme.page];
                if (!pageDictionary) {
                    NSLog(@"%@", [NSString stringWithFormat:@"ZPURLRoute page值错误：“%@”不存在", routeScheme.page]);
                    return NO;
                }
                routeResult.paramsRoute = pageDictionary;
                NSString *bundleName = pageDictionary[kRouteConfigBundle] ?: moduleDictionary[kRouteConfigBundle];
                routeResult.viewController = [self viewControllerWithPageDictionary:pageDictionary withBundleName:bundleName];
                
                ZPURLRouteHold *routeHold = [self routeHoldWithPageDictionary:pageDictionary];
                if (routeHold) {
                    [routeHold dealHoldWithRouteResult:routeResult completeBlock:completeBlock];
                }
                else {
                    if (completeBlock) completeBlock(routeResult, blockParam, NO, NO);
                }
            }
                break;
            case URLRouteOpenWeb: {
                NSDictionary *pageDictionary = self.routeDictionary[routeScheme.scheme];
                if (!pageDictionary) {
                    NSLog(@"%@", [NSString stringWithFormat:@"ZPURLRoute page值错误：“%@”不存在", routeScheme.scheme]);
                    return NO;
                }
                routeResult.viewController = [self viewControllerWithPageDictionary:pageDictionary withBundleName:nil];
                
                ZPURLRouteHold *routeHold = [self routeHoldWithPageDictionary:pageDictionary];
                if (routeHold) {
                    [routeHold dealHoldWithRouteResult:routeResult completeBlock:completeBlock];
                }
                else {
                    if (completeBlock) completeBlock(routeResult, blockParam, NO, NO);
                }
            }
                break;
            case URLRouteOpenExternal: {
                if (completeBlock) completeBlock(routeResult, blockParam, NO, NO);
            }
                break;
            default: {
                //FIXME:默认操作，打开一个网址，传入无法解析的URL
            }
                break;
        }
    }
    else {
        NSString *scheme = @"http";
        ZPURLRouteResult *routeResult = [[ZPURLRouteResult alloc] initWithScheme:scheme];
        routeResult.lastViewController = options[kRouteResultLastViewController];
        routeResult.paramsCustom = parameter;

        ZPRouteScheme *routeScheme = [[ZPRouteScheme alloc] initWithURL:URL];
        routeResult.routeScheme = routeScheme;
        
        NSDictionary *pageDictionary = self.routeDictionary[scheme];
        routeResult.viewController = [self viewControllerWithPageDictionary:pageDictionary withBundleName:nil];
        routeResult.parameter = options;    //将UseableURL传出去
        
        ZPURLRouteHold *routeHold = [self routeHoldWithPageDictionary:pageDictionary];
        if (routeHold) {
            [routeHold dealHoldWithRouteResult:routeResult completeBlock:completeBlock];
        }
        else {
            if (completeBlock) completeBlock(routeResult, options, NO, NO);
        }
    }
    return YES;
}

- (UIViewController *)viewControllerWithPageDictionary:(NSDictionary *)pageDictionary withBundleName:(NSString *)bundleName {
    NSString *pageClassName = pageDictionary[kRouteConfigClass];
    if (pageClassName.length) {
        NSString *pageBundleName = pageDictionary[kRouteConfigBundle] ?: bundleName;
        NSString *pageNibName = pageDictionary[kRouteConfigNib] ?: pageClassName;
        
        Class cls = NSClassFromString(pageClassName);
        if (cls && [cls isSubclassOfClass:[UIViewController class]]) {
            NSBundle *bundle = nil;
            if (pageBundleName.length) {
                bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:pageBundleName ofType:@"bundle"]];
            }
            pageNibName = [pageNibName length] > 0 ? pageNibName : nil;
            id retObj = bundle ? ([[cls alloc] initWithNibName:pageNibName bundle:bundle]) : ([[cls alloc] init]);
            return retObj;
        }
        else {
            NSLog(@"%@", [NSString stringWithFormat:@"ZPURLRoute %@类不存在", pageClassName]);
        }
    }
    return nil;
}

- (ZPURLRouteHold *)routeHoldWithPageDictionary:(NSDictionary *)pageDictionary {
    NSDictionary *pageHoldDictionary = pageDictionary[kRouteConfigHold];
    if ([pageHoldDictionary isKindOfClass:[NSDictionary class]]) {
        ZPURLRouteHold *routeHold = ZPURLRouteHold.new;
        routeHold.holdController = pageHoldDictionary[kRouteConfigClass];    //类最后处理
        routeHold.passKeys = pageHoldDictionary[kRouteConfigPassKeys];
        routeHold.checkKeys = pageHoldDictionary[kRouteConfigCheckKeys];
        return routeHold;
    }
    return nil;
}

@end
