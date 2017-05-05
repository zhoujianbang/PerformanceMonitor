//
//  PerformanceMonitor.m
//  PerformanceMonitor
//
//  Created by XuChengcheng on 2017/5/5.
//  Copyright © 2017年 xcc. All rights reserved.
//

#import "PerformanceMonitor.h"


@interface PerformanceMonitor ()
{
    int timeoutCount;
    CFRunLoopObserverRef observer;
    
@public
    dispatch_semaphore_t semaphore;
    CFRunLoopActivity activity;
}
@end


@implementation PerformanceMonitor

+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    PerformanceMonitor *moniotr = (__bridge PerformanceMonitor*)info;
    
    moniotr->activity = activity;
    
    dispatch_semaphore_t semaphore = moniotr->semaphore;
    dispatch_semaphore_signal(semaphore);
}

- (void)stop
{
    if (!observer)
        return;
    
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    CFRelease(observer);
    observer = NULL;
}

- (void)start
{
    if (observer)
        return;
    
    // // 创建信号
    semaphore = dispatch_semaphore_create(0);
    
    // 注册RunLoop状态观察
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                       kCFRunLoopAllActivities,
                                       YES,
                                       0,
                                       &runLoopObserverCallBack,
                                       &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    
    // 在子线程监控时长
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES)
        {
            // 假定连续5次超时50ms认为卡顿(当然也包含了单次超时250ms)
            long st = dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 50 * NSEC_PER_MSEC));
            // Returns zero on success, or non-zero if the timeout occurred.
            if (st != 0)
            {
                if (!observer)
                {
                    timeoutCount = 0;
                    semaphore = 0;
                    activity = 0;
                    return;
                }
                
                // RunLoop会一直循环检测，从线程start到线程end，检测检测到事件源（CFRunLoopSourceRef）执行处理函数，首先会产生通知，corefunction向线程添加runloopObservers来监听事件，并控制NSRunLoop里面线程的执行和休眠，在有事情做的时候使当前NSRunLoop控制的线程工作，没有事情做让当前NSRunLoop的控制的线程休眠。
                
                if (activity == kCFRunLoopBeforeSources || activity == kCFRunLoopAfterWaiting)
                {
                    
                    if (++timeoutCount < 3)
                        continue;
                    
                    
                    
                    NSLog(@"有点儿卡");
                }
            }
            timeoutCount = 0;
        }
    });
}

@end
