# LYURLRoute

App URL 路由设计

----  第一步  思路规划中。。。

参数定义类 ——>
宏定义类 ——>
App信息类 ——>
错误信息定义类 ——>                             
                                   plist 文件
                                        |
                                        |
                                        V
                                plist 文件名映射类
                                        |
                                        |
                                        V
                                plist 解析映射类              拦截跳转类	     参数回调类
                                        |						|				^
                                        |						|				|
                                        V						V				|
AppDelegate（url 规则开启类）  --——> 添加规则类  ———>  Push 中转类  ——>跳转  —-—->   具   体   页  面  
                                                    ^           |				|           |
                                                    |           |				|           |
                                                    |           |				|           |
                                                    |           V				V           V
                                               url 调用执行类   错误信息类       返回信息类   App 端信息类
                                                    |
                                                    |
                                               url 解/编码类
                                                    |
                                                    |
                                url 规则类 ———>  url 拆分类            
                                                    ^
                                                    |
                                                    |
                             需要到达页面 custom:// module/page?params&params&…
