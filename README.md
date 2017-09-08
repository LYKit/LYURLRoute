# LYURLRoute

App URL 路由设计

----  第一步  思路规划中。。。

                                
                                plist 文件、plist 文件名类
                                          |
                                          |
                                          V
                                  plist 解析映射类                 拦截处理类          参数回调类
                                          |                           |               ^
                                          |                           |               |
                                          V                           V               |
    AppDelegate（url 规则开启类）  ——>   添加规则类  ———>  Push 中转类  ——>跳转  —-—->   具    体    页    面  
                                                          ^           |               |           |
                                                          |           |               |           |
                                                          |           V               V           V
                                                    url 调用执行类  错误信息类        返回信息类   App 端信息类
                                                          |
                                                          |
                                                    url 解编码类
                                                          |
                                                          |
                                        url规则类 ———> url拆分类 
                                                          ^
                                                          |
                                                          |
                                        需要到达页面 custom://module/page?params&params&…
