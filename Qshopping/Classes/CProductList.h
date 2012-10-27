//
//  CProductList.h
//  Qshopping
//
//  Created by Josep Oncins on 26/10/12.
//  LGPL Dona'm l'Oc. 
//

#import <Foundation/Foundation.h>
#import "CProduct.h"

@interface CProductList : NSObject
{
    // Array de productes
    NSMutableArray *products;
}

@property (nonatomic, retain) NSMutableArray *products;

@end
