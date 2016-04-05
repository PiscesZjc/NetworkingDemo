//
//  WKParserUtil.h
//  WK
//
//  Created by Wei, Chengjiong on 8/26/12.
//  Copyright (c) 2012 Wei, Chengjiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKParserUtil : NSObject

// Existence
+ (BOOL)dictionary:(NSDictionary *)dictionary hasKey:(NSString *)key;

// Object
+ (id)object:(NSDictionary *)dictionary key:(NSString *)key;
+ (NSString *)stringValue:(NSDictionary *)dictionary key:(NSString *)key;
+ (NSNumber *)numberValue:(NSDictionary *)dictionary key:(NSString *)key;
+ (int)intValue:(NSDictionary *)dictionary key:(NSString *)key;
+ (float)floatValue:(NSDictionary *)dictionary key:(NSString *)key;
+ (double)doubleValue:(NSDictionary *)dictionary key:(NSString *)key;
+ (BOOL)boolValue:(id)value;
+ (BOOL)boolValue:(NSDictionary *)dictionary key:(NSString *)key;

// Collection
+ (NSDictionary *)map:(NSDictionary *)dictionary key:(NSString *)key;
+ (NSArray *)array:(NSDictionary *)dictionary key:(NSString *)key;
+ (NSArray *)stringArray:(NSDictionary *)dictionary key:(NSString *)key;

// NSDate
+ (NSDate *)dateValue:(id)json key:(NSString *)key;
+ (NSDate *)dateValue:(NSDictionary *)dictionary withFormat:(NSString *)format key:(NSString *)key;
+ (NSDate *)dateValue:(NSDictionary *)dictionary withFormatter:(NSDateFormatter *)formatter key:(NSString *)key;
+ (void)encodeDate:(NSDate *)date withCoder:(NSCoder *)coder forKey:(NSString *)key;
+ (NSDate *)decodeDateWithCoder:(NSCoder *)coder forKey:(NSString *)key;

// Array to String
+ (NSString *)httpFormStringFromParams:(NSDictionary *)params;

// JSON Data to Objective-C Object
+ (id)objectFromJsonData:(NSData *)data;

// Objective-C Object to JSON String
+ (NSString *)jsonStringFromObject:(id)object;

@end
