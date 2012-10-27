//
//  CProduct.m
//  Qshopping
//
//  Created by Josep Oncins on 26/10/12.
//  LGPL Dona'm l'Oc. 
//

#import "CProduct.h"
#import "Constants.h"

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
        NSString *stmpShopID = [listItems objectAtIndex:1];
        NSString *stmpProductID = [listItems objectAtIndex:2];
        NSString *stmpProdURL = [NSString stringWithFormat:@"%@/GetProductInformation.asmx/GetProductDescription?IDShop=%@&ID=%@", _URL_AZURE_, stmpShopID, stmpProductID];
        NSLog(@"Obtenim el producte a la URL: %@", stmpProdURL);
        NSData *tmpProductData = [NSData dataWithContentsOfURL:[NSURL URLWithString:stmpProdURL]];
        NSString *stmpProductData = [[[NSString alloc] initWithData:tmpProductData encoding:NSUTF8StringEncoding] autorelease];

        NSLog(@"JSON Producte amb ID %@: %@", stmpProductID, stmpProductData);
        
        if (tmpProductData != nil)
        {
            ID = [stmpProductID retain];
            quantity = 1;
            
            NSArray *tmpComponents = [stmpProductData componentsSeparatedByString:@"\""];
            NSEnumerator *enumerator = [tmpComponents objectEnumerator];
            NSString *stmpString;
            while (stmpString = (NSString*)[enumerator nextObject]) 
            {
                if ([stmpString compare:@"Description"] == NSOrderedSame)
                {
                    // Avancem l'enumerator dues posicions
                    [enumerator nextObject]; // Els :
                    description = [(NSString*)[enumerator nextObject] retain]; // La descripció
                }
                else if ([stmpString compare:@"Price"] == NSOrderedSame)
                {
                    // Avancem l'enumerator dues posicions
                    [enumerator nextObject]; // Els :
                    price = [(NSString*)[enumerator nextObject] doubleValue]; // El preu
                }
            }
            
            btmpTotOk = YES;
        }
        
    }

    // TEST ERROR

    return btmpTotOk;
}

@end
