//
//  CShop.m
//  Qshopping
//
//  Created by Josep Oncins on 26/10/12.
//  LGPL Dona'm l'oc. 
//

#import "CShop.h"
#import "Constants.h"

@implementation CShop

@synthesize logoImage;

// Llegir un producte a través del QR
-(BOOL)readFromQR:(NSString *)a_sQR
{
    BOOL btmpTotOk = NO;
    // Sabem que les dades del QR són <URL de la botiga>&<IDBotiga>&<ID producte>
    NSArray *listItems = [a_sQR componentsSeparatedByString:@"&"];
    NSLog(@"Llegint QR: %@", a_sQR);
    if (listItems.count == 3)
    {
        NSString *stmpURL = [listItems objectAtIndex:0];
        NSString *stmpShopID = [listItems objectAtIndex:1];
        NSString *stmpShopURL = [stmpURL stringByAppendingFormat:@"/GetShopDescription.asmx?ID=%@", stmpShopID];
        NSLog(@"Fem la crida a la URL: %@", stmpShopURL);
        
        NSString *tmpURLImage = [NSString stringWithFormat:@"%@/Shop_%@.png", _URL_AZURE_, stmpShopID];
        NSData *tmpData = [NSData dataWithContentsOfURL:[NSURL URLWithString:tmpURLImage]];
        logoImage = [[UIImage imageWithData:tmpData] retain];

        /*
        NSData *tmpImgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:stmpShopURL]];
        shopDescription = [[UIImage alloc] initWithData:tmpImgData];
         */
        btmpTotOk = YES;
    }
    // GESTIO ERRORS
    
    return btmpTotOk;
}

@end
