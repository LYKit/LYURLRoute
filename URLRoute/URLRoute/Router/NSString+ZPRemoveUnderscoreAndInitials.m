//
//  NSString+RemoveUnderscoreAndInitials.m
//  ZPURLRoute
//


#import "NSString+ZPRemoveUnderscoreAndInitials.h"

@implementation NSString (ZPRemoveUnderscoreAndInitials)

- (NSString *)removeUnderscoreAndInitials {
    NSString *aString = self;
    
    /*  _   :    等特殊字符替换，兼容老跳转定义的特别的key
    NSString *separateString = @"_";
    NSRange range = [aString rangeOfString:separateString];
    if (range.location != NSNotFound) {
        NSArray *subStrings = [aString componentsSeparatedByString:separateString];
        NSMutableArray *muteStrings = [NSMutableArray arrayWithArray:subStrings];
        [subStrings enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //首字母有数字则次位大写
            if (idx > 0) [muteStrings replaceObjectAtIndex:idx withObject:[obj capitalizedString]];
        }];
        return [muteStrings componentsJoinedByString:@""];
    }
     */
    return aString;
}

@end
