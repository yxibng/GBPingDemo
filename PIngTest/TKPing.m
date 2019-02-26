//
//  TKPing.m
//  PingDemo
//
//  Created by yxibng on 2019/2/26.
//  Copyright © 2019 Goonbee. All rights reserved.
//

#import "TKPing.h"
#import "GBPing.h"

#define PingCount 2
#define FailPingTimeinterval 1

@interface TKPing()<GBPingDelegate>
@property (nonatomic, strong) GBPing *ping;
@property (nonatomic, copy) TkPingCallback callback;
@property (nonatomic, strong) NSMutableArray *array;
@end

@implementation TKPing

+ (TKPing *)startWithHost:(NSString *)host completion:(TkPingCallback)completion{
    return [[self alloc] initWithHost:host completion:completion];
}

- (instancetype)initWithHost:(NSString *)host completion:(TkPingCallback)callback
{
    if (self = [super init]) {
        self.callback = callback;
        self.array = @[].mutableCopy;
        
        self.ping = [GBPing new];
        _ping.host = host;
        _ping.delegate = self;
        _ping.timeout = 1.0;
        _ping.pingPeriod = 0.1;
        
        [self.ping setupWithBlock:^(BOOL success, NSError *error) {
            if (success) {
                // start pinging
                [self.ping startPinging];
            } else {
                
                if (self.callback) {
                    self.callback(FailPingTimeinterval, self.ping.host);
                }
                NSLog(@"failed to start");
            }
        }];
    }
    return self;
}


-(void)ping:(GBPing *)pinger didReceiveReplyWithSummary:(GBPingSummary *)summary {
    NSLog(@"REPLY>  %@", summary);
    
    if (summary.sequenceNumber >= PingCount) {
        [self.ping stop];
        NSNumber *avg = [self.array valueForKeyPath:@"@avg.rtt"];
        if (self.callback) {
            self.callback(avg.doubleValue,self.ping.host);
        }
        self.ping = nil;
        self.callback = nil;
    } else {
        [self.array addObject:summary];
    }
}

-(void)ping:(GBPing *)pinger didReceiveUnexpectedReplyWithSummary:(GBPingSummary *)summary {
    NSLog(@"BREPLY> %@", summary);
    [self stopWithPingFailure];
}

-(void)ping:(GBPing *)pinger didSendPingWithSummary:(GBPingSummary *)summary {
    NSLog(@"SENT>   %@", summary);
}

-(void)ping:(GBPing *)pinger didTimeoutWithSummary:(GBPingSummary *)summary {
    NSLog(@"TIMOUT> %@", summary);
    [self stopWithPingFailure];
}

-(void)ping:(GBPing *)pinger didFailWithError:(NSError *)error {
    NSLog(@"FAIL>   %@", error);
    [self stopWithPingFailure];
}

-(void)ping:(GBPing *)pinger didFailToSendPingWithSummary:(GBPingSummary *)summary error:(NSError *)error {
    NSLog(@"FSENT>  %@, %@", summary, error);
    [self stopWithPingFailure];
}


- (void)stopWithPingFailure
{

    [self.ping stop];
    
    if (self.callback) {
        self.callback(FailPingTimeinterval,self.ping.host);
    }
    self.ping = nil;
    self.callback = nil;
}
@end
