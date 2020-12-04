//
//  ZPURLRoute.h
//  ZPURLRoute
//
//  Created by 赵学良 on 2018/9/24.
//  Copyright © 2018年 zhaoxueliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZPURLRouteResult;

typedef void (^ZPURLRouteCompleteBlock)(ZPURLRouteResult *result, NSDictionary *options, BOOL isHold, BOOL holdSuccess);

@interface ZPURLRoute : NSObject

- (BOOL)routeWithURL:(NSURL *)URL options:(NSDictionary *)options  parameter:(NSDictionary *)parameter completeblock:(ZPURLRouteCompleteBlock)completeBlock;

@end


