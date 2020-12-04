//
//  ZPRouteResultModel.h
//  bangjob
//
//  Created by 赵学良 on 2019/4/23.
//  Copyright © 2019年 com.58. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZPRouteScheme.h"
#import "ZPRouterOption.h"
@class ZPRouteModel;

@interface ZPRouteResultModel : NSObject

// 触发跳转的来源， 默认客户端内部
@property (nonatomic, assign, readonly) URLRouteFromType fromType;

// 上一个页面控制器
@property (nonatomic, strong, readonly) UIViewController *fromController;

// 原始url，仅供查看，不可直接使用，请使用 urlStr
@property (nonatomic, copy, readonly) NSString *originalUrlStr;

// 新url，容错后重新encode之后的url，。
@property (nonatomic, copy, readonly) NSString *urlStr;

// 跳转规则model
@property (nonatomic, strong, readonly) ZPRouteModel *routeModel;

// url.query 中的'data'字段数据
@property (nonatomic, strong, readonly) NSDictionary *data;

// 非url自带，自定义给的参数, 可以包含非基本类型
@property (nonatomic, strong, readonly) NSDictionary *customInfo;

// 记录业务来源
@property (nonatomic, strong, readonly) NSString *source;

// 回传参数给上一个页面的callback
@property (nonatomic, copy) ZPURLRouteCallParamsBlock callParams;


- (instancetype)initWithURLScheme:(ZPRouteScheme *)routeScheme
                        cusParams:(NSDictionary *)cusParams
                     optionParams:(NSDictionary *)optionParams
                      routeParams:(NSDictionary *)routeParams;


@end





@interface ZPRouteModel : NSObject
@property (nonatomic, copy, readonly) NSString *scheme;   // scheme
@property (nonatomic, copy, readonly) NSString *host;     // host
@property (nonatomic, copy, readonly) NSString *key;      // page
@property (nonatomic, copy, readonly) NSString *extend;   // 扩展字段
@property (nonatomic, copy, readonly) NSString *desc;     // 描述
@property (nonatomic, copy, readonly) NSString *pageName; // 跳转的页面
@property (nonatomic, copy, readonly) NSString *holdName; // 拦截的页面

@end


