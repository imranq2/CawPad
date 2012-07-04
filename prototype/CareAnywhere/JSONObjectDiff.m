//
//  JSONObjectDiff.m
//  CareAnywhere
//
//  Created by Pablo Marcilio on 03/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSONObjectDiff.h"
#import "DiffNode.h"

@implementation JSONObjectDiff

+ (DiffNode *)diffJSONObject:(id)leftJSONObject against:(id)rightJSONObject {
    DiffNode *diffNode = [[DiffNode alloc] init];
    diffNode.leftJSONObject = leftJSONObject;
    diffNode.rightJSONObject = rightJSONObject;
    
    if (leftJSONObject && !rightJSONObject) {
        diffNode.type = JSONDiffNodeRemoved;
        return diffNode;
    } else if (!leftJSONObject && rightJSONObject) {
        diffNode.type = JSONDiffNodeAdded;
    } else {
        NSMutableArray *changedProperties = [NSMutableArray array];
        NSMutableArray *children = [NSMutableArray array];
        
        for (NSString *property in leftJSONObject) {
            id leftValue = [leftJSONObject valueForKey:property];
            id rightValue = [rightJSONObject valueForKey:property];
            
            if ([NSJSONSerialization isValidJSONObject:leftJSONObject] || 
                [NSJSONSerialization isValidJSONObject:rightJSONObject]) 
            {
                // Left or Right may be another object or an array
                if ([leftValue isKindOfClass:[NSArray class]] ||
                    [rightValue isKindOfClass:[NSArray class]]) 
                {
/*
                    for (id value in leftValue) {
                        if (<#condition#>) {
                            <#statements#>
                        }
                    }
*/
                } else {
                    [children addObject:[self diffJSONObject:leftValue against:rightValue]];
                }
            } else {
                if (![[leftJSONObject valueForKey:property] isEqual:[rightJSONObject valueForKey:property]]) {
                    [changedProperties addObject:property];
                }
            }
        }
        
        if ([changedProperties count] > 0) {
            diffNode.changedProperties = [NSArray arrayWithArray:changedProperties];
        }
        if ([children count] > 0) {
            diffNode.children = [NSArray arrayWithArray:children];
        }
        diffNode.type = [diffNode.changedProperties count] == 0 ? JSONDiffNodeNoChange : JSONDiffNodeModified;    
    }
    
    return diffNode;
}

@end
