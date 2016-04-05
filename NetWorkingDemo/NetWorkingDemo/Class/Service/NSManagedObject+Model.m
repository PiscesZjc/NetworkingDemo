//
//  NSManagedObject+Model.m
//  NetWorkingDemo
//
//  Created by zjc on 16/3/17.
//  Copyright © 2016年 zjc. All rights reserved.
//

#import "NSManagedObject+Model.h"

@implementation NSManagedObject (Model)


- (void)save
{
    [self.managedObjectContext MR_saveToPersistentStoreWithCompletion:NULL];
}

+ (id)createModelFromJSONData:(NSDictionary *)json inContext:(NSManagedObjectContext *)context
{
    return nil;
}

- (void)updateModelFromJSONData:(NSDictionary *)json
{
}

#pragma mark - Property Handle

- (void)createAttribute:(NSString *)name data:(id)data
{
    if (data) {
        [self setValue:data forKey:name];
    }
}

- (void)createRelationship:(NSString *)name class:(Class)class data:(id)data
{
    [self createRelationship:name class:class data:data inverse:NO];
}

- (void)createRelationship:(NSString *)name class:(Class)class data:(id)data inverse:(BOOL)inverse
{
    if (data) {
        NSRelationshipDescription *description = [[[self entity] relationshipsByName] objectForKey:name];
        if (![description isToMany]) {
            NSManagedObject *newRelationship = [class createModelFromJSONData:data inContext:self.managedObjectContext];
            [self setValue:newRelationship forKey:name];
            if (inverse) {
                NSRelationshipDescription *inverseRelationship = description.inverseRelationship;
                if (inverseRelationship) {
                    [newRelationship setValue:self forKey:inverseRelationship.name];
                }
            }
        } else {
            if ([description isOrdered]) {
                NSArray *dataArray = data;
                NSMutableOrderedSet *newRelationship = [NSMutableOrderedSet orderedSetWithCapacity:dataArray.count];
                [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    id object = [class createModelFromJSONData:obj inContext:self.managedObjectContext];
                    if (inverse) {
                        NSRelationshipDescription *inverseRelationship = description.inverseRelationship;
                        if (inverseRelationship) {
                            [object setValue:self forKey:inverseRelationship.name];
                        }
                    }
                    [newRelationship addObject:object];
                }];
                [self setValue:[NSOrderedSet orderedSetWithOrderedSet:newRelationship] forKey:name];
            } else {
                NSArray *dataArray = data;
                NSMutableSet *newRelationship = [NSMutableSet setWithCapacity:dataArray.count];
                [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    id object = [class createModelFromJSONData:obj inContext:self.managedObjectContext];
                    if (inverse) {
                        NSRelationshipDescription *inverseRelationship = description.inverseRelationship;
                        if (inverseRelationship) {
                            [object setValue:self forKey:inverseRelationship.name];
                        }
                    }
                    [newRelationship addObject:object];
                }];
                [self setValue:[NSSet setWithSet:newRelationship] forKey:name];
            }
        }
    }
}

- (void)updateAttribute:(NSString *)name data:(id)data
{
    [self updateAttribute:name data:data force:NO];
}

- (void)updateAttribute:(NSString *)name data:(id)data force:(BOOL)force
{
    BOOL shouldUpdate = NO;
    if (data) {
        if (force) {
            shouldUpdate = YES;
        } else {
            id attribute = [self valueForKey:name];
            if (attribute) {
                shouldUpdate = YES;
            }
        }
    }
    if (shouldUpdate) {
        [self setValue:data forKey:name];
    }
}

- (void)updateRelationship:(NSString *)name class:(Class)class data:(id)data
{
    [self updateRelationship:name class:class data:data inverse:NO];
}

- (void)updateRelationship:(NSString *)name class:(Class)class data:(id)data inverse:(BOOL)inverse
{
    [self updateRelationship:name class:class data:data inverse:inverse force:NO];
}

- (void)updateRelationship:(NSString *)name class:(Class)class data:(id)data inverse:(BOOL)inverse force:(BOOL)force
{
    BOOL shouldUpdate = NO;
    id relationship = nil;
    if (data) {
        if (force) {
            shouldUpdate = YES;
        } else {
            relationship = [self valueForKey:name];
            if (relationship) {
                shouldUpdate = YES;
            }
        }
    }
    if (shouldUpdate) {
        NSRelationshipDescription *description = [[[self entity] relationshipsByName] objectForKey:name];
        if (![description isToMany]) {
            // delete
            if (relationship) {
                [relationship MR_deleteEntity];
            }
            // re-create
            NSManagedObject *newRelationship = [class createModelFromJSONData:data inContext:self.managedObjectContext];
            [self setValue:newRelationship forKey:name];
            if (inverse) {
                NSRelationshipDescription *inverseRelationship = description.inverseRelationship;
                if (inverseRelationship) {
                    [newRelationship setValue:self forKey:inverseRelationship.name];
                }
            }
        } else {
            if ([description isOrdered]) {
                // delete
                if (relationship) {
                    [self.managedObjectContext MR_deleteObjects:relationship];
                }
                // re-create
                NSArray *dataArray = data;
                NSMutableOrderedSet *newRelationship = [NSMutableOrderedSet orderedSetWithCapacity:dataArray.count];
                [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    id object = [class createModelFromJSONData:obj inContext:self.managedObjectContext];
                    if (inverse) {
                        NSRelationshipDescription *inverseRelationship = description.inverseRelationship;
                        if (inverseRelationship) {
                            [object setValue:self forKey:inverseRelationship.name];
                        }
                    }
                    [newRelationship addObject:object];
                }];
                [self setValue:[NSOrderedSet orderedSetWithOrderedSet:newRelationship] forKey:name];
            } else {
                // delete
                if (relationship) {
                    [self.managedObjectContext MR_deleteObjects:relationship];
                }
                // re-create
                NSArray *dataArray = data;
                NSMutableSet *newRelationship = [NSMutableSet setWithCapacity:dataArray.count];
                [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    id object = [class createModelFromJSONData:obj inContext:self.managedObjectContext];
                    if (inverse) {
                        NSRelationshipDescription *inverseRelationship = description.inverseRelationship;
                        if (inverseRelationship) {
                            [object setValue:self forKey:inverseRelationship.name];
                        }
                    }
                    [newRelationship addObject:object];
                }];
                [self setValue:[NSSet setWithSet:newRelationship] forKey:name];
            }
        }
    }
}

@end
