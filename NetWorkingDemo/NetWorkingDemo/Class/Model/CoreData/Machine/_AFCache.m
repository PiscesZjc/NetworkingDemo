// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AFCache.m instead.

#import "_AFCache.h"

const struct AFCacheAttributes AFCacheAttributes = {
	.expireTime = @"expireTime",
	.isSingleObject = @"isSingleObject",
	.key = @"key",
	.objectClassName = @"objectClassName",
	.objects = @"objects",
};

const struct AFCacheRelationships AFCacheRelationships = {
};

const struct AFCacheFetchedProperties AFCacheFetchedProperties = {
};

@implementation AFCacheID
@end

@implementation _AFCache

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Cache" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Cache";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Cache" inManagedObjectContext:moc_];
}

- (AFCacheID*)objectID {
	return (AFCacheID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"isSingleObjectValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isSingleObject"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic expireTime;






@dynamic isSingleObject;



- (BOOL)isSingleObjectValue {
	NSNumber *result = [self isSingleObject];
	return [result boolValue];
}

- (void)setIsSingleObjectValue:(BOOL)value_ {
	[self setIsSingleObject:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsSingleObjectValue {
	NSNumber *result = [self primitiveIsSingleObject];
	return [result boolValue];
}

- (void)setPrimitiveIsSingleObjectValue:(BOOL)value_ {
	[self setPrimitiveIsSingleObject:[NSNumber numberWithBool:value_]];
}





@dynamic key;






@dynamic objectClassName;






@dynamic objects;











@end
