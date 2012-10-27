//
//  FooterListCell.m
//  Qshopping
//
//  Created by Josep Oncins on 26/10/12.
//  LGPL Dona'm l'oc. 
//

#import "FooterListCell.h"

@implementation FooterListCell
@synthesize totalLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) 
    {
        // Initialization code
    }
    return self;
}

-(void)setTotal:(NSString*)a_sTotal
{
    totalLabel.text = a_sTotal;
}

- (void)dealloc
{
    [super dealloc];
}


@end
