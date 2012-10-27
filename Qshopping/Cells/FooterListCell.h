//
//  FooterListCell.h
//  Qshopping
//
//  Created by Josep Oncins on 26/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FooterListCell : UITableViewCell
{
    IBOutlet UILabel *totalLabel;
}

@property (nonatomic, assign) IBOutlet UILabel *totalLabel;

-(void)setTotal:(NSString*)a_sTotal;

@end
