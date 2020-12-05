//
//  ViewController.m
//  demo
//
//  Created by 赵学良 on 2020/11/30.
//

#import "ViewController.h"
#import "ZPURLRouteKit.h"
#import "NSDictionary+ZPJSON.h"

static inline NSString* Sel(SEL sel) {
    return NSStringFromSelector(sel);
}

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"路由跳转";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self setupTitle];
    
    
    
    // 下发新规则和需要被替换的规则
    NSString *serverJson = @"{\"demo\":{\"module_d\":{\"home\":{\"_class\":\"TestErrorController\",\"_description\":\"新增模块D的one页面\"}}}}";
    
    // 模拟场景：App启动时网络请求下载最新路由规则，与本地规则进行融合。
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDictionary *routeDict = [NSDictionary ZP_dictionaryWithJSON:serverJson];
        [ZPRouteConfig addRouteDictionary:routeDict]; // 添加下发的规则数据，与本地规则数据进行融合
    });
}


- (void)setupTitle {
    _titles = @[@{@"普通跳转-无参":Sel(@selector(actionNonParameter))},
                @{@"普通跳转-有参":Sel(@selector(actionHasParameter))},
                @{@"跳转拦截处理1":Sel(@selector(actionHoldOne))},
                @{@"跳转拦截处理2":Sel(@selector(actionHoldTwo))},
                @{@"跳转参数回传":Sel(@selector(actionCallBack))},
                @{@"Present跳转方式":Sel(@selector(actionPresent))},
                @{@"动态更新/添加规则":Sel(@selector(updateRouterDate))},
                @{@"跳到web页--简单":Sel(@selector(actionNormalWeb))},
                @{@"跳到web页--复杂":Sel(@selector(actionCustomWeb))},
                @{@"safari等外部唤起跳转":Sel(@selector(actionOpen))},
                ];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentify"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentify"];
    }
    NSDictionary *cellDict = _titles[indexPath.row];
    cell.textLabel.text = cellDict.allKeys.firstObject;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *cellDict = _titles[indexPath.row];
    NSString *sel = cellDict.allValues.firstObject;
    SEL selector = NSSelectorFromString(sel);
    ((void (*)(id, SEL))[self methodForSelector:selector])(self, selector);
}




#pragma mark - function

// 普通跳转--无参  TestModuleAControllerOne
- (void)actionNonParameter {
    [self openRouteURLString:@"demo://module_a/home" parameter:nil options:nil];
}

// 普通跳转--有参  TestModuleAControllerOne 内接收参数
- (void)actionHasParameter {
    NSString *url = @"demo://module_a/home?data={\"name\":\"张三\",\"age\":\"20\"}";
    [self openRouteURLString:url parameter:@{@"customInfo":@"xxx"} options:nil]; // customInfo 自定义参数
}

// 跳转被拦截，在中转类进行处理  TestOneHold
- (void)actionHoldOne {
    [self openRouteURLString:@"demo://module_b/home?data={\"ID\":\"1\"}" parameter:nil options:nil];
}

// 跳转被拦截，在中转类进行处理  TestOneHold
- (void)actionHoldTwo {
    [self openRouteURLString:@"demo://module_b/home?data={\"ID\":\"2\"}" parameter:nil options:nil];
}

// 跳转需要数据回传   TestModuleAControllerTwo
- (void)actionCallBack {
    [self openRouteURLString:@"demo://module_a/pageTwo" parameter:nil options:nil completion:^{
        NSLog(@"跳转完成回调");
    } callParams:^(NSDictionary * _Nonnull params) {
        NSLog(@"------收到回传参数：%@",params);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"收到回传参数" message:params.description preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                  style:UIAlertActionStyleCancel
                                                handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}




// 模态跳转方式  TestModuleAControllerThree
- (void)actionPresent {
    /*
     * URLRouteOpenAnimatedPresent 模态跳转
     * kURLRouteOpenAnimated 动画YES
     */
    NSDictionary *options = @{kURLRouteOpenAnimatedTransition:@(URLRouteOpenAnimatedPresent),
                              kURLRouteOpenAnimated:@(YES)
                            };
    [self openRouteURLString:@"demo://module_a/pageThree" parameter:nil options:options];
}



// 动态更新、添加新规则
- (void)updateRouterDate {
    // 跳转一个当前本地不存在的规则 module_d，因为viewDidLoad已经下载过最新规则， 所以能正常跳转 但Controller是必须要已经存在的。
    [self openRouteURLString:@"demo://module_d/home" parameter:nil options:nil];
}



// 跳转到普通的web页
- (void)actionNormalWeb {
    [self openRouteURLString:@"https://www.baidu.com" parameter:nil options:nil];
}


// 跳转到需要参数等逻辑处理的web页
- (void)actionCustomWeb {
    [self openRouteURLString:@"demo://mainClient/web?data={\"url\":\"https://www.baidu.com\",\"title\":\"web标题\"}" parameter:nil options:nil];
}


// 浏览器唤起app并跳转
- (void)actionOpen {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"demo://module_a/home"]];
}

@end
