//
//  ZPRouteConfigProtocol.h
//  LYURLRoute
//
//  Created by 赵学良 on 2020/11/30.
//  Copyright © 2020 LYKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPRouteResultModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZPRouteConfigProtocol <NSObject>

+ (void)routeWillJump:(NSString *)url scheme:(ZPRouteScheme *)scheme info:(NSDictionary *)info;

+ (void)routeFailed:(NSString *)url scheme:(ZPRouteScheme *)scheme fromPage:(UIViewController *)controller;

+ (void)routeSuccess:(NSString *)url scheme:(ZPRouteScheme *)scheme fromPage:(UIViewController *)controller;

+ (void)routeError:(NSString *)url scheme:(ZPRouteScheme *)scheme fromPage:(UIViewController *)fromPage;

+ (void)routeToNotLogin:(NSString *)url fromPage:(UIViewController *)controller from:(URLRouteFromType)from;
@end

NS_ASSUME_NONNULL_END
