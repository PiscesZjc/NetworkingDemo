//
//  WKFileUtil.m
//  WK
//
//  Created by Wei, Chengjiong on 9/4/12.
//  Copyright (c) 2012 Wei, Chengjiong. All rights reserved.
//

#import "WKFileUtil.h"

@implementation WKFileUtil

+ (NSDictionary *)dictionaryFromConfig:(NSString *)configFileName
{
	NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:configFileName];
	return [NSDictionary dictionaryWithContentsOfFile:path];
}

+ (id)objectForKey:(NSString *)key fromConfig:(NSString *)configFileName
{
    NSDictionary *dic = [self dictionaryFromConfig:configFileName];
    return [dic objectForKey:key];
}

+ (NSArray *)arrayFromConfig:(NSString *)configFileName
{
	NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:configFileName];
	return [NSArray arrayWithContentsOfFile:path];
}

+ (NSString *)fileNameFromURL:(NSString *)url
{
    NSString *fileName = [url copy];
	fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
	fileName = [fileName stringByReplacingOccurrencesOfString:@" " withString:@"."];
	fileName = [fileName stringByReplacingOccurrencesOfString:@"?" withString:@"."];
	fileName = [fileName stringByReplacingOccurrencesOfString:@"&" withString:@"."];
	fileName = [fileName stringByReplacingOccurrencesOfString:@"%" withString:@"."];
	fileName = [fileName stringByReplacingOccurrencesOfString:@"=" withString:@"."];
    
	CFStringRef escapeChars = (CFStringRef) @":?#[]@!$&‚Äô()*+,;=\"/";
	NSString *result = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)fileName, NULL, escapeChars, kCFStringEncodingUTF8);
	
	return result;
}

+ (NSDate *)fileModifyTime:(NSString *)path
{
	NSError *error = nil;
	NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
	if (error) {
		DDLogError(@"<Disk Error> [File Attributes] could not get attributes of the file: %@", path);
		return nil;
	} else {
		return [attrs objectForKey:NSFileModificationDate];
	}
}

+ (NSDate *)fileCreateTime:(NSString *)path
{
	NSError *error = nil;
	NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
	if (error) {
		DDLogError(@"<Disk Error> [File Attributes] could not get attributes of the file: %@", path);
		return nil;
	} else {
		return [attrs objectForKey:NSFileCreationDate];
	}
}

+ (NSString *)deviceDocumentsPath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [paths objectAtIndex:0];
	return path;
}

+ (NSString *)deviceCachePath
{
	NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString * path = [paths objectAtIndex:0];
	return path;
}

+ (NSString *)appDataCachePath
{
	NSString *path = [self deviceCachePath];
	return [path stringByAppendingPathComponent:@"Data"];
}

+ (NSString *)appDataObjectCachePath
{
	NSString *path = [self appDataCachePath];
	return [path stringByAppendingPathComponent:@"ObjectCache"];
}

@end
