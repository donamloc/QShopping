//
//  CProductList.h
//  Qshopping
//
//  Created by Josep Oncins on 26/10/12.
//  Copyright (c) 2012 Dona'm l'Oc. All rights reserved.
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
