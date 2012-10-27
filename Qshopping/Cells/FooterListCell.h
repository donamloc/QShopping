//
//  FooterListCell.h
//  Qshopping
//
//  Created by Josep Oncins on 26/10/12.
//  LGPL Dona'm l'oc. 
//

#import <UIKit/UIKit.h>

@interface FooterListCell : UITableViewCell
{
    IBOutlet UILabel *totalLabel;
    IBOutlet UILabel *numArticlesLabel;
    IBOutlet UILabel *baseLabel;
    IBOutlet UILabel *ivaLabel;
}

@property (nonatomic, assign) IBOutlet UILabel *totalLabel;
@property (nonatomic, assign) IBOutlet UILabel *numArticlesLabel;
@property (nonatomic, assign) IBOutlet UILabel *baseLabel;
@property (nonatomic, assign) IBOutlet UILabel *ivaLabel;

-(void)setTotal:(NSString*)a_sTotal;
-(void)setNumArticles:(NSString*)a_sNumArticles;
-(void)setBase:(NSString*)a_sBase;
-(void)setIva:(NSString*)a_sIva;

@end
