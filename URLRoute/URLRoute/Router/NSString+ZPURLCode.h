//
//  NSString+URLEncoded.h
//  ZPURLRoute
//
//  Created by 赵学良 on 2018/9/24.
//  Copyright © 2018年 zhaoxueliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZPURLCode)

/** 对URL的参数编码 */
- (NSString *)URLEncodedString;
/** 对URL的参数解码 */
- (NSString *)URLDecodedString;


@end
