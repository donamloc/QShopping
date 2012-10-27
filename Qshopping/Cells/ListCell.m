//
//  ListCell.m
//  Qshopping
//
//  Created by Josep Oncins on 26/10/12.
//  Copyright (c) 2012 Dona'm l'Oc. All rights reserved.
//

#import "ListCell.h"

@implementation ListCell
@synthesize quantityLabel, descriptionLabel, totalLabel, deleteButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) 
    {
        // Initialization code
    }
    return self;
}

-(void)setQuantity:(NSInteger)a_iQuantity
{
    quantityLabel.text = [NSString stringWithFormat:@"%d", a_iQuantity];
}

-(void)setDescription:(NSString*)a_sDescription
{
    descriptionLabel.text = a_sDescription;
}

-(void)setTotal:(double)a_price quantity:(NSInteger)a_iQuantity
{
    double dtmpTotal = a_price * a_iQuantity;
    totalLabel.text = [NSString stringWithFormat:@"%.2f x %ld = %.2f", a_price, a_iQuantity, dtmpTotal];
}

- (void)dealloc
{
    [super dealloc];
}

@end
