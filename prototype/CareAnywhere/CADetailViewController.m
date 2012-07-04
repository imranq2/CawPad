//
//  CADetailViewController.m
//  CareAnywhere
//
//  Created by Pablo Marcilio on 28/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CADetailViewController.h"
#import "VisitTableViewCell.h"
#import "NursesViewController.h"
#import "JSONViewerViewController.h"
#import "CustomUIStoryboardPopoverSegue.h"
#import "Nurse.h"

@interface CADetailViewController () <UITableViewDelegate, UITableViewDataSource, NursesViewControllerDelegate, UITextFieldDelegate>
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (assign, nonatomic) NSUInteger cellIndexRow;
- (void)configureView;
- (void)hideKeyboard;
@end

@implementation CADetailViewController

@synthesize detailItem = _detailItem;
@synthesize firstnameLabel = _firstnameLabel;
@synthesize lastnameLabel = _lastnameLabel;
@synthesize tableView = _tableView;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize cellIndexRow = _cellIndexRow;
@synthesize popoverController = _popOverController;

@synthesize visits = _visits;
@synthesize toolBar = _toolBar;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        NSError *error;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:newDetailItem options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            NSLog(@"Couldn't deserialize JSON data:\n%@", [[NSString alloc] initWithData:self.detailItem encoding:NSUTF8StringEncoding]);
        }
        _detailItem = jsonObject;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (NSMutableArray *)visits {
    if (![self.detailItem objectForKey:@"visits"]) {
        NSMutableArray *visits = [NSMutableArray array];
        [self.detailItem setObject:visits forKey:@"visits"];
    }
    
    return [self.detailItem objectForKey:@"visits"];
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.firstnameLabel.text = [self.detailItem valueForKey:@"firstname"];
        self.firstnameLabel.tag = 3;
        self.firstnameLabel.delegate = self;
        self.lastnameLabel.text = [self.detailItem valueForKey:@"lastname"];
        self.lastnameLabel.tag = 4;
        self.lastnameLabel.delegate = self;
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidUnload
{
    [self setFirstnameLabel:nil];
    [self setLastnameLabel:nil];
    [self setTableView:nil];
    [self setToolBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"show-nurses"]) {
        [self hideKeyboard];
        NursesViewController *nursesViewController = segue.destinationViewController;
        nursesViewController.managedObjectContext = self.managedObjectContext;
        nursesViewController.delegate = self;
        CustomUIStoryboardPopoverSegue *popoverSegue = (CustomUIStoryboardPopoverSegue *)segue;
        popoverSegue.anchor = sender;
        popoverSegue.directions = UIPopoverArrowDirectionRight;
    } else if ([segue.identifier isEqualToString:@"show-json"]) {
        [self hideKeyboard];
        JSONViewerViewController *viewController = segue.destinationViewController;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.detailItem options:NSJSONWritingPrettyPrinted error:nil];
        viewController.textView.text = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}
#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (IBAction)addVisitButtonTapped {
    // Add a visit
    [self.visits addObject:[NSMutableDictionary dictionary]];

    NSUInteger row = [self.visits count] - 1;
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
}

- (IBAction)editButtonTapped:(id)sender {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

- (IBAction)nurseButtonTapped:(UIButton *)button {
    CGPoint point = [self.tableView convertPoint:button.center fromView:button.superview];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    _cellIndexRow = indexPath.row;

    [self performSegueWithIdentifier:@"show-nurses" sender:button];
}

- (IBAction)saveButtonTapped:(id)sender {
    [self hideKeyboard];
    
    if(![NSJSONSerialization isValidJSONObject:self.detailItem]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Invalid JSON" delegate:nil cancelButtonTitle:@"OOPS..." otherButtonTitles: nil];
        [alertView show];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"save-object" object:self.detailItem];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.visits count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *visitJSONObject = [self.visits objectAtIndex:indexPath.row];
    
    VisitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.inTextField.text = [visitJSONObject valueForKey:@"in_date"];
    cell.inTextField.delegate = self;
    cell.inTextField.tag = 0;
    cell.outTextField.text = [visitJSONObject valueForKey:@"out_date"];
    cell.outTextField.delegate = self;
    cell.outTextField.tag = 1;
    NSDictionary *nurseJSONObject = [visitJSONObject valueForKey:@"nurse"];
    NSString *nurseName;
    if (nurseJSONObject) {
        nurseName = [NSString stringWithFormat:@"%@ %@", [nurseJSONObject valueForKey:@"firstname"], [nurseJSONObject valueForKey:@"lastname"]];
    } else {
        nurseName = @"Select a Nurse"; 
    }
    [cell.nurseButton setTitle:nurseName forState:UIControlStateNormal];
    cell.tag = indexPath.row;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.visits removeObjectAtIndex:indexPath.row];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }   
}


- (void)nursesViewController:(NursesViewController *)nursesViewController selectedNurse:(Nurse *)nurse {
    [self.popoverController dismissPopoverAnimated:YES];
    NSDictionary *visit = [self.visits objectAtIndex:_cellIndexRow]; 
    [visit setValue:[nurse JSONObject] forKey:@"nurse"];
    NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:_cellIndexRow inSection:0]];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 3) {
        [self.detailItem setValue:textField.text forKey:@"firstname"];
    } else if (textField.tag == 4) {
        [self.detailItem setValue:textField.text forKey:@"lastname"];
    } else {
        CGPoint point = [self.tableView convertPoint:textField.center fromView:textField.superview];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
        NSMutableDictionary *visit = [self.visits objectAtIndex:indexPath.row];
        NSString *prop = textField.tag == 0 ? @"in_date" : @"out_date";    
        [visit setObject:textField.text forKey:prop];
    }
}

- (void)hideKeyboard {
    __block void(^resignFirstResonderInViewHeriarchy)(UIView *view) = ^(UIView *view) {
        [view resignFirstResponder];
        for (UIView *subview in view.subviews) {
            resignFirstResonderInViewHeriarchy(subview);
        }
    };
    
    resignFirstResonderInViewHeriarchy(self.view);
}

@end
