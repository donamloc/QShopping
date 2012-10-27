//
//  HeaderListCell.h
//  Qshopping
//
//  Created by Josep Oncins on 26/10/12.
//  Copyright (c) 2012 Dona'm l'Oc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderListCell : UITableViewCell
{
    IBOutlet UIImageView *logoImageView;
}

@property (nonatomic,  retain) IBOutlet UIImageView *logoImageView;

-(void)setLogo:(UIImage *)a_image;

@end
