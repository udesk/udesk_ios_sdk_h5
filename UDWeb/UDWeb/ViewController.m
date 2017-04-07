//
//  ViewController.m
//  UdeskWebAgent
//
//  Created by xuchen on 2017/3/15.
//  Copyright © 2017年 xushichen. All rights reserved.
//

#import "ViewController.h"
#import "UDWebViewViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *domianTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.domianTextField.text = @"http://udesksdk.udesk.cn/im_client";
    
}
- (IBAction)pushAction:(id)sender {
    
    UDWebViewViewController *push = [[UDWebViewViewController alloc] initWithURL:self.domianTextField.text];
    [self.navigationController pushViewController:push animated:YES];
}

- (IBAction)presentAction:(id)sender {
    
    UDWebViewViewController *present = [[UDWebViewViewController alloc] initWithURL:self.domianTextField.text];
    [self presentViewController:present animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
