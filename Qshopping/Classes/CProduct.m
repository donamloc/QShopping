//
//  CProduct.m
//  Qshopping
//
//  Created by Josep Oncins on 26/10/12.
//  Copyright (c) 2012 Dona'm l'Oc. All rights reserved.
//

#import "CProduct.h"

@implementation CProduct

@synthesize ID, description, quantity, price;

// Funcions d'entrada/sortida
// Llegir producte a partir d'un string JSON
// { ID : <STRING>,
//   Quantity: <INT>,
//   Description : <STRING>,
//   Price : <DOUBLE> 
// }
-(BOOL)readFromJSON:(NSString *)a_sJSON
{
    ID = @"";
    quantity = 0;
    description = @"";
    price = 0.0;
    return YES;
}

// Obtenir el JSON del producte
// { ID : <STRING>,
//   Quantity: <INT>,
//   Description : <STRING>,
//   Price : <DOUBLE> 
// }
-(NSString*)getAsJSON
{
    NSString *stmpRes = [NSString stringWithFormat:@"{ ID : %@, Quantity: %@, Description: %@, Price: %@ }", ID, quantity, description, price];
    return stmpRes;
}

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
        NSString *stmpProductID = [listItems objectAtIndex:2];
        NSString *stmpProdURL = [stmpURL stringByAppendingFormat:@"/GetProductInformation.asmx?IDShop=%@&ID=%@", stmpShopID, stmpProductID];
        NSLog(@"Obtenim el producte a la URL: %@", stmpProdURL);
        NSString *stmpProductData = [NSString stringWithContentsOfURL:[NSURL URLWithString:stmpProdURL] encoding:NSASCIIStringEncoding error:NULL];
        NSLog(@"JSON Producte amb ID %@: %@", stmpProductID, stmpProductData);
        
        // FAKE
        ID = @"1";
        quantity = 1;
        description = @"Descripció producte";
        price = 25.50;
        
        btmpTotOk = YES;
    }

    // TEST ERROR

    return btmpTotOk;
}

@end
