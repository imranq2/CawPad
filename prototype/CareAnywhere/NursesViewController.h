//
//  NursesViewController.h
//  CareAnywhere
//
//  Created by Pablo Marcilio on 29/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NursesViewControllerDelegate;

@interface NursesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *nurses;
@property (strong, nonatomic) id selectedNurseID;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) id<NursesViewControllerDelegate> delegate;

@end


@class Nurse;
@protocol NursesViewControllerDelegate <NSObject>

- (void)nursesViewController:(NursesViewController *)nursesViewController selectedNurse:(Nurse *)nurse;

@end