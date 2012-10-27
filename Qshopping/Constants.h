//
//  Constants.h
//  Qshopping
//
//  Created by Josep Oncins on 26/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Qshopping_Constants_h
#define Qshopping_Constants_h

#define _BASE_API_URL_ @"http://finappsapi.bdigital.org/api/2012/2aad2e4b85"
#define _LOGIN_ @"access/login"
#define _GET_CARD_LIST_ @"operations/card/list"
#define _GET_CARD_INFO_ @"operations/card/%@/status"
#define _EXECUTE_PAYMENT_ @"operations/payment/%@/code?value=%.2f"
#define _QUERY_PAYMENT_ @"operations/payment/%@/status"
#define _EXECUTE_COMMERCE_PAYMENT_ @"operations/payment/%@/exec"
#define _GET_ACCOUNTS_LIST_ @"operations/account/list"

#endif
