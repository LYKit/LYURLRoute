//
//  NSString+URLEncoded.m
//  ZPURLRoute
//

#import "NSString+ZPURLCode.h"

@implementation NSString (ZPURLCode)

- (NSString *)URLEncodedString {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8));
#pragma clang diagnostic pop
    return result;
}

- (NSString*)URLDecodedString {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8));
#pragma clang diagnostic pop
    return result;
}

@end

