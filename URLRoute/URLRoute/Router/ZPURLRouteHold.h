//
//  ZPURLRouteHold.h
//  ZPURLRoute
//
//  Created by 赵学良 on 2018/9/24.
//  Copyright © 2018年 zhaoxueliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPURLRouteResult.h"
#import "ZPURLRouteHoldProtocol.h"

/** parameters的一些KEY */
extern NSString * const kRouteHoldLastViewController;   //堆栈的最后一个页面控制器
extern NSString * const kRouteHoldViewController;       //URL生成的ViewController
extern NSString * const kRouteHoldParameter;            //URL生成的属性参数


typedef void (^ZPURLRouteHoldCompleteBlock)(ZPURLRouteResult *result, NSDictionary *options, BOOL isHold, BOOL holdSuccess);

@interface ZPURLRouteHold : NSObject

@property (nonatomic, strong) NSArray *checkKeys;
@property (nonatomic, strong) NSArray *passKeys;
@property (nonatomic, strong) NSString *holdController;

- (void)dealHoldWithRouteResult:(ZPURLRouteResult *)routeResult completeBlock:(ZPURLRouteHoldCompleteBlock)completeBlock;

@end
