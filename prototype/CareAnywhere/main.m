//
//  main.m
//  CareAnywhere
//
//  Created by Pablo Marcilio on 28/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CAAppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        @try {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([CAAppDelegate class]));
        }
        @catch (NSException *exception) {
            NSLog(@"%@", [exception description]);
        }
    }
    return 1;
}
