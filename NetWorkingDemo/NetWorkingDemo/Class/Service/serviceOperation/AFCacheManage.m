//
//  AFCacheManage.m
//  NetWorkingDemo
//
//  Created by zjc on 16/3/3.
//  Copyright © 2016年 zjc. All rights reserved.
//

#import "AFCacheManage.h"

@interface AFCacheManage ()
{
    id<AFCacheProtocol> _cacheImplementation;
}

@end



@implementation AFCacheManage

+ (instancetype)sharedInstance
{
    static AFCacheManage *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AFCacheManage alloc] init];
    });
    return sharedInstance;
}

- (void)setupCacheImplementation:(id<AFCacheProtocol>)cacheImplementation
{
    _cacheImplementation = cacheImplementation;
}

- (id)objectsForCacheKey:(NSString *)key expireDate:(NSDate *)date inContext:(NSManagedObjectContext *)context
{
    id<AFCacheEntryProtocol> cacheEntry = [_cacheImplementation cacheEntryForKey:key inContext:context];
    if (!cacheEntry) {
        return nil;
    }
    //检查缓存事件
    if (NSOrderedAscending == [cacheEntry.expireTime compare:date]) {
        //异步删除过期缓存
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            [self invalidCacheForKey:key inValidEntry:YES inContext:localContext];
        }];
        return nil;
    }
    NSArray *coreDataIDs = cacheEntry.objects;
    NSArray *objects = [_cacheImplementation cachedObjectsForCoreDataIDs:coreDataIDs inContext:context];
    id returnedObject = nil;
    if (cacheEntry.isSingleObjectValue) {
        if (objects.count == 1) {
            returnedObject = objects[0];
        }else{
            DDLogError(@"[CORE DATA ERROR] cached object mismatch cache entry info!");
        }
    }else{
        returnedObject = objects;
    }
    return returnedObject;
}

- (void)removeObjectsForCacheKey:(NSString *)key inContext:(NSManagedObjectContext *)context
{
    [self invalidCacheForKey:key inValidEntry:YES inContext:context];
}

#pragma mark -private Method
- (void)invalidCacheForKey:(NSString *)key inValidEntry:(BOOL)inValidEntry inContext:(NSManagedObjectContext *)context
{
    NSParameterAssert(key);
    id<AFCacheEntryProtocol>cacheEntry = [_cacheImplementation cacheEntryForKey:key inContext:context];
    if (!cacheEntry) {
        return;
    }
    NSArray *coreDataIds = cacheEntry.objects;
    NSArray *objects = [_cacheImplementation cachedObjectsForCoreDataIDs:coreDataIds inContext:context];
    [context MR_deleteObjects:objects];
    if (inValidEntry) {
        //删除索引
        [_cacheImplementation deleteCacheEntry:cacheEntry inContext:context];
    }
    
}

// TODO: 怎么做到缓存对象和缓存索引的事务一致性
- (void)cacheObjects:(id)objects forKey:(NSString *)key expireDate:(NSDate *)date inContext:(NSManagedObjectContext *)context
{
    //检查对象类型是否正确
    NSArray *cacheObjects;
    if ([objects isKindOfClass:NSArray.class]) {
        cacheObjects = objects;
        [cacheObjects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (![obj isKindOfClass:NSManagedObject.class]) {
                DDLogError(@"[CORE DATA ERROR] object should be in class WKModelObject!");
                return;
            }
        }];
    }else if ([objects isKindOfClass:NSManagedObject.class]){
        cacheObjects = @[objects];
    }else if (objects == nil){
        cacheObjects = @[];
    }else{
        DDLogError(@"[CORE DATA ERROR] objects should be single WKModelObject object or WKModelObject objects array!");
        return;
    }
    
    //设置缓存索引
    //TODO:目前的做法，如果一个请求没有返回数据
    // TODO: 目前的做法，如果一个请求没有返回任何数据，那么不进行缓存，删除缓存索引。这样做可以吗？
    if (cacheObjects.count > 0) {
        //更新缓存索引
        id<AFCacheEntryProtocol> cacheEntry = [_cacheImplementation cacheEntryForKey:key inContext:context];
        if (!cacheEntry) {
            //新建缓存索引
            cacheEntry = [_cacheImplementation createCacheEntryInContext:context];
            cacheEntry.key = key;
        }
        cacheEntry.expireTime = date;
        //生成CoreData的永久ID
        NSError *error = nil;
        if (![context obtainPermanentIDsForObjects:cacheObjects error:&error]) {
            DDLogError(@"[CORE DATA ERROR] obtain permanent ids fail: %@", error);
            return;
        }
        //组objectID列表
        NSMutableArray *coreDataIDs = [NSMutableArray arrayWithCapacity:cacheObjects.count];
        [cacheObjects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSManagedObject *object = obj;
            [coreDataIDs addObject:object.objectID.URIRepresentation];
        }];
        cacheEntry.objects = [NSArray arrayWithArray:coreDataIDs];
        if ([objects isKindOfClass:NSManagedObject.class]) {
            cacheEntry.isSingleObjectValue = YES;
        }else{
            cacheEntry.isSingleObjectValue = NO;
        }
    }else{
        //删除缓存索引
        id<AFCacheEntryProtocol>cacheEntry = [_cacheImplementation cacheEntryForKey:key inContext:context];
        if (cacheEntry) {
            [_cacheImplementation deleteCacheEntry:cacheEntry inContext:context];
        }
    }
}

+ (id)coreDataObjectIDArrayFromObjects:(id)coreDataObjects
{
    if (coreDataObjects == nil) {
        return nil;
    }
    if ([coreDataObjects isKindOfClass:NSArray.class]) {
        NSArray *objects = coreDataObjects;
        NSMutableArray *objectIDs = [NSMutableArray arrayWithCapacity:objects.count];
        [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSManagedObject.class]) {
                NSManagedObject *modelObject = obj;
                [objectIDs addObject:[modelObject objectID]];
            }else{
                DDLogError(@"[CORE DATA ERROR] object should be core data object!");
            }
        }];
        return [NSArray arrayWithArray:objectIDs];
    }else if ([coreDataObjects isKindOfClass:NSManagedObject.class]){
        return [coreDataObjects objectID];
    }else{
        DDLogError(@"[CORE DATA ERROR] coreDataObjects should be core data object or its array!");
        return nil;
    }
}

+ (id)coreDataObjectsFromObjectIDs:(id)coreDataObjectIDs
{
    if (!coreDataObjectIDs) {
        return nil;
    }
    // 因为传递进来的是NSManagedObjectID对象，所以这里要根据ID取出所有的NSManagedObject
    __block NSError *error;
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    if ([coreDataObjectIDs isKindOfClass:NSArray.class]) {
        NSArray *ids = coreDataObjectIDs;
        NSMutableArray *modelObjects = [NSMutableArray arrayWithCapacity:ids.count];
        [ids enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSManagedObject.class]) {
                NSManagedObjectID *objectID = obj;
                NSManagedObject *object = [context existingObjectWithID:objectID error:&error];
                if (!error) {
                    [modelObjects addObject:object];
                }else{
                    DDLogError(@"[CORE DATA ERROR] %@", error);
                    
                }
            }else{
                DDLogError(@"[CORE DATA ERROR] object id should be core data object id!");
            }
        }];
        return [NSArray arrayWithArray:modelObjects];
    }else if ([coreDataObjectIDs isKindOfClass:NSManagedObjectID.class]){
        NSManagedObjectID *objectID = coreDataObjectIDs;
        NSManagedObject *object = [context existingObjectWithID:objectID error:&error];
        if (!error) {
            return object;
        }else{
            DDLogError(@"[CORE DATA ERROR] %@", error);
        }
    }else{
        DDLogError(@"[CORE DATA ERROR] coreDataObjectIDs should be core data object id or its array!");
        return nil;
    }
    if (error) {
        [MagicalRecord handleErrors:error];
    }
    return nil;
}

+ (NSManagedObject *)coreDataObjectByObjectID:(NSManagedObjectID *)objectID
{
    NSManagedObjectContext *currentContext = [NSManagedObjectContext MR_defaultContext];
    NSError *error = nil;
    NSManagedObject *object = [currentContext existingObjectWithID:objectID error:&error];
    if (error) {
        DDLogError(@"[Core Data] get object by objectID failed!");
    }
    return object;
}

- (void)clearAllCache
{
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        
        //遍历所有缓存索引，找出其中已经过期的
        NSArray *cacheEntries = [_cacheImplementation cacheEntriesInContext:localContext];
        __block NSDate *now = [NSDate date];
        [cacheEntries enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            id<AFCacheEntryProtocol>cacheEntry = obj;
            //检查缓存时间
            if (NSOrderedAscending == [cacheEntry.expireTime compare:now]) {
                //删除对象
                NSArray *coreDataIDs = cacheEntry.objects;
                NSArray *objects = [_cacheImplementation cachedObjectsForCoreDataIDs:coreDataIDs inContext:localContext];
                [localContext MR_deleteObjects:objects];
                //删除缓存索引
                [_cacheImplementation deleteCacheEntry:cacheEntry inContext:localContext];
            }
        }];
    }];
}

- (void)clearInvalidCache{
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        // 遍历所有缓存索引，找出其中已经过期的
        NSArray *cacheEntries = [_cacheImplementation cacheEntriesInContext:localContext];
        __block NSDate *now = [NSDate date];
        [cacheEntries enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            id<AFCacheEntryProtocol> cacheEntry = obj;
            // 检查缓存时间
            if (NSOrderedAscending == [cacheEntry.expireTime compare:now]) {
                // 删除缓存对象
                NSArray *coreDataIDs = cacheEntry.objects;
                NSArray *objects = [_cacheImplementation cachedObjectsForCoreDataIDs:coreDataIDs inContext:localContext];
                [localContext MR_deleteObjects:objects];
                // 删除缓存索引
                [_cacheImplementation deleteCacheEntry:cacheEntry inContext:localContext];
            }
        }];
    }];
    
}

#pragma mark - CoreData Object And ID
+ (id)createNewObjectInClass:(Class)classObject
                   inContext:(NSManagedObjectContext *)context
{
    if (context != nil) {
        return [classObject MR_createEntityInContext:context];
    } else {
        return [classObject MR_createEntity];
    }
}

- (NSArray*)fetchObjectsByOid:(NSString *)oid inClass:(Class)classObject inContext:(NSManagedObjectContext *)context{
    if (oid.length > 0) {
        return [_cacheImplementation cachedObjectForOid:oid inClass:classObject inContext:context];
    }else{
        DDLogWarn(@"[Core Data] normally you should not try to create an object without passing in oid!");
        return nil;
    }
}



@end
