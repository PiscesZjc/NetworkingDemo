//
//  SFPLogFormatter.m
//  SunFlowerProvider
//
//  Created by WeiChengjiong on 11/24/14.
//  Copyright (c) 2014 9Top. All rights reserved.
//

#import "SFPLogFormatter.h"

@implementation SFPLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    NSString *logLevel = nil;
    switch (logMessage.flag)
    {
        case DDLogFlagError:
            logLevel = @"[ERROR] >  ";
            break;
        case DDLogFlagWarning:
            logLevel = @"[WARN]  >  ";
            break;
        case DDLogFlagInfo:
            logLevel = @"[INFO]  >  ";
            break;
        case DDLogFlagDebug:
            logLevel = @"[DEBUG] >  ";
            break;
        default:
            logLevel = @"[VBOSE] >  ";
            break;
    }
    NSString *formatStr = [NSString stringWithFormat:@"%@[%@ %@][line %lu] %@",
                           logLevel, logMessage.fileName, logMessage.function,
                           (unsigned long)logMessage.line, logMessage.message];
    return formatStr;
}

@end
