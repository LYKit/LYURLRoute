//
//  TestModuleAControllerTwo.m
//  demo
//
//  Created by 赵学良 on 2020/12/1.
//

#import "TestModuleAControllerTwo.h"
#import "ZPRouteResultModel.h"

@interface TestModuleAControllerTwo ()
@property (nonatomic, copy) ZPURLRouteCallParamsBlock callParams;

@end

@implementation TestModuleAControllerTwo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"ModuleA_Two";
    
    [self simulateNetwork];
}


- (void)simulateNetwork {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.callParams) {
            self.callParams(@{@"key1":@"value1",@"key2":@"value2"});
        }
    });
}



/**
 *  url路由跳转时，对viewcontroller进行数据配置
 *
 *  result 相关数据
 */
- (void)routeWillPushControllerWithResult:(ZPRouteResultModel *)result {
    self.callParams = result.callParams;
}


@end
