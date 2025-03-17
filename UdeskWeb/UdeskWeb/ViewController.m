//
//  ViewController.m
//  UdeskWeb
//
//  Created by xuchen on 2019/2/11.
//  Copyright © 2019 Udesk. All rights reserved.
//

#import "ViewController.h"
#import "TestIMViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Udesk H5接入Demo";
}

- (IBAction)testIM:(id)sender {
    [self.navigationController pushViewController:[TestIMViewController new] animated:YES];
}


@end
