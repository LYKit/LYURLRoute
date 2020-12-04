//
//  ZPURLRouteResult.h
//  ZPURLRoute
//
//  Created by 赵学良 on 2018/9/24.
//  Copyright © 2018年 zhaoxueliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPRouteResultModel.h"
#import "ZPRouteScheme.h"

@class UIViewController;

extern NSString * const kRouteResultLastViewController;
extern NSString * const kRouteResultExtend;
extern NSString * const kRouteResultUseableURL;
extern NSString * const kRouteResultOriginalURL;
extern NSString * const kRouteOriginalURLString;

typedef NS_ENUM(NSUInteger, ZPURLRouteOpenType) {
    URLRouteOpenUndefine,
    URLRouteOpenWeb,
    URLRouteOpenNative,
    URLRouteOpenExternal,
    URLRouteOpenNotLogin,
};

@interface ZPURLRouteResult : NSObject

@property (nonatomic, assign, readonly) ZPURLRouteOpenType openType;

/** 将要打开的页面控制器 */
@property (nonatomic, strong) UIViewController *viewController;
/** 上一个页面控制器 */
@property (nonatomic, strong) UIViewController *lastViewController;
/** routescheme */
@property (nonatomic, strong) ZPRouteScheme *routeScheme;
/** 基本参数 */
@property (nonatomic, strong) NSDictionary *parameter;

/** 自定义传输的参数 */
@property (nonatomic, strong) NSDictionary *paramsCustom;
/** Route规则相关数据 */
@property (nonatomic, strong) NSDictionary *paramsRoute;

/** 外界使用的result */
@property (nonatomic, strong) ZPRouteResultModel *result;


/** 根据ZPRouteScheme.scheme初始化Result，生成openType */
- (instancetype)initWithScheme:(NSString *)scheme;


@end
