//
//  NSManagedObject+CareAnywhere.m
//  CareAnywhere
//
//  Created by Pablo Marcilio on 29/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSManagedObject+CareAnywhere.h"

@implementation NSManagedObject (CareAnywhere)

- (NSDictionary *)JSONObject {
    NSMutableDictionary *JSONObject = [NSMutableDictionary dictionary];
    
    for (NSString *attribute in [[self entity] attributesByName]) {
        [JSONObject setValue:[self valueForKey:attribute] forKey:attribute];
    }
    
    for (NSString *relationship in [[self entity] relationshipsByName]) {
        if ([[[[self entity] relationshipsByName] objectForKey:relationship] isToMany]) {
            NSMutableArray *relatedJSONObjects = [NSMutableArray array];
            for (NSManagedObject *relatedObject in [self valueForKey:relationship]) {
                [relatedJSONObjects addObject:[relatedObject JSONObject]];
            }
            if ([relatedJSONObjects count] > 0) {
                [JSONObject setValue:relatedJSONObjects forKey:relationship];
            }
        } else {
            if ([self valueForKey:relationship]) {
                [JSONObject setValue:[[self valueForKey:relationship] JSONObject] forKey:relationship];   
            }
        }
    }
    
    [JSONObject setValue:[[[self objectID] URIRepresentation] absoluteString] forKey:@"id"];
    
    return JSONObject;
}

- (void)fromJSONObject:(id)jsonObject {
    [self fromJSONObject:jsonObject withContext:self.managedObjectContext];
}

- (void)fromJSONObject:(id)jsonObject withContext:(NSManagedObjectContext *)managedObjectContext {
    NSMutableDictionary *values = [NSMutableDictionary dictionary];
    
    for (NSString *property in jsonObject) {
        if ([[self.entity relationshipsByName] objectForKey:property]) {
            // Handle relationship
            NSRelationshipDescription *relationshipDescription = [[self.entity relationshipsByName] objectForKey:property];
            
            if (relationshipDescription.isToMany) {
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *relatedObjectDictionary in [jsonObject valueForKey:property]) {
                    NSManagedObject *relatedManagedObject;
                    if ([relatedObjectDictionary valueForKey:@"id"]) {
                        NSURL *manageObjectIDURI = [NSURL URLWithString:[relatedObjectDictionary valueForKey:@"id"]];
                        NSManagedObjectID *managedObjectID =  [managedObjectContext.persistentStoreCoordinator managedObjectIDForURIRepresentation:manageObjectIDURI];
                        relatedManagedObject = [managedObjectContext objectWithID:managedObjectID];
                    } else {
                        NSString *entityName = [[relationshipDescription destinationEntity] name];
                        relatedManagedObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:managedObjectContext];
                    }
                    [relatedManagedObject fromJSONObject:relatedObjectDictionary];
                    [array addObject:relatedManagedObject];
                }
                NSMutableSet *set = [self mutableSetValueForKey:property];
                [set removeAllObjects];
                [set addObjectsFromArray:array];
            } else {
                NSManagedObject *relatedManagedObject;
                NSDictionary *relatedObjectDictionary = [jsonObject valueForKey:property];
                
                if ([relatedObjectDictionary valueForKey:@"id"]) {
                    NSURL *manageObjectIDURI = [NSURL URLWithString:[relatedObjectDictionary valueForKey:@"id"]];
                    NSManagedObjectID *managedObjectID =  [managedObjectContext.persistentStoreCoordinator managedObjectIDForURIRepresentation:manageObjectIDURI];
                    relatedManagedObject = [managedObjectContext objectWithID:managedObjectID];
                } else {
                    NSString *entityName = [[relationshipDescription destinationEntity] name];
                    relatedManagedObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:managedObjectContext];
                }
                [relatedManagedObject fromJSONObject:[jsonObject valueForKey:property]];
                [self setValue:relatedManagedObject forKey:property];
            }
        } else if ([[self.entity attributesByName] objectForKey:property]) {
            // Handle attribute
            [values setObject:[jsonObject objectForKey:property] forKey:property];
        }
    }
    
    [self setValuesForKeysWithDictionary:values];
}

- (NSDictionary *)recursiveChangedValues {
    NSMutableDictionary *changes = [NSMutableDictionary dictionary];
    [changes setValuesForKeysWithDictionary:[self changedValues]];
    
    if (self.objectID.isTemporaryID) {
        // It's a new object
        for (NSString *attributeName in [[self entity] attributesByName]) {
            if ([self valueForKey:attributeName]) {
                [changes setValue:[self valueForKey:attributeName] forKey:attributeName];
            }
        }
    }
    
    for (NSString *relationshipName in [[self entity] relationshipsByName]) {
        if (![self valueForKey:relationshipName]) {
            continue;
        }
        
        NSRelationshipDescription *relationshipDescription = [[[self entity] relationshipsByName] objectForKey:relationshipName];
        if (relationshipDescription.isToMany) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSManagedObject *managedObject in [self valueForKey:relationshipName]) {
                [array addObject:[managedObject recursiveChangedValues]];
            }
            [changes setObject:[NSArray arrayWithArray:array] forKey:relationshipName];
        } else {
            [changes setObject:[[self valueForKey:relationshipName] recursiveChangedValues] forKey:relationshipName];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:changes];
}

@end
