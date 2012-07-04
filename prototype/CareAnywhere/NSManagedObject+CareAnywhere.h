//
//  NSManagedObject+CareAnywhere.h
//  CareAnywhere
//
//  Created by Pablo Marcilio on 29/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSManagedObject (CareAnywhere)

- (NSData *)JSONObject;
- (void)fromJSONObject:(id)jsonObject;
- (void)fromJSONObject:(id)jsonObject withContext:(NSManagedObjectContext *)managedContext;
- (NSDictionary *)recursiveChangedValues;

@end
