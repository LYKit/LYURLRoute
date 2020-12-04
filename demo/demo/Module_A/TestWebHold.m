//
//  TestWebHold.m
//  demo
//
//  Created by 赵学良 on 2020/12/3.
//

#import "TestWebHold.h"
#import "ZPRouteResultModel.h"
#import "TestWebViewController.h"

@interface TestWebHold ()

@end

@implementation TestWebHold

/**
 *  拦截跳转
 *
 *  @param result 你所能得到的数据
 *  return yes-业务能正常跳转， no-业务不能正常跳转。 用于收集跳转失败的数据。
 */
- (BOOL)holdWithParameters:(ZPRouteResultModel *)result
{
    TestWebViewController *webVC = [TestWebViewController new];
    webVC.urlStr = result.urlStr;
    [result.fromController.navigationController pushViewController:webVC animated:YES];
    return YES;
}



@end
