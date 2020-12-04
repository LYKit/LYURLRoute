//
//  UIViewController+ZPURLRoute.h
//  ZPURLRoute
//
//  Created by 赵学良 on 2018/9/24.
//  Copyright © 2018年 zhaoxueliang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ZPURLRoutePopProtocol.h"
#import "ZPURLRoutePushProtocol.h"
#import "ZPRouteResultModel.h"
#import "ZPRouterOption.h"


@interface UIViewController (ZPURLRoute) <ZPURLRoutePopProtocol, ZPURLRoutePushProtocol>

/**
 *
 *  @param url      例如：scheme://module/page[?][key=value&key=value]
 *  @param options  自定义kURLRouteOpen参数
 *  parameter 除了url参数外，其他需要传递的参数
 */
- (void)openRouteURL:(NSURL *)url options:(NSDictionary *)options;
- (void)openRouteURL:(NSURL *)url options:(NSDictionary *)options parameter:(NSDictionary *)parameter;

@end


@interface UIViewController (ZPURLRouteHoldObject)

/**
 *  维持处理Hold的对象的生命周期
 *  需要重新获取则使用NSDictionary
 *  只需要位置使用NSArray
 *  默认NSObject
 */
@property (nonatomic, strong) id holdObject;

@end

