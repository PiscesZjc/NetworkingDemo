//
//  WKDevelopUtil.h
//  WK
//
//  Created by weichengjiong on 12/20/12.
//  Copyright (c) 2012 Wei, Chengjiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKDevelopUtil : NSObject

+ (uint64_t)systemTime;
+ (double)systemTimeInNanoSeconds;
+ (NSString *)debugTime:(uint64_t)startTime;

+ (void)issuePeriodicLowMemoryWarning;
+ (void)performFakeMemoryWarning;

+ (void)printCurrentThreadID:(NSString *)env;

@end
