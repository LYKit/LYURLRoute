//
//  ZPURLBridge.m
//  ZPURLRoute
//
//  Created by 赵学良 on 2018/9/24.
//  Copyright © 2018年 zhaoxueliang. All rights reserved.
//

#import "ZPURLBridge.h"
#import "NSString+ZPURLCode.h"
#import "ZPRouteScheme.h"
#import "ZPRouteConfig.h"
#import "NSDictionary+ZPURLQuery.h"
#import "NSString+ZPURLCode.h"
#import "NSDictionary+ZPJSON.h"
#import "P_RouteYYModel.h"

@implementation ZPURLBridge

+ (NSURL *)routeURLWithKey:(NSString *)key parameter:(NSDictionary *)parameter {

    NSString *URLString = [NSString stringWithFormat:@"%@://%@/%@", ZPRouteConfig.routeSchemeClient, ZPRouteConfig.routeHostClient, key];
    return [self routeURLWithString:URLString parameter:parameter];
}

+ (NSURL *)routeURLWithKey:(NSString *)key dataJson:(NSString *)dataJson {
    if (dataJson.length) {
        NSString *json = [dataJson URLDecodedString];
        NSDictionary *params = [NSDictionary ZP_dictionaryWithJSON:json];
        return [self routeURLWithKey:key parameter:params]; // 避免原dataJson是未encode的
    } else {
        return [self routeURLWithKey:key parameter:nil];
    }
}


+ (NSURL *)routeURLWithString:(NSString *)urlString parameter:(NSDictionary *)parameter
{
    NSURL *url = [NSURL URLWithString:urlString];
    if (![ZPRouteScheme isStandardURL:url]) {
        return nil;
    }
    if (!parameter.allValues.count) {
        return url;
    }
    
    ZPRouteScheme *routeScheme = [[ZPRouteScheme alloc] initWithURL:url];
    NSMutableDictionary *paramTotal = [routeScheme.parameter mutableCopy]; // url 所有参数
    NSString *jsonData = paramTotal[ZPRouteConfig.routeURLDataKey];    // dataJson
    NSDictionary *dataParam = [NSDictionary ZP_dictionaryWithJSON:jsonData]; // data
    if (jsonData && ![jsonData isKindOfClass:[NSString class]]) {
        return url;  // url 中的data非json，不合法， parameter 无法插入
    }
    else if (!jsonData.length){ // url 无data，创建data
        jsonData = [parameter yy_modelToJSONString];
        if (jsonData) {
            paramTotal = paramTotal?: [NSMutableDictionary dictionary];
            [paramTotal setObject:[jsonData URLEncodedString] forKey:ZPRouteConfig.routeURLDataKey];
        }
    } else if (dataParam.allValues) { // url有data， parameter 插入data
        NSMutableDictionary *dataParamNew = [dataParam mutableCopy];
        [dataParamNew addEntriesFromDictionary:parameter];
        jsonData = [dataParamNew yy_modelToJSONString];
        paramTotal[ZPRouteConfig.routeURLDataKey] = [jsonData URLEncodedString];
    } else {
        return url;
    }
    
    NSString *query = [paramTotal queryWithDictionary];
    NSString *urlStr = [NSString stringWithFormat:@"%@://%@/%@?%@",routeScheme.scheme,routeScheme.module,routeScheme.page,query?:@""];
    return [NSURL URLWithString:urlStr];
}

@end
