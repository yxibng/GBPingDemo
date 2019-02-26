//
//  GBViewController.m
//  PingDemo
//
//  Created by yxibng on 2019/2/26.
//  Copyright © 2019 Goonbee. All rights reserved.
//

#import "GBViewController.h"
#import "TKServerPicker.h"

@interface GBViewController ()
@property (nonatomic, strong) TKServerPicker *picker;

@end

@implementation GBViewController
- (IBAction)ss:(id)sender {
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    
    self.picker = [[TKServerPicker alloc] initWithHosts:@[@"54.183.221.237",
                                                          @"35.180.234.79",
                                                          @"123.56.122.113"
                                                          ]
                                                 result:^(NSString * _Nonnull host) {
                                                     NSLog(@"%@",host);
                                                     
                                                     NSTimeInterval result = [[NSDate date] timeIntervalSince1970] - interval;
                                                     NSLog(@"%f",result);
                                                     
                                                 }];
    [self.picker startPicking];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
