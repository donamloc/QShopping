//
//  ListCell.h
//  Qshopping
//
//  Created by Josep Oncins on 26/10/12.
//  Copyright (c) 2012 Dona'm l'Oc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCell : UITableViewCell
{
    IBOutlet UILabel *quantityLabel;
    IBOutlet UILabel *descriptionLabel;
    IBOutlet UILabel *totalLabel;
    IBOutlet UIButton *deleteButton;
}

@property (nonatomic, assign) IBOutlet UILabel *quantityLabel;
@property (nonatomic, assign) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, assign) IBOutlet UILabel *totalLabel;
@property (nonatomic, assign) IBOutlet UIButton *deleteButton;

-(void)setQuantity:(NSInteger)a_iQuantity;
-(void)setDescription:(NSString*)a_sDescription;
-(void)setTotal:(double)a_price quantity:(NSInteger)a_iQuantity;

@end
