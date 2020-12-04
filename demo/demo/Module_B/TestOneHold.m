//
//  TestOneHold.m
//  demo
//
//  Created by 赵学良 on 2020/11/30.
//

#import "TestOneHold.h"
#import "ZPRouteResultModel.h"
#import "TestModuleBControllerOne.h"
#import "TestModuleBControllerTwo.h"

@implementation TestOneHold

/**
 *  拦截跳转
 *
 *  @param result 你所能得到的数据
 *  return yes-业务能正常跳转， no-业务不能正常跳转。 用于收集跳转失败的数据。
 */
- (BOOL)holdWithParameters:(ZPRouteResultModel *)result
{
    UIViewController *fromContoller = result.fromController;
    NSDictionary *params = result.data;
    if ([params[@"ID"] isEqualToString:@"1"]) {
        // 模拟根据ID进行网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [fromContoller.navigationController pushViewController:[TestModuleBControllerOne new] animated:YES];
        });
    } else if ([params[@"ID"] isEqualToString:@"2"]) {
        [fromContoller.navigationController pushViewController:[TestModuleBControllerTwo new] animated:YES];
    } else {
        NSLog(@"ID不正确，无法跳转");
        return NO; // 如果ID不满足情况，无法完成页面的跳转，return NO 上报跳转失败
    }
    
    return YES;
}




@end
