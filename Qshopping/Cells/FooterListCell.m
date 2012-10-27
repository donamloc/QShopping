//
//  FooterListCell.m
//  Qshopping
//
//  Created by Josep Oncins on 26/10/12.
//  LGPL Dona'm l'oc. 
//

#import "FooterListCell.h"

@implementation FooterListCell
@synthesize totalLabel, numArticlesLabel, baseLabel, ivaLabel;

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

-(void)setNumArticles:(NSString*)a_sNumArticles
{
    numArticlesLabel.text = a_sNumArticles;
}
-(void)setBase:(NSString*)a_sBase;
{
    baseLabel.text = a_sBase;
}
-(void)setIva:(NSString*)a_sIva;
{
    ivaLabel.text = a_sIva;
}


- (void)dealloc
{
    [super dealloc];
}


@end
