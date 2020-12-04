//
//  NSURL+URLWithStringEncode.m
//  ZPURLRoute
//

#import "NSURL+ZPURLWithStringEncode.h"
#import "NSDictionary+ZPURLQuery.h"
#import "NSString+ZPURLCode.h"
#import <objc/runtime.h>

@implementation NSURL (URLWithStringEncode)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        const char* class_name = class_getName([self class]);
        Class metaClass = objc_getMetaClass(class_name);
        
        SEL originalSelector = @selector(URLWithString:);
        SEL newSelector = @selector(ZPurl_p_URLWithString:);
        
        Method originalMethod = class_getInstanceMethod(metaClass, originalSelector);
        Method newMethod = class_getInstanceMethod(metaClass, newSelector);
        
        BOOL methodAdded = class_addMethod([metaClass class],
                                           originalSelector,
                                           method_getImplementation(newMethod),
                                           method_getTypeEncoding(newMethod));
        
        if (methodAdded) {
            class_replaceMethod([metaClass class],
                                newSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        }
        else {
            method_exchangeImplementations(originalMethod, newMethod);
        }
    });
}

// 参数编码
+ (instancetype)ZPurl_p_URLWithString:(NSString *)URLString {
    NSString *newURLString = [URLString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSURL *url = [NSURL ZPurl_p_URLWithString:newURLString];
    if (!url) {
        NSArray *markArray = [URLString componentsSeparatedByString:@"?"];
        if (markArray.count == 2) {
            NSString *query = markArray.lastObject;
            NSDictionary *dict = [NSDictionary dictionaryWithURLQuery:query];
            NSMutableString *aParameter = [NSMutableString string];
            [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [aParameter appendFormat:@"%@=%@&", key, [obj URLEncodedString]];
            }];
            aParameter.length ? [aParameter deleteCharactersInRange:NSMakeRange([aParameter length] - 1, 1)] : [aParameter appendString:query];
            NSString *newURLString = [NSString stringWithFormat:@"%@?%@", markArray.firstObject, aParameter];
            return [NSURL ZPurl_p_URLWithString:newURLString];
        }
    }
    return url;
}
@end
