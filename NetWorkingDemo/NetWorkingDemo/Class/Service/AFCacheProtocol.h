//
//  AFCacheProtocol.h
//  NetWorkingDemo
//
//  Created by zjc on 16/3/3.
//  Copyright © 2016年 zjc. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol AFCacheEntryProtocol <NSObject>

@required
@property (nonatomic, copy) NSString *key;
@property (nonatomic,strong) NSDate *expireTime;
@property (nonatomic, strong) NSArray *objects;
@property (nonatomic) BOOL isSingleObjectValue;


@end

@protocol AFCacheProtocol <NSObject>

@required
// cache entry
- (id<AFCacheEntryProtocol>)createCacheEntryInContext:(NSManagedObjectContext *)context;
- (id<AFCacheEntryProtocol>)cacheEntryForKey:(NSString *)key inContext:(NSManagedObjectContext *)context;
- (void)deleteCacheEntry:(id<AFCacheEntryProtocol>)cacheEntry inContext:(NSManagedObjectContext*)context;
- (NSArray *)cacheEntriesInContext:(NSManagedObjectContext *)context;

// cached object
- (NSArray *)cachedObjectForOid:(NSString *)oid inClass:(Class)class inContext:(NSManagedObjectContext *)context;
- (NSArray *)cachedObjectsForCoreDataIDs:(NSArray *)ids inContext:(NSManagedObjectContext *)context;

// cache clear
- (void)clearServiceCache;

@end