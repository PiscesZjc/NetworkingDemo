//
//  WKDevelopUtil.m
//  WK
//
//  Created by weichengjiong on 12/20/12.
//  Copyright (c) 2012 Wei, Chengjiong. All rights reserved.
//

#import "WKDevelopUtil.h"
#include <mach/mach_time.h>

@implementation WKDevelopUtil

+ (uint64_t)systemTime
{
	return mach_absolute_time();
}

+ (double)systemTimeInNanoSeconds
{
    mach_timebase_info_data_t timebase;
    mach_timebase_info(&timebase);
    
    double ticksToNanoseconds = (double)timebase.numer / timebase.denom;
    double ns = [self systemTime] * ticksToNanoseconds;
    return ns;
}

+ (NSString *)debugTime:(uint64_t)startTime
{
	uint64_t endTime = mach_absolute_time();
	uint64_t elapsedTime = endTime - startTime;
	
	mach_timebase_info_data_t timebase;
	mach_timebase_info(&timebase);
	
	double ticksToNanoseconds = (double)timebase.numer / timebase.denom;
	double ns = elapsedTime * ticksToNanoseconds;
	
	return [NSString stringWithFormat:@"%3f milliseconds", ns / 1000 / 1000];
}

+ (void)issuePeriodicLowMemoryWarning
{
    [self performFakeMemoryWarning];
    [self performSelector:@selector(issuePeriodicLowMemoryWarning) withObject:nil afterDelay:10];
}

+ (void)performFakeMemoryWarning
{
#ifdef DEBUG
    SEL memoryWarningSel;
    SuppressUndeclaredSelectorWarning(
        memoryWarningSel = @selector(_performMemoryWarning);
    );
    if ([[UIApplication sharedApplication] respondsToSelector:memoryWarningSel]) {
        SuppressPerformSelectorLeakWarning(
           [[UIApplication sharedApplication] performSelector:memoryWarningSel];
        );
    }else {
        DDLogWarn(@"Whoops UIApplication no longer responds to -_performMemoryWarning");
    }
#else
    DDLogWarn(@"Warning: performFakeMemoryWarning called on a non debug build");
#endif
}

+ (void)printCurrentThreadID:(NSString *)env
{
    DDLogDebug(@"[%@] Thread: %@", env, [[NSThread currentThread] valueForKeyPath:@"private.seqNum"]);
}

@end
