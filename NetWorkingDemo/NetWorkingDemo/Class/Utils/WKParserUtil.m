//
//  WKParserUtil.m
//  WK
//
//  Created by Wei, Chengjiong on 8/26/12.
//  Copyright (c) 2012 Wei, Chengjiong. All rights reserved.
//

#import "WKParserUtil.h"


@implementation WKParserUtil

+ (BOOL)dictionary:(NSDictionary *)dictionary hasKey:(NSString *)key
{
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
#if LOG_JSON_PARSER_WARNING == 1
		DDLogError(@"input has wrong type: %@", dictionary);
#endif
		return NO;
	}
    if ([dictionary objectForKey:key]) {
        return YES;
    } else {
        return NO;
    }
}

+ (id)object:(NSDictionary *)dictionary key:(NSString *)key
{
	if (![dictionary isKindOfClass:[NSDictionary class]]) {
#if LOG_JSON_PARSER_WARNING == 1
		DDLogError(@"input has wrong type: %@", dictionary);
#endif
		return nil;
	}
	id obj = [dictionary objectForKey:key];
	if ([obj isKindOfClass:[NSNull class]]) {
		return nil;
	}
	return obj;
}

+ (NSString *)stringValue:(NSDictionary *)dictionary key:(NSString *)key
{
	id obj =  [self object:dictionary key:key];
	if (!obj) {
        return nil;
    }

	if ([obj isKindOfClass:[NSString class]]) {
		return obj;
	} else {
#if LOG_JSON_PARSER_WARNING == 1
        DDLogWarn(@"Wrong data type, the value for %@ is not a string", key);
#endif
        if ([obj isKindOfClass:[NSNumber class]]) {
            return [obj stringValue];
        }
    }
    return nil;
}

+ (NSNumber *)numberValue:(NSDictionary *)dictionary key:(NSString *)key
{
	id obj = [self object:dictionary key:key];
	if (!obj) {
        return nil;
    }
	
	if ([obj isKindOfClass:[NSNumber class]]) {
		return obj;
	} else {
#if LOG_JSON_PARSER_WARNING == 1
        DDLogWarn(@"Wrong data type, the value for %@ is not a number", key);
#endif
        if ([obj isKindOfClass:[NSString class]]) {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            NSNumber *num = [formatter numberFromString:(NSString *)obj];
            return num;
        }
    }
    return nil;
}

+ (int)intValue:(NSDictionary *)dictionary key:(NSString *)key
{
	id obj = [self numberValue:dictionary key:key];
	return [obj intValue];
}

+ (float)floatValue:(NSDictionary *)dictionary key:(NSString *)key
{
	id obj = [self numberValue:dictionary key:key];
	return [obj floatValue];
}

+ (double)doubleValue:(NSDictionary *)dictionary key:(NSString *)key
{
    id obj = [self numberValue:dictionary key:key];
	return [obj doubleValue];
}

+ (BOOL)boolValue:(id)value
{
	if (!value) {
		return NO;
	} else if ([value isKindOfClass:[NSNull class]]) {
		return NO;
	} else if ([value isKindOfClass:[NSNumber class]]) {
		return [value boolValue];
	} else if ([value isKindOfClass:[NSString class]]) {
		value = [value lowercaseString];
		if ([value isEqualToString:@"yes"] || [value isEqualToString:@"true"] || [value isEqualToString:@"1"]) {
            return YES;
        }
	}
    return NO;
}

+ (BOOL)boolValue:(NSDictionary *)dictionary key:(NSString *)key
{
	id obj = [dictionary objectForKey:key];
	return [self boolValue:obj];
}

+ (NSDictionary *)map:(NSDictionary *)dictionary key:(NSString *)key
{
	id obj =  [self object:dictionary key:key];
	if (!obj || ![obj isKindOfClass:[NSDictionary class]]) {
		return nil;
	}
	return obj;
}

+ (NSArray *)array:(NSDictionary *)dictionary key:(NSString *)key
{
	id obj =  [self object:dictionary key:key];
	if (!obj || ![obj isKindOfClass:[NSArray class]]) {
		return nil;
	}
	return obj;
}

