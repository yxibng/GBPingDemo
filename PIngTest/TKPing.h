//
//  TKPing.h
//  PingDemo
//
//  Created by yxibng on 2019/2/26.
//  Copyright © 2019 Goonbee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TkPingCallback)(NSTimeInterval rtt, NSString *host);

@interface TKPing : NSObject
+(TKPing *)startWithHost:(NSString *)host completion:(TkPingCallback)completion;
@end

NS_ASSUME_NONNULL_END
