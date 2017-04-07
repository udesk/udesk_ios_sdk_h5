### 			Udesk iOS-h5 使用须知

#### 1.键盘遮挡输入框问题

这个问题一般发生在使用第三方键盘时候，使用系统键盘不会出现

解决办法：

```objective-c
//这里监听键盘事件（如果使用第三键盘，会导致键盘把输入框遮挡，使用此方法解决）
[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];

//这里监听键盘事件（如果使用第三键盘，会导致键盘把输入框遮挡，使用此方法解决）
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        if (keyboardF.origin.y > self.view.height) {
            _wkWebView.top = self.view.height - _wkWebView.height;
        } else {
            _wkWebView.top = keyboardF.origin.y - _wkWebView.height;
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