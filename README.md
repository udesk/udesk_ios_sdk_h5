### 			Udesk iOS-h5 使用须知

#### 1.键盘遮挡输入框问题

解决办法：

```objective-c

[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        if (keyboardF.origin.y > CGRectGetHeight(self.view.frame)) {
        
            CGRect frame = _wkWebView.frame;
            frame.origin.y = CGRectGetHeight(self.view.frame) - CGRectGetHeight(_wkWebView.frame);
            _wkWebView.frame = frame;
        } 
        else {
            
            CGRect frame = _wkWebView.frame;
            frame.origin.y = keyboardF.origin.y - CGRectGetHeight(_wkWebView.frame);
            _wkWebView.frame = frame;
        }
    }];
}
```

#### 2.获取关闭会话事件

用户点击关闭之后如果需要在做些操作的话可以重写方法

使用WKWebview:

```objective-c
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler;
```

使用UIWebview:

```objective-c
//直接看demo吧，写了一个UIWebView的category
```

如果你觉得这个关闭太麻烦你可以在我们后台管理员端取消这个关闭按钮，自己写一个。

#### 3.点击发送图片之后会话页面就消失了

这个问题是因为通过present到会话页面，然后点击了h5上的上传图片，上传图片会弹出一个alert。点击某个按钮时系统会调用两次dismiss，导致会话页面消失了。

解决办法

```objective-c
//重写dismissViewControllerAnimated
- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {

    if (self.presentedViewController) {
        [super dismissViewControllerAnimated:flag completion:completion];
    }
}
//在需要dismiss的时候调用
[super dismissViewControllerAnimated:flag completion:completion];
```

#### 4.点击a标签无响应：target问题或打开新页面问题

解决办法 同时处理或者2选其一

```objective-c
//1、打开新页面时
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{

    NSLog(@"createWebViewWithConfiguration");
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
```

```objective-c
//2、监听url跳转事件
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
   if (!navigationAction.targetFrame.isMainFrame) {
       [webView evaluateJavaScript:@"var a = document.getElementsByTagName('a');for(var i=0;i<a.length;i++){a[i].setAttribute('target','');}" completionHandler:nil];
       if(navigationAction.targetFrame==nil){
           [webView loadRequest:navigationAction.request];
       }
   }
    decisionHandler(WKNavigationActionPolicyAllow);
}
```
