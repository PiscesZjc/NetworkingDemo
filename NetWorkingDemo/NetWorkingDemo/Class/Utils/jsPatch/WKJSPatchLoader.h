//
//  WKJSPatchLoader.h
//  NewAnnieDeer
//
//  Created by WeiChengjiongLH on 12/30/15.
//  Copyright © 2015 demo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    WKJSPatchUpdateErrorUnzipFailed = -1001,
    WKJSPatchUpdateErrorVerifyFailed = -1002,
} WKJSPatchUpdateError;


@interface WKJSPatchLoader : NSObject

+ (BOOL)run;
+ (void)loadAndRunPatch;
+ (NSInteger)currentVersion;
+ (BOOL)runTestScriptInBundle;

@end