+ (NSArray *)stringArray:(NSDictionary *)dictionary key:(NSString *)key
{
	id obj =  [self object:dictionary key:key];
	if (!obj || ![obj isKindOfClass:[NSArray class]]) {
		return nil;
	}
    
	NSArray *array = obj;
	NSMutableArray *returnArry = [NSMutableArray arrayWithCapacity:array.count];
	
	for (id item in array) {
		if ([item isKindOfClass:[NSString class]]) {
			[returnArry addObject:item];
		} else {
#if LOG_JSON_PARSER_WARNING == 1
			DDLogWarn(@"The array item is not NSString: %@", item);
#endif
			if ([item isKindOfClass:[NSNumber class]]) {
				[returnArry addObject:[(NSNumber *)item stringValue]];
			}
		}
	}
    
	return returnArry;	
}

+ (NSDate *)dateValue:(id)json key:(NSString *)key
{
	NSNumber *value = [self numberValue:json key:key];
	if (!value) {
		return nil;
	}
	return [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
}

+ (NSDate *)dateValue:(NSDictionary *)dictionary withFormat:(NSString *)format key:(NSString *)key
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [self dateValue:dictionary withFormatter:formatter key:key];
}

+ (NSDate *)dateValue:(NSDictionary *)dictionary withFormatter:(NSDateFormatter *)formatter key:(NSString *)key
{
    NSString *value = [self stringValue:dictionary key:key];
    NSDate *date = [formatter dateFromString:value];
    return date;
}

+ (void)encodeDate:(NSDate *)date withCoder:(NSCoder *)coder forKey:(NSString *)key
{
	if (!date) {
		return;
	}
	NSNumber *value = [NSNumber numberWithDouble:[date timeIntervalSince1970]];
	[coder encodeObject:value forKey:key];
}

+ (NSDate *)decodeDateWithCoder:(NSCoder *)coder forKey:(NSString *)key
{
	NSNumber *value = [coder decodeObjectForKey:key];
	if (!value) {
		return nil;
	}
	return [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
}

+ (NSString *)httpFormStringFromParams:(NSDictionary *)params
{
    NSArray *keys = [params allKeys];
	NSMutableString *urlString = [NSMutableString stringWithCapacity:1024];
	for (id k in keys) {
		if ([k isKindOfClass:[NSString class]]) {
			id value = [params objectForKey:k];
			if (![value isKindOfClass:[NSString class]]) {
				value = [value description];
			}
            if ([urlString length] != 0) {
                [urlString appendString:@"&"];
            }
			[urlString appendFormat:@"%@=%@",
                [k stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding],
                (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)value, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8)];
		}
	}
	return urlString;
}

+ (id)objectFromJsonData:(NSData *)data
{
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error) {
#if LOG_JSON_PARSER_WARNING == 1
        DDLogError(@"JSON reader error: %@", error);
        DDLogError(@"Incorrent JSON: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
#endif
        return nil;
    }
//    object = [self unicode2utf8OnObject:object];
	return object;
}

+ (NSString *)jsonStringFromObject:(id)object
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
    if (error) {
#if LOG_JSON_PARSER_WARNING == 1
        DDLogError(@"JSON writer error: %@", error);
#endif
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return jsonString;
}

// only change to utf8 for dictionary object
+ (id)unicode2utf8OnObject:(id)object
{
    if ([object isKindOfClass:NSDictionary.class]) {
        NSDictionary *originalDic = object;
        NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithCapacity:originalDic.count];
        [originalDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj isKindOfClass:NSDictionary.class]) {
                [newDic setObject:[self unicode2utf8OnObject:obj] forKey:key];
            } else if ([obj isKindOfClass:NSString.class]) {
                [newDic setObject:[(NSString *)obj unicode2utf8] forKey:key];
            } else {
                [newDic setObject:obj forKey:key];
            }
        }];
        return newDic;
    } else {
        return object;
    }
}

@end
