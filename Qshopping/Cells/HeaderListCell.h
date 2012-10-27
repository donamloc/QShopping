//
//  HeaderListCell.h
//  Qshopping
//
//  Created by Josep Oncins on 26/10/12.
//  LGPL Dona'm l'Oc. 
//

#import <UIKit/UIKit.h>

@interface HeaderListCell : UITableViewCell
{
    IBOutlet UIImageView *logoImageView;
}

@property (nonatomic,  retain) IBOutlet UIImageView *logoImageView;

-(void)setLogo:(UIImage *)a_image;

@end
