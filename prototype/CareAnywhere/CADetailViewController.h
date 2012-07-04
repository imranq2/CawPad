//
//  CADetailViewController.h
//  CareAnywhere
//
//  Created by Pablo Marcilio on 28/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CADetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UITextField *firstnameLabel;
@property (weak, nonatomic) IBOutlet UITextField *lastnameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (readonly, strong, nonatomic) NSMutableArray *visits;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) UIPopoverController *popoverController;

- (IBAction)addVisitButtonTapped;
- (IBAction)nurseButtonTapped:(UIButton *)sender;
- (IBAction)saveButtonTapped:(id)sender;

@end
