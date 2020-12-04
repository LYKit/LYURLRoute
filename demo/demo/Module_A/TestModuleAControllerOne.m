//
//  TestModuleAControllerOne.m
//  demo
//
//  Created by 赵学良 on 2020/11/30.
//

#import "TestModuleAControllerOne.h"
#import "ZPRouteResultModel.h"
@interface TestModuleAControllerOne ()
@property (nonatomic, copy) NSString *titleStr;

@end

@implementation TestModuleAControllerOne

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.titleStr ?: @"ModuleA_One";
}




/**
 *  url路由跳转时，对viewcontroller进行数据配置
 *
 *  result 相关数据
 */
- (void)routeWillPushControllerWithResult:(ZPRouteResultModel *)result {
    NSDictionary *dataParams = result.data;
    NSDictionary *customParams = result.customInfo;
    
    if (dataParams) {
        NSString *title = [NSString stringWithFormat:@"%@-%@",dataParams[@"name"],dataParams[@"age"]];
        self.titleStr = title;
    }
    
    NSLog(@"自定义传入参数为：%@",customParams);
}

@end
