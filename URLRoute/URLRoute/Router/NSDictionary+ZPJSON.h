//
//  NSDictionary+JSON.h
//  bangjob
//
//  Created by 赵学良 on 2019/4/19.
//  Copyright © 2019年 com.58. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (JSON)

+ (NSDictionary *)ZP_dictionaryWithJSON:(id)json;

+ (NSString *)dictionaryToJsonString;

@end

NS_ASSUME_NONNULL_END
