//
//  ZPURLBridge.h
//  ZPURLRoute
//
//  Created by 赵学良 on 2018/9/24.
//  Copyright © 2018年 zhaoxueliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPURLBridge : NSObject
/**
 *  自定义生成URL规则
 *
 *  @param key          页面key
 *  @param parameter 参数
 *
 *  @return 招才猫URL新规则
 */
+ (NSURL *)routeURLWithKey:(NSString *)key parameter:(NSDictionary *)parameter;


/**
 *  自定义生成URL规则
 *
 *  @param key          页面key
 *  @param dataJson  data对应参数
 *
 *  @return 招才猫URL新规则
 */
+ (NSURL *)routeURLWithKey:(NSString *)key dataJson:(NSString *)dataJson;



/**
 *  自定义生成URL规则
 *
 *  @param urlString url
 *  @param parameter 参数
 *
 *  @return 招才猫URL新规则
 */
+ (NSURL *)routeURLWithString:(NSString *)urlString parameter:(NSDictionary *)parameter;

@end
