//
//  ZPURLRouteHoldProtocol.h
//  ZPURLRoute
//
//  Created by 赵学良 on 2018/9/24.
//  Copyright © 2018年 zhaoxueliang. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ZPRouteResultModel.h"

@protocol ZPURLRouteHoldProtocol <NSObject>

/**
 *  拦截URLRoute，自定义Hold
 *
 *  @param result 你所能得到的数据
 *  return yes-业务方能正常跳转， no-业务不能正常跳转。 用于统计线上跳转异常的情况。
 */
- (BOOL)holdWithParameters:(ZPRouteResultModel *)result;

@end
