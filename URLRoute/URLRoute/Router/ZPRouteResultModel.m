//
//  ZPRouteResultModel.m
//  bangjob
//
//  Created by 赵学良 on 2019/4/23.
//  Copyright © 2019年 com.58. All rights reserved.
//

#import "ZPRouteResultModel.h"
#import "ZPRouteConfig.h"
#import "NSDictionary+ZPJSON.h"
#import "P_RouteYYModel.h"
#import "ZPURLRouteResult.h"
#import "NSString+ZPURLCode.h"
#import "UIViewController+ZPURLRoute.h"

@interface ZPRouteHoldModel : NSObject

@property (nonatomic, copy) NSString *holdName;

@end

@implementation ZPRouteHoldModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"holdName" : @"_class"};
}

@end


@interface ZPRouteModel ()

@property (nonatomic, copy, readwrite) NSString *scheme;
@property (nonatomic, copy, readwrite) NSString *host;     
@property (nonatomic, copy, readwrite) NSString *key;
@property (nonatomic, copy, readwrite) NSString *extend;
@property (nonatomic, copy, readwrite) NSString *desc;
@property (nonatomic, copy, readwrite) NSString *pageName;
@property (nonatomic, copy, readwrite) NSString *holdName;

@property (nonatomic, copy) NSString *keyWrite;
@property (nonatomic, copy) NSString *extendWrite;
@property (nonatomic, copy) NSString *descWrite;
@property (nonatomic, copy) NSString *pageNameWrite;
@property (nonatomic, copy) NSString *holdNameWrite;
@property (nonatomic, strong) ZPRouteHoldModel *hold;

@end

@implementation ZPRouteModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"pageName" : @"_pageName",
             @"extend" : @"_extend",
             @"desc" : @"_description",
             @"hold" : @"_hold"};
}

- (void)setHold:(ZPRouteHoldModel *)hold {
    _hold = hold;
    _holdName = _hold.holdName;
}

- (void)setPageNameWrite:(NSString *)pageNameWrite {
    _pageNameWrite = pageNameWrite;
    _pageName = _pageNameWrite;
}

- (void)setExtendWrite:(NSString *)extendWrite {
    _extendWrite = extendWrite;
    _extend = _extendWrite;
}

- (void)setDescWrite:(NSString *)descWrite {
    _descWrite = descWrite;
    _desc = _descWrite;
}


@end



@interface ZPRouteResultModel ()
@property (nonatomic, assign, readwrite) URLRouteFromType fromType;
@property (nonatomic, strong, readwrite) UIViewController *fromController;
@property (nonatomic, copy, readwrite) NSString *originalUrlStr;
@property (nonatomic, copy, readwrite) NSString *urlStr;
@property (nonatomic, strong, readwrite) ZPRouteModel *routeModel;
@property (nonatomic, strong, readwrite) NSDictionary *data;
@property (nonatomic, strong, readwrite) NSDictionary *customInfo;
@property (nonatomic, strong, readwrite) NSString *source;

@end

@implementation ZPRouteResultModel

- (instancetype)initWithURLScheme:(ZPRouteScheme *)routeScheme
                        cusParams:(NSDictionary *)cusParams
                     optionParams:(NSDictionary *)optionParams
                      routeParams:(NSDictionary *)routeParams
{
    self = [super init];
    if (self) {
        NSString *jsonData = routeScheme.parameter[ZPRouteConfig.routeURLDataKey];
        jsonData = [self JSONString:jsonData];
        self.data = [NSDictionary ZP_dictionaryWithJSON:jsonData];
        self.customInfo = cusParams;
        self.routeModel = [ZPRouteModel yy_modelWithDictionary:routeParams];
        self.fromController = optionParams[kRouteResultLastViewController];
        self.originalUrlStr = [routeScheme.originalURL.absoluteString URLDecodedString];
        self.callParams = optionParams[kZPURLRouteCallParams];
        self.urlStr = routeScheme.originalURL.absoluteString;
        self.routeModel.scheme = routeScheme.scheme;
        self.routeModel.host = routeScheme.module;
        self.routeModel.key = routeScheme.page;
        
        id source = optionParams[kURLRouteOpenSource];
        if ([source isKindOfClass:NSString.class]) {
            self.source = source;
        }
        
        NSNumber *fromType = optionParams[kURLRouteOpenFromType];
        self.fromType = fromType ? fromType.integerValue : URLRouteFromClient;
    }
    return self;
    
}

- (NSString *)JSONString:(NSString *)aString {
    
    if (!aString || [aString length]==0) {
        return nil;
    }
    
    NSMutableString *s = [NSMutableString stringWithString:aString];
    [s replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\t" withString:@"\\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    return [NSString stringWithString:s];
}



@end
