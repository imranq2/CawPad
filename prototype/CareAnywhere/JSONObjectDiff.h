//
//  JSONObjectDiff.h
//  CareAnywhere
//
//  Created by Pablo Marcilio on 03/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DiffNode;

@interface JSONObjectDiff : NSObject

+ (DiffNode *)diffJSONObject:(id)leftJSONObject against:(id)rightJSONObject;

@end
