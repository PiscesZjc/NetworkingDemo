//
//  WKFileUtil.h
//  WK
//
//  Created by Wei, Chengjiong on 9/4/12.
//  Copyright (c) 2012 Wei, Chengjiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKFileUtil : NSObject

// get an objective-c dictionary from a plist file
+ (NSDictionary *)dictionaryFromConfig:(NSString *)configFileName;
+ (id)objectForKey:(NSString *)key fromConfig:(NSString *)configFileName;

// get an objective-c array from a plist file
+ (NSArray *)arrayFromConfig:(NSString *)configFileName;

// get file name from an url, for network data cache
+ (NSString *)fileNameFromURL:(NSString *)url;

// file attribute
+ (NSDate *)fileModifyTime:(NSString *)path;
+ (NSDate *)fileCreateTime:(NSString *)path;

// file paths for app file and data cache
+ (NSString *)deviceDocumentsPath;
+ (NSString *)deviceCachePath;
+ (NSString *)appDataCachePath;
+ (NSString *)appDataObjectCachePath;

@end
