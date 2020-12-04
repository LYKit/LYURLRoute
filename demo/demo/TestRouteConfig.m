//
//  TestRouteConfig.m
//  demo
//
//  Created by 赵学良 on 2020/11/30.
//

#import "TestRouteConfig.h"
#import "ZPRouteConfig.h"

@interface TestRouteConfig ()<ZPRouteConfigDelegate>

@end


@implementation TestRouteConfig


+ (void)defaultRouterConfing {
    [ZPRouteConfig registerURLRouteConfigClass:self];
    
    //  demo://module/page_key?data=xxx
    [ZPRouteConfig registerScheme:@"demo"]; // 注册scheme
    [ZPRouteConfig registerModule:@"data"]; // 注册queryname
    
    // 如果不区分业务线可统一注册一个
//    [ZPRouteConfig setModule:@"client"];
    
    // 如果有多个业务线，可分开配置各业务线跳转规则表。
    [ZPRouteConfig addRouteWithPlistPaths:@[
        [[NSBundle mainBundle] pathForResource:@"TestModule_A" ofType:@"plist"],
        [[NSBundle mainBundle] pathForResource:@"TestModule_B" ofType:@"plist"],
        [[NSBundle mainBundle] pathForResource:@"TestModule_C" ofType:@"plist"]
        // ...
    ]];
}

#pragma mark - ZPRouteConfigDelegate

// 未登录下是否允许跳转，默认YES， 设置NO后需要等待登录成功后自动跳转
+ (BOOL)routeAllowJumpNotLogin {
    return YES;
}

// 当前是否处于登录状态
+ (BOOL)routeConfigClientLoginStatus {
    return NO;
}

// URL即将跳转
+ (void)routeWillJump:(NSString *)url scheme:(ZPRouteScheme *)scheme customInfo:(NSDictionary *)customInfo
{
    NSLog(@"\n");
    NSLog(@"==== 即将发生跳转 ====");
    NSLog(@"跳转链接：%@",url);
    NSLog(@"跳转模块：%@",scheme.module);
    NSLog(@"跳转页面：%@",scheme.page);
    NSLog(@"跳转参数：%@",scheme.parameter);
    NSLog(@"自定义参数：%@",customInfo);
}

// URL跳转失败
+ (void)routeFailed:(NSString *)url scheme:(ZPRouteScheme *)scheme fromPage:(UIViewController *)controller
{
    NSLog(@"\n");
    NSLog(@"==== 跳转失败 ====");
    NSLog(@"跳转链接：%@",url);
    NSLog(@"跳转模块：%@",scheme.module);
    NSLog(@"跳转页面：%@",scheme.page);
    NSLog(@"跳转参数：%@",scheme.parameter);
    NSLog(@"跳转前页：%@",controller);
}

// URL跳转成功
+ (void)routeSuccess:(NSString *)url scheme:(ZPRouteScheme *)scheme fromPage:(UIViewController *)controller
{
    NSLog(@"\n");
    NSLog(@"==== 跳转成功 ====");
    NSLog(@"跳转链接：%@",url);
    NSLog(@"跳转模块：%@",scheme.module);
    NSLog(@"跳转页面：%@",scheme.page);
    NSLog(@"跳转参数：%@",scheme.parameter);
    NSLog(@"跳转前页：%@",controller);
}

// URL不满足跳转规则
+ (void)routeError:(NSString *)url scheme:(ZPRouteScheme *)scheme fromPage:(UIViewController *)controller {
    NSLog(@"\n");
    NSLog(@"==== URL不满足跳转规则 ====");
    NSLog(@"跳转链接：%@",url);
    NSLog(@"跳转模块：%@",scheme.module);
    NSLog(@"跳转页面：%@",scheme.page);
    NSLog(@"跳转参数：%@",scheme.parameter);
    NSLog(@"跳转前页：%@",controller);
}

// 外部唤起未登录情况下，跳转被拦截
+ (void)routeToNotLogin:(NSString *)url fromPage:(UIViewController *)controller from:(URLRouteFromType)from
{
    NSLog(@"\n");
    NSLog(@"==== 未登录拦截 ====");
    NSLog(@"跳转链接：%@",url);
    NSLog(@"跳转来源：%ld",from);
}

@end
