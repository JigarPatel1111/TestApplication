//
//  dataHandler.h
//  TestApplication
//
//  Created by SYNC Technologies on 21/03/15.
//  Copyright (c) 2015 SYNC Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface dataHandler : NSObject

// select methods

- (NSMutableArray *) selectDataFromtblCallDetail;
@end
