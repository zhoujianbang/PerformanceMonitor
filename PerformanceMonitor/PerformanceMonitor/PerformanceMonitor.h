//
//  PerformanceMonitor.h
//  PerformanceMonitor
//
//  Created by XuChengcheng on 2017/5/5.
//  Copyright © 2017年 xcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PerformanceMonitor : NSObject

+ (instancetype)sharedInstance;

- (void)start;
- (void)stop;

@end
