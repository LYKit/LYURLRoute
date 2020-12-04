//
//  TestWebKeyHold.m
//  demo
//
//  Created by 赵学良 on 2020/12/3.
//

#import "TestWebKeyHold.h"
#import "ZPRouteResultModel.h"
#import "TestWebViewController.h"

@implementation TestWebKeyHold

/**
 *  拦截跳转
 *
 *  @param result 你所能得到的数据
 *  return yes-业务能正常跳转， no-业务不能正常跳转。 用于收集跳转失败的数据。
 */
- (BOOL)holdWithParameters:(ZPRouteResultModel *)result
{
    NSDictionary *params = result.data;
    NSString *url = params[@"url"];
    NSString *title = params[@"title"];

    if (url.length) {
        TestWebViewController *webVC = [TestWebViewController new];
        webVC.urlStr = url;
        webVC.titleStr = title;
        [result.fromController.navigationController pushViewController:webVC animated:YES];
        return YES;
    }
    
    return NO; 
}


@end
