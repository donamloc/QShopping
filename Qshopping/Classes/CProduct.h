//
//  CProduct.h
//  Qshopping
//
//  Created by Josep Oncins on 26/10/12.
//  LGPL Dona'm l'Oc. 
//
// Classe principal del producte

#import <Foundation/Foundation.h>

@interface CProduct : NSObject
{
    // El ID del producte és un string, pq dependrà molt de la botiga com
    // voldrà identificar els seus productes
    NSString* ID;
    // Quantitat a comprar/comprada del producte
    int quantity;
    NSString *description;
    double price;
}

@property (nonatomic, retain) NSString *ID;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, assign) int quantity;
@property (nonatomic, assign) double price;

// Funcions bàsiques d'accès
// La transcripció a JSON del producte serà
// { ID : <STRING>,
//   Quantity: <INT>,
//   Description : <STRING>,
//   Price : <DOUBLE> 
// }
// Llegir producte a partir d'un string JSON
-(BOOL)readFromJSON:(NSString *)a_sJSON;
// Obtenir el JSON del producte
-(NSString*)getAsJSON;
// El producte a través del QR es veurà com text a on s'hi posaràn tres
// camps separats per &: <URL Base>&<ID Botiga>&<ID Product>
// Llegir un producte a través del QR
// Això implicarà un crida a la URL per a obtenir la descripció del prioducte
-(BOOL)readFromQR:(NSString *)a_sQR;
@end
