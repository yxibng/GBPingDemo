//
//  TKServerPicker.m
//  PingDemo
//
//  Created by yxibng on 2019/2/26.
//  Copyright © 2019 Goonbee. All rights reserved.
//

#import "TKServerPicker.h"
#import "TKPing.h"
@interface TKServerPicker ()
@property (nonatomic, copy) NSArray *hosts;
@property (nonatomic, copy) TKServerPickerCallback callback;
@property (nonatomic, strong) NSMutableArray *pings;
@end


@implementation TKServerPicker
- (instancetype)initWithHosts:(NSArray *)hosts result:(nonnull TKServerPickerCallback)callback
{
    if (self = [super init]) {
        self.hosts = hosts;
        self.callback = callback;
        self.pings = @[].mutableCopy;
    }
    return self;
}
- (void)startPicking
{
    [self.pings removeAllObjects];
    
    if (self.hosts.count == 0 || self.hosts.count == 1) {
        if (self.callback) {
            self.callback(self.hosts.firstObject);
        }
        return;
    }
    
    NSMutableDictionary *dic = @{}.mutableCopy;
    
    dispatch_group_t group = dispatch_group_create();
    
    for (NSString *ahost in self.hosts) {
        dispatch_group_enter(group);
        TKPing *ping =[TKPing startWithHost:ahost completion:^(NSTimeInterval rtt, NSString *host) {
            if (host) {
                [dic setObject:@(rtt) forKey:host];
            }
            dispatch_group_leave(group);
        }];
        
        [self.pings addObject:ping];
    }
    

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
       
        NSString *minHost = nil;
        NSTimeInterval minAvg = CGFLOAT_MAX;
        
        for (NSString *key in dic.allKeys) {
            NSNumber *value = [dic valueForKey:key];
            if (value.doubleValue < minAvg) {
                minHost = key;
                minAvg = value.doubleValue;
            }
        }
        
        if (self.callback) {
            self.callback(minHost);
        }
    });
}

@end
