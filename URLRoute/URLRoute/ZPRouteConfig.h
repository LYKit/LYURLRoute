//
//  ZPRouteConfig.h
//  ZPURLRoute
//
//  Created by 赵学良 on 2019/4/3.
//  Copyright © 2019年 com.58. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZPRouteScheme.h"
#import "ZPRouteConfigProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZPRouteConfigDelegate;
@interface ZPRouteConfig : NSObject <ZPRouteConfigProtocol>

// http scheme
@property (class,nonatomic,copy,readonly) NSString *routeSchemeWeb;
// https scheme
@property (class,nonatomic,copy,readonly) NSString *routeSchemeSECWeb;
// 跳转外部 (暂不可用) scheme
@property (class,nonatomic,copy,readonly) NSString *routeSchemeExternal;
// 文件（暂不可用） scheme
@property (class,nonatomic,copy,readonly) NSString *routeSchemeFile;

// app main scheme
@property (class,nonatomic,copy,readonly) NSString *routeSchemeClient;
// default module
@property (class,nonatomic,copy,readonly) NSString *routeHostClient;
// URL.query数据所在key
@property (class,nonatomic,copy,readonly) NSString *routeURLDataKey;
// 是否登录
@property (class, nonatomic, assign, readonly) BOOL isLogin;



/// 路由配置入口
/// @param delegate 注册路由函数的配置类
+ (void)registerURLRouteConfigClass:(Class<ZPRouteConfigDelegate>)delegate;


/// 注册路由的scheme头名称, (必须)
/// @param scheme scheme头
+ (void)registerScheme:(NSString *)scheme;


/// 注册路由的业务线名称，默认"client", （非必须）
/// @param module 业务线命名， 如： scheme://业务线A/page?
+ (void)registerModule:(NSString *)module;


/// 注册跳转到外部的scheme
/// @param external 外部scheme
+ (void)registerExternal:(NSString *)external;


/// 注册query中存放业务数据的key命名    (必须)
/// @param queryName url链接中业务data数据的key名
+ (void)registerQueryName:(NSString *)queryName;


/// 添加路由规则本地存放的plist文件路径 (必须)
/// @param path  [[NSBundle mainBundle] pathForResource:@"业务A规则" ofType:@"plist"]
+ (void)addRouteWithPlistPath:(NSString *)path;
+ (void)addRouteWithPlistPaths:(NSArray *)paths;


/// 添加非本地path规则，通常由接口下发规则数据，与本地规则进行替换更新 （非必须）
/// @param routeDictionary 规则数据
+ (void)addRouteDictionary:(NSDictionary *)routeDictionary;

@end






/// 注册路由回调函数
@protocol ZPRouteConfigDelegate <NSObject>

/// 未登录下是否允许跳转，默认YES， 设置NO后需要等待登录成功后自动跳转
+ (BOOL)routeAllowJumpNotLogin;

/// 当前是否处于登录状态
+ (BOOL)routeConfigClientLoginStatus;


/// URL 即将跳转
/// @param url 跳转url
/// @param scheme url规则信息
/// @param customInfo 自定义参数
+ (void)routeWillJump:(NSString *)url scheme:(ZPRouteScheme *)scheme customInfo:(NSDictionary *)customInfo;


/// URL跳转失败
/// @param url 跳转url
/// @param scheme url规则信息
/// @param controller 发起跳转的页面
+ (void)routeFailed:(NSString *)url scheme:(ZPRouteScheme *)scheme fromPage:(UIViewController *)controller;


/// URL跳转成功
/// @param url 跳转url
/// @param scheme url规则信息
/// @param controller 发起跳转的页面
+ (void)routeSuccess:(NSString *)url scheme:(ZPRouteScheme *)scheme fromPage:(UIViewController *)controller;

/// 跳转规则不满足
/// @param url 跳转url
/// @param scheme url规则信息
/// @param controller 发起跳转的页面
+ (void)routeError:(NSString *)url scheme:(ZPRouteScheme *)scheme fromPage:(UIViewController *)controller;


/// 外部唤起未登录情况下，跳转被拦截
/// @param url 跳转url
/// @param controller 发起跳转的页面
/// @param from 跳转来源
+ (void)routeToNotLogin:(NSString *)url fromPage:(UIViewController *)controller from:(URLRouteFromType)from;

@end


NS_ASSUME_NONNULL_END
