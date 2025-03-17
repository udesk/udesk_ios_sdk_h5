//
//  TestIMViewController.m
//  UdeskWeb
//
//  Created by Admin on 2025/1/7.
//  Copyright © 2025 Udesk. All rights reserved.
//

#import "TestIMViewController.h"
#import <WebKit/WebKit.h>

@interface TestIMViewController ()<WKUIDelegate,WKNavigationDelegate, UIDocumentPickerDelegate>
@property (nonatomic, strong) WKWebView *wkWebView;
@end

@implementation TestIMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    _wkWebView.UIDelegate = self;
    _wkWebView.navigationDelegate = self;
    // 输入您自己的 插件地址
    [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://udesk-rd-bj-10.udesk.cn/im_client/?web_plugin_id=173851&agent_id=94197"]]];
    
    [self.view addSubview:_wkWebView];
    
    

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    self.title = @"Udesk H5 插件Demo测试";
    
    [self setBackBtn];
}


-(void)setBackBtn
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0.0, 0.0, 44.0, 44.0);
    [btn addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btn setTitle:@"返回" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    UIView *leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44.0)];
    leftView.backgroundColor=[UIColor clearColor];
    [leftView addSubview:btn];
    
    
    
    UIButton *closbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    closbtn.frame = CGRectMake(45.0, 0.0, 44.0, 44.0);
    [closbtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [closbtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    closbtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftView addSubview:closbtn];
    
    UIBarButtonItem *leftBtn=[[UIBarButtonItem alloc] initWithCustomView:leftView];
    
    self.navigationItem.leftBarButtonItem = leftBtn;
}

- (void)popself
{
    if([self.wkWebView canGoBack]){
        [self.wkWebView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)closeView
{
    [self.navigationController popViewControllerAnimated:YES];
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
    NSLog(@"在收到响应后，决定是否跳转。 3");
    //    decisionHandler(WKNavigationResponsePolicyCancel);
    
    if([self isDownLoadUrl:navigationResponse]){
        [self confirmDownLoadWithResponse:navigationResponse.response];
        //不允许跳转
        decisionHandler(WKNavigationResponsePolicyCancel);
    }else {
        //允许跳转
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
   
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

    
#pragma mark - 文件下载 -- 仅供参考
- (BOOL)isDownLoadUrl:(WKNavigationResponse *)navigationResponse {
    
    BOOL isDownload = false;
    // 确保 response 是 NSHTTPURLResponse
    if ([navigationResponse.response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)navigationResponse.response;
        NSDictionary *headers = httpResponse.allHeaderFields;
        // 检查 Content-Disposition 是否指示下载
        NSString *contentDisposition = headers[@"Content-Disposition"];
        isDownload = contentDisposition && [contentDisposition rangeOfString:@"attachment"].location != NSNotFound;
    }
    return (isDownload || !navigationResponse.canShowMIMEType);
}
// 文件下载确认
- (void)confirmDownLoadWithResponse:(NSURLResponse *)response {
    
    // 也可以选择下载文件到沙盒，自行在app内部管理
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存文件"
                                                                     message:@"是否将文件保存到文件应用？"
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self handleDownloadWithResponse:response];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:saveAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)handleDownloadWithResponse:(NSURLResponse *)response {
    NSURL *url = response.URL;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (error) {
            // 下载失败，提示用户
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"下载失败"
                                                                                     message:error.localizedDescription
                                                                             preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            });
            return;
        }

        // 下载成功，生成唯一的文件名
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *originalFilePath = [documentsPath stringByAppendingPathComponent:[response suggestedFilename]];
        NSString *uniqueFilePath = [self generateUniqueFileName:originalFilePath];

        NSError *moveError = nil;
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:uniqueFilePath] error:&moveError];

        if (moveError) {
            // 文件移动失败，提示用户
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存失败"
                                                                               message:moveError.localizedDescription
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            });
        } else {
            // 文件保存成功，保存到“文件”应用
            dispatch_async(dispatch_get_main_queue(), ^{
                [self saveToFilesApp:[NSURL fileURLWithPath:uniqueFilePath]];
            });
        }
    }];
    [task resume];
}
- (NSString *)extractFilenameFromContentDisposition:(NSString *)contentDisposition {
    if (!contentDisposition) {
        return nil;
    }

    // 正则表达式匹配 filename 和 filename* 字段
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"filename\\*?=\"([^\"]+)\"|filename\\*?=[^;]+\"?([^\";]+)\"?"
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:contentDisposition
                                                      options:0
                                                        range:NSMakeRange(0, contentDisposition.length)];
    if (match) {
        NSString *filename = nil;
        if (match.numberOfRanges > 1) {
            // 尝试获取 filename*（带编码的文件名）
            filename = [contentDisposition substringWithRange:[match rangeAtIndex:2]];
        }
        if (!filename && match.numberOfRanges > 2) {
            // 如果没有 filename*，尝试获取普通的 filename
            filename = [contentDisposition substringWithRange:[match rangeAtIndex:1]];
        }
        if (filename) {
            // 对文件名进行解码
            filename = [filename stringByRemovingPercentEncoding];
            return filename;
        }
    }
    return nil;
}
- (NSString *)generateUniqueFileName:(NSString *)originalFilePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileExtension = [originalFilePath pathExtension];
    NSString *fileNameWithoutExtension = [[originalFilePath stringByDeletingPathExtension] lastPathComponent];
    NSString *directoryPath = [originalFilePath stringByDeletingLastPathComponent];

    NSInteger counter = 1;
    NSString *newFilePath = originalFilePath;

    while ([fileManager fileExistsAtPath:newFilePath]) {
        NSString *newFileName = [NSString stringWithFormat:@"%@ (%ld).%@", fileNameWithoutExtension, (long)counter, fileExtension];
        newFilePath = [directoryPath stringByAppendingPathComponent:newFileName];
        counter++;
    }

    return newFilePath;
}

- (void)saveToFilesApp:(NSURL *)fileURL {
    if (@available(iOS 11.0, *)) {
        UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithURL:fileURL inMode:UIDocumentPickerModeExportToService];
        documentPicker.delegate = self;
        documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:documentPicker animated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"功能受限"
                                                                                     message:@"此功能需要 iOS 11 或更高版本。"
                                                                             preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存成功"
                                                                                     message:@"文件已成功保存到文件应用。"
                                                                             preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"操作取消"
                                                                                     message:@"文件保存操作已取消。"
                                                                             preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
}
@end
