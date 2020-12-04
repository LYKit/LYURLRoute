//
//  ZPURLRoutePushProtocol.h
//  ZPURLRoute
//
//  Created by 赵学良 on 2018/9/24.
//  Copyright © 2018年 zhaoxueliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPRouteResultModel.h"

extern NSString * const URLRouteVersion;

@protocol ZPURLRoutePushProtocol

@optional

/**
 *  url路由跳转时，对viewcontroller进行数据配置
 *
 *  result 相关数据
 */
- (void)routeWillPushControllerWithResult:(ZPRouteResultModel *)result;

/**
 *  页面push跳转后调用
 *
 *  result 相关数据
 */
- (void)routeDidPushControllerWithResult:(ZPRouteResultModel *)result;

@end
