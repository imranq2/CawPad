//
//  CustomUIStoryboardPopoverSegue.m
//  CareAnywhere
//
//  Created by Pablo Marcilio on 04/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomUIStoryboardPopoverSegue.h"

@implementation CustomUIStoryboardPopoverSegue 

@synthesize popoverController = _popoverController;
@synthesize anchor = _anchor;
@synthesize directions = _directions;

- (void)perform {
    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.destinationViewController];
    [self.popoverController presentPopoverFromRect:_anchor.frame inView:_anchor.superview permittedArrowDirections:_directions animated:YES];
    [self.sourceViewController setPopoverController:self.popoverController];
    self.popoverController.delegate = self.sourceViewController;
}

@end
