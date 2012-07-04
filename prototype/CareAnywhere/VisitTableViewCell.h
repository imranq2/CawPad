//
//  VisitTableViewCell.h
//  CareAnywhere
//
//  Created by Pablo Marcilio on 29/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VisitTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField * inTextField;
@property (weak, nonatomic) IBOutlet UITextField * outTextField;
@property (weak, nonatomic) IBOutlet UIButton * nurseButton;

@end
