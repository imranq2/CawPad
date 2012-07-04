//
//  Visit.h
//  CareAnywhere
//
//  Created by Pablo Marcilio on 29/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Nurse;

@interface Visit : NSManagedObject

@property (nonatomic, retain) NSDate * in_date;
@property (nonatomic, retain) NSDate * out_date;
@property (nonatomic, retain) Nurse *nurse;

@end
