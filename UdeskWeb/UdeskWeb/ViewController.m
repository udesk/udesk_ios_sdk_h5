//
//  ViewController.m
//  UdeskWeb
//
//  Created by xuchen on 2019/2/11.
//  Copyright © 2019 Udesk. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    _wkWebView.UIDelegate = self;
    _wkWebView.navigationDelegate = self;
    [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://udesksdk.udesk.cn/im_client"]]];
    [self.view addSubview:_wkWebView];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        [self updateWebViewFrameWithKeyboardF:keyboardF];
    }];
}

- (void)updateWebViewFrameWithKeyboardF:(CGRect)keyboardF {

    if (keyboardF.origin.y > CGRectGetHeight(self.view.frame)) {
        
        CGRect frame = _wkWebView.frame;
        frame.origin.y = CGRectGetHeight(self.view.frame) - CGRectGetHeight(_wkWebView.frame);
        _wkWebView.frame = frame;
    } else {
        
        CGRect frame = _wkWebView.frame;
        frame.origin.y = keyboardF.origin.y - CGRectGetHeight(_wkWebView.frame);
        _wkWebView.frame = frame;
    }
}

#pragma mark - WKWebViewDelegate
//页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"页面开始加载时调用。   2");
}
//内容返回时调用，得到请求内容时调用(内容开始加载) -> view的过渡动画可在此方法中加载
- (void)webView:(WKWebView *)webView didCommitNavigation:( WKNavigation *)navigation
{
    NSLog(@"内容返回时调用，得到请求内容时调用。 4");
}
//页面加载完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:( WKNavigation *)navigation
{
    NSLog(@"页面加载完成时调用。 5");
}
//请求失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"error1:%@",error);
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"error2:%@",error);
}

//requst加载前 判断是否是用新标签页打开
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    NSLog(@"createWebViewWithConfiguration");
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

//在请求发送之前，决定是否跳转 -> 该方法如果不实现，系统默认跳转。如果实现该方法，则需要设置允许跳转，不设置则报错。
//该方法执行在加载界面之前
//Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Completion handler passed to -[ViewController webView:decidePolicyForNavigationAction:decisionHandler:] was not called'
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    
    //不允许跳转
    //    decisionHandler(WKNavigationActionPolicyCancel);
    NSLog(@"在请求发送之前，决定是否跳转。  1");
}
//在收到响应后，决定是否跳转（同上）
//该方法执行在内容返回之前
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //    decisionHandler(WKNavigationResponsePolicyCancel);
    NSLog(@"在收到响应后，决定是否跳转。 3");
    
}
//接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"接收到服务器跳转请求之后调用");
}
-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    NSLog(@"webViewWebContentProcessDidTerminate");
}

//警告框
/**
 webView界面中有弹出警告框时调用
 @param webView             web视图调用委托方法
 @param message             警告框提示内容
 @param frame               主窗口
 @param completionHandler   警告框消失调用
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    completionHandler();
    NSLog(@"警告框");
}
//输入框
/**
 web界面中弹出输入框时调用
 @param webView             web视图调用委托方法
 @param prompt              输入消息的显示
 @param defaultText         初始化时显示的输入文本
 @param frame               主窗口
 @param completionHandler   输入结束后调用
 */
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    NSLog(@"输入框");
    completionHandler(@"http");
}

#pragma mark - 可以在这关闭会话页面
/**
 显示一个JavaScript确认面板
 @param webView             web视图调用委托方法
 @param message             显示的信息
 @param frame               主窗口
 @param completionHandler   确认后完成处理程序调用
 */
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    NSLog(@"确认框");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(NO);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(YES);
        NSLog(@"可以在这关闭会话页面");
        
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [super dismissViewControllerAnimated:YES completion:nil];
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma 重写dismiss方法
- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    
    if (self.presentedViewController) {
        [super dismissViewControllerAnimated:flag completion:completion];
    }
}

@end
