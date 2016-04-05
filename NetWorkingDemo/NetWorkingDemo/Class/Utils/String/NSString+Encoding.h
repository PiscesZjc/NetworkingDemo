//
//  NSString+Encoding.h
//  WK
//
//  Created by Wei, Chengjiong on 12/23/2012.
//  Copyright (c) 2012 Wei, Chengjiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>


@interface NSString (Encoding)

// URL encode and decode
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

// UTF8 <-> Unicode
- (NSString *)unicode2utf8;
- (NSString *)utf82unicode;

@end
