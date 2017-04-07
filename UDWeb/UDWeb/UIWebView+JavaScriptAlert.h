//
//  UIWebView+JavaScriptAlert.h
//  UdeskWebAgent
//
//  Created by xuchen on 2017/4/5.
//  Copyright © 2017年 xushichen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>

@interface UIWebView (JavaScriptAlert)<UIAlertViewDelegate>

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame;

@end
