//
//  CShop.h
//  Qshopping
//
//  Created by Josep Oncins on 26/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CShop : NSObject
{
    // El ID del producte és un long
    long ID;
    // Imatge amb la descripció de la botiga
    UIImage *logoImage;
}

@property (nonatomic, retain) UIImage *logoImage;

// Llegir la imatge de la botiga a través del QR
-(BOOL)readFromQR:(NSString *)a_sQR;

@end
