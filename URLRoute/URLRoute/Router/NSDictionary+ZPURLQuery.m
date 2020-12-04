//
//  NSDictionary+URLCode.m
//  bangjob
//
//  Created by 赵学良 on 2018/12/26.
//  Copyright © 2018年 com.58. All rights reserved.
//

#import "NSDictionary+ZPURLQuery.h"
#import "P_RouteYYModel.h"
#import "NSString+ZPURLCode.h"

@implementation NSDictionary (ZPURLQuery)

+ (instancetype)dictionaryWithURLQuery:(NSString *)query {
    if (!query.length) {
        return nil;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (query.length && [query rangeOfString:@"="].location != NSNotFound) {
        if ([query rangeOfString:@"?"].location != NSNotFound) {
            NSMutableArray *hostqueryPairs = [[query componentsSeparatedByString:@"?"] mutableCopy];
            NSString *host = hostqueryPairs.firstObject;
            [hostqueryPairs removeObjectAtIndex:0];
            NSString *query = [hostqueryPairs componentsJoinedByString:@"?"];
            
            NSArray *keyValuePairs = [host componentsSeparatedByString:@"&"];
            for (int i = 0; i < keyValuePairs.count; i++) {
                BOOL last = i == keyValuePairs.count -1;
                NSString *keyValuePair = keyValuePairs[i];
                NSArray *pair = [keyValuePair componentsSeparatedByString:@"="];
                NSString *paramValue = pair.count == 2 ? pair.lastObject : @"";
                parameters[pair.firstObject] = ({
                    if (last) {
                        paramValue = [NSString stringWithFormat:@"%@?%@",paramValue,query];
                    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    [paramValue stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                }) ?: @"";
#pragma clang diagnostic pop
            }
            
        } else {
            NSArray *keyValuePairs = [query componentsSeparatedByString:@"&"];
            for (NSString *keyValuePair in keyValuePairs) {
                NSMutableArray *pair = [[keyValuePair componentsSeparatedByString:@"="] mutableCopy];
                NSString *paramKey = pair.firstObject;
                [pair removeObjectAtIndex:0];
                NSString *paramValue = pair.count > 0 ? [pair componentsJoinedByString:@"="] : @"" ;
                parameters[paramKey] = ({
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    [paramValue stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#pragma clang diagnostic pop
                }) ?: @"";
            }
        }
    }
    return parameters;
}



- (NSString *)queryWithDictionary {
    NSMutableString *paramString = [NSMutableString string];
    NSString *paramStr = @"";
    if (self.allValues) {
        [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                [paramString appendFormat:@"%@=%@&", key, obj];
            } else if ([obj isKindOfClass:[NSDictionary class]] ||
                       [obj isKindOfClass:[NSArray class]]) {
                NSString *json = [[obj yy_modelToJSONString] URLEncodedString];
                [paramString appendFormat:@"%@=%@&", key, json];
            }
        }];
        paramStr = [paramString substringToIndex:(paramString.length-1)];
    }
    return paramStr;
}

@end
