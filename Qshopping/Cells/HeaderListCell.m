//
//  HeaderListCell.m
//  Qshopping
//
//  Created by Josep Oncins on 26/10/12.
//  Copyright (c) 2012 Dona'm l'Oc. All rights reserved.
//

#import "HeaderListCell.h"

@implementation HeaderListCell

@synthesize logoImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) 
    {
        // Initialization code
    }
    return self;
}

-(void)setLogo:(UIImage *)a_image
{
    logoImageView.image = a_image;
}

- (void)dealloc
{
    [super dealloc];
}

@end
