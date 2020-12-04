# ZPRouter


接入招聘路由组件ZPRouter只需2个配置，就可以使用路由组件

````
// 注册scheme协议头
+ (void)registerScheme:(NSString *)scheme;

// 添加路由规则表
+ (void)addRouteWithPlistPath:(NSString *)path;
````



### 路由协议
在接入路由之前，需要先了解一下路由的协议规则,ZPRouter与绝大部分路由协议一样，使用：

scheme://host/path?k=v&k2=v2&k3=v3

不同点在于，ZPRouter优化了复杂的query数据情况，增加用于统一处理业务数据的
k=v

scheme://host/path?k=v&k2=v2&data={"k":"v","k2":"v2"}  

- k=v、k2=v2为协议本身数据，  
- data={"k1":"v1"}  为此url的业务数据，因为url跳转需要的业务数据更加复杂，  
常常伴随着内嵌的url等特殊情况，所以有必要对业务数据存放一个独立的k-v。

如下，是一个跳转简历详情的跳转url
````
bangjob://zcmclient/resumeDetailView?rf=1&data={
	"from": 1,
	"resumedata": {
		"userid": "EP:10",
		"isdate": 0,
		"phone": "xxx",
		"url": "https://hrgnode.58.com/zcm/resume58?resumeid=3_neyanEyanErQ_erQ_EyXlEDkTvHsnGdpne0knpsVlEnsnErsnisfnGyXTm**",
		"sid": "890b3b0e7119532da9ee4b9056d4dd801557821880200",
		"resumeid": "3_neyanEyanErQ_erQ_EyXlEDkTvHsnGdpne0knpsVlEnsnErsnisfnGyXTm**",
		"phoneProtected": 1
	}
}
````

```css
注意：需要对业务数据进行encode,因为它是一个json串.
```



### 页面规则制定
ZPRouter的页面规则制定，不是传统的由代码进行注册，而是交给路由规则表进行配置。  

````
{
    "schemename":{
        "main":{
            "home":{
                "_extend":"扩展参数",
                "_class":"HomeContoller",
                "_description":"首页"
            }
        },
        "module_a":{
            "home":{
                "_extend":"扩展参数",
                "_class":"ModuleHomeContoller",
                "_description":"业务线A的home页面"
            },
            "detail":{
                "_extend":"扩展参数",
                "_description":"业务线A的详情页页面",
                "_hold":{
                    "_class":"DetailHold"
                }
            }
        }
    }
}
````
 路由表遵循 scheme://host/path 的协议规则，此处规则表对于关系scheme协议为： 
 ```
 schemename://main/home  主App的首页，页面=HomeContoller 
 schemename://module_a/home  业务线A的首页，页面=ModuleHomeContoller
 schemename://module_a/detail 业务线A的详情页，拦截处理类=DetailHold  
```
main 和 module_a 代表不同的业务线模块，如果不需要区分业务线，可以统一命名。  
路由配置表推荐使用plist文件进行存储配置，如果考虑到安全性和需要动态更新跳转规则，可以由接口下发。  
  
    
    
### 接入ZPRouter
了解完上面的路由协议和规则配置，接下来只需要简单的对组件进行基础配置即可。  

**一、注册协议命名规则**  
```js
// 注册scheme命名  （必须）
[ZPRouteConfig registerScheme:@"routerdemo"];

// 注册host命名, (非必须，不区分业务线默认叫client)
[ZPRouteConfig setModule:@"main"]

// 注册query中存放业务数据的key命名  (非必须)
[ZPRouteConfig registerModule:@"data"]

// 此处代码URI为： routerdemo://main/xxx?data=xxx
```

**二、添加规则数据**
```js
    // 添加一个规则配置表
    [ZPRouteConfig addRouteWithPlistPath:@"xxx.plist"];
    
    // or 添加多个规则配置表
    [ZPRouteConfig addRouteWithPlistPaths:@[
        @"xxx.plist",
        @"xxx.plist",
        @"xxx.plist"
    ]];
    
    // or 添加服务端下发的规则配置数据
    [ZPRouteConfig addRouteDictionary:dict];
```


**三、回调函数**
```js
// 未登录下是否允许跳转，默认YES， 设置NO后需要等待登录成功后自动跳转
+ (BOOL)routeAllowJumpNotLogin;

// URL 即将跳转
+ (void)routeWillJump:(NSString *)url scheme:(ZPRouteScheme *)scheme customInfo:(NSDictionary *)customInfo;

// URL跳转失败
+ (void)routeFailed:(NSString *)url scheme:(ZPRouteScheme *)scheme fromPage:(UIViewController *)controller;

// URL跳转成功
+ (void)routeSuccess:(NSString *)url scheme:(ZPRouteScheme *)scheme fromPage:(UIViewController *)controller;

// 跳转规则不满足
+ (void)routeError:(NSString *)url scheme:(ZPRouteScheme *)scheme fromPage:(UIViewController *)controller;

// 外部唤起未登录情况下，跳转被拦截
+ (void)routeToNotLogin:(NSString *)url fromPage:(UIViewController *)controller from:(URLRouteFromType)from;
```


### 使用方法
**普通跳转**
```js
[self openRouteURLString:@"demo://module_a/home" parameter:nil options:nil];
```

**url含有参数跳转**
```js
// 发起跳转页
NSString *url = @"demo://module_a/home?data={\"name\":\"张三\",\"age\":\"20\"}";
[self openRouteURLString:url parameter:nil options:nil];

// 目的页Controller接收数据
- (void)routeWillPushControllerWithResult:(ZPRouteResultModel *)result {
    NSDictionary *dataParams = result.data;
    NSLog(@"name：%@  age：%@",dataParams[@"name"],dataParams[@"age"]);
}

// 如果跳转被拦截，则由拦截类接收数据
// return yes-业务能正常跳转， no-业务不能正常跳转。 用于收集跳转失败的数据。
- (BOOL)holdWithParameters:(ZPRouteResultModel *)result
{
    NSDictionary *data = result.data;
    if ([data[@"age"] intValue] < 18) {
        // 18岁以下禁入
        // push error page
        return NO;
    }
    // 18岁以上 go
    // push right page
    return YES;
}
```

**跳转含有自定义参数**
```js
[self openRouteURLString:@"demo://module_a/home" parameter:@{@"customInfo":@"自定义数据"} options:nil];
```

**跳转完成回调**
```js
[self openRouteURLString:@"demo://module_a/pageTwo" parameter:nil options:nil completion:^{
        NSLog(@"跳转完成回调");
} callParams:nil];
```

**跳转回传数据**
```js
// 发起跳转页接收回传数据
[self openRouteURLString:@"demo://module_a/pageTwo" parameter:nil options:nil completion:nil callParams:^(NSDictionary * _Nonnull params) {
    NSLog(@"------收到回传参数");
    if (params[@"vip"] && params[@"age"] > 18) {
        // 会员18岁了，可以开放功能
    }
}];

// 目的页回传数据
- (void)routeWillPushControllerWithResult:(ZPRouteResultModel *)result {
    if (self.callParams) {
        self.callParams(@{@"vip":@"yes",@"age":@"20"});
    }
}
```

**普通跳转**
```js

```

