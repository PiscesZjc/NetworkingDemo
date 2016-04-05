//
//  AFBaseCache.m
//  NetWorkingDemo
//
//  Created by zjc on 16/3/3.
//  Copyright © 2016年 zjc. All rights reserved.
//

#import "AFBaseCache.h"
#import "AFCache.h"

@implementation AFBaseCache

- (id<AFCacheEntryProtocol>)cacheEntryForKey:(NSString*)key inContext:(NSManagedObjectContext*)context
{
    if (context != nil) {
        return [AFCache MR_createEntityInContext:context];
    }else{
        return [AFCache MR_createEntity];
    }
}

- (void)deleteCacheEntry:(id<AFCacheEntryProtocol>)cacheEntry inContext:(NSManagedObjectContext *)context
{
    if (![cacheEntry isKindOfClass:AFCache.class]) {
        DDLogError(@"CacheEntry type invalid!");
        return;
    }
    
    if (context != nil) {
        [(AFCache*)cacheEntry MR_deleteEntityInContext:context];
    }else{
        [(AFCache*)cacheEntry MR_deleteEntity];
    }
}

- (id<AFCacheEntryProtocol>)createCacheEntryInContext:(NSManagedObjectContext *)context
{
    if (context != nil) {
        return [AFCache MR_createEntityInContext:context];
    }else{
        return [AFCache MR_createEntity];
    }
}

- (NSArray*)cachedObjectForOid:(NSString *)oid inClass:(Class)class inContext:(NSManagedObjectContext *)context{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"oid = %@", oid];
    if (context != nil) {
        return [class MR_findAllWithPredicate:predicate inContext:context];
    } else {
        return [class MR_findAllWithPredicate:predicate];
    }
}

- (NSArray*)cachedObjectsForCoreDataIDs:(NSArray *)ids inContext:(NSManagedObjectContext *)context
{
    NSManagedObjectContext *cacheObjectContext = context;
    if (!cacheObjectContext) {
        cacheObjectContext = [NSManagedObjectContext MR_defaultContext];
    }
    NSMutableArray *cachedObjects = [NSMutableArray arrayWithCapacity:ids.count];
    [ids enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSManagedObjectID *objectID = [[NSPersistentStoreCoordinator MR_defaultStoreCoordinator] managedObjectIDForURIRepresentation:obj];
        NSManagedObject *object = [cacheObjectContext existingObjectWithID:objectID error:nil];
        if (!object.isDeleted) {
            [cachedObjects addObject:object];
        }
    }];
    return cachedObjects;
}

- (NSArray *)cacheEntriesInContext:(NSManagedObjectContext *)context
{
    if (context != nil) {
        return [AFCache MR_findAllInContext:context];
    }else{
        return [AFCache MR_findAll];
    }
}

- (void)clearServiceCache
{
 [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
     //清除缓存对象 do 对象+方法
     [NWDUserInfo MR_truncateAllInContext:localContext];
     
     //清除缓存索引
     [AFCache MR_truncateAllInContext:localContext];
 }];
}
@end
