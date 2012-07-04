//
//  NursesViewController.m
//  CareAnywhere
//
//  Created by Pablo Marcilio on 29/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NursesViewController.h"
#import "Nurse.h"

@implementation NursesViewController

@synthesize nurses = _nurses;
@synthesize selectedNurseID;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize delegate = _delegate;

- (NSArray *)nurses {
    if (!_nurses) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Nurse"];
        fetchRequest.sortDescriptors = [NSArray arrayWithObjects:
                                        [NSSortDescriptor sortDescriptorWithKey:@"lastname" ascending:YES],
                                        [NSSortDescriptor sortDescriptorWithKey:@"firstname" ascending:YES], nil];
        NSError *error = nil;
        _nurses = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }
    
    return _nurses;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Nurse *nurse = [self.nurses objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", nurse.firstname, nurse.lastname];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.nurses count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    Nurse *nurse = [self.nurses objectAtIndex:indexPath.row];
    if ([[[nurse.objectID URIRepresentation] absoluteString] isEqualToString:self.selectedNurseID]) {
        cell.selected = YES;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Nurse *nurse = [self.nurses objectAtIndex:indexPath.row];
    [self.delegate nursesViewController:self selectedNurse:nurse];
}

@end
