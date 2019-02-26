//
//  TKServerPicker.h
//  PingDemo
//
//  Created by yxibng on 2019/2/26.
//  Copyright © 2019 Goonbee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^TKServerPickerCallback)(NSString *host);

@interface TKServerPicker : NSObject

- (instancetype)initWithHosts:(NSArray *)hosts result:(TKServerPickerCallback)callback;
- (void)startPicking;
@end

NS_ASSUME_NONNULL_END
