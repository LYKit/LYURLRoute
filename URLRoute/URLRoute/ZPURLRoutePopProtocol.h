//
//  ZPURLRoutePopProtocol.h
//  ZPURLRoute
//
//  Created by 赵学良 on 2018/9/24.
//  Copyright © 2018年 zhaoxueliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZPURLRoutePopProtocol <NSObject>

@optional

/**
 *  使用url路由返回时，对viewcontroller进行数据配置
 *
 *  @param param 传入的url字典数据，包括页面具体参数
 */
- (void)routePopOutWithParam:(NSDictionary *)param;

@end
