//
//  CustomUIStoryboardPopoverSegue.h
//  CareAnywhere
//
//  Created by Pablo Marcilio on 04/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomUIStoryboardPopoverSegue : UIStoryboardSegue

@property (strong, nonatomic) UIPopoverController *popoverController;
@property (weak, nonatomic) UIView *anchor;
@property (assign, nonatomic) UIPopoverArrowDirection directions;

@end
