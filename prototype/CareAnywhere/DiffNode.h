//
//  DiffNode.h
//  CareAnywhere
//
//  Created by Pablo Marcilio on 03/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    JSONDiffNodeNoChange,
    JSONDiffNodeModified,
    JSONDiffNodeRemoved,
    JSONDiffNodeAdded
}JSONDiffNodeType;

@interface DiffNode : NSObject 

@property (strong, nonatomic) NSDictionary *leftJSONObject;
@property (strong, nonatomic) NSDictionary *rightJSONObject;
@property (assign, nonatomic) JSONDiffNodeType type;
@property (strong, nonatomic) NSArray *changedProperties;
@property (strong, nonatomic) NSArray *children;

@end
