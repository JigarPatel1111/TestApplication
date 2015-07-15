//
//  dataHandler.m
//  TestApplication
//
//  Created by SYNC Technologies on 21/03/15.
//  Copyright (c) 2015 SYNC Technologies. All rights reserved.
//

#import "dataHandler.h"

@implementation dataHandler

- (NSMutableArray *) selectDataFromtblCallDetail{
    
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *sourcePath;
    NSString *targetPath = [libraryPath stringByAppendingPathComponent:@"testApplication.sqlite"];
    sourcePath = [libraryPath stringByAppendingPathComponent:@"testApplication.sqlite"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:targetPath]) {
        // database doesn't exist in your library path... copy it from the bundle
        sourcePath = [[NSBundle mainBundle] pathForResource:@"testApplication" ofType:@"sqlite"];
        NSError *error = nil;
        
        
        if (![[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:targetPath error:&error]) {
            NSLog(@"Error: %@", error);
        }
    }
    
    FMDatabase *db = [FMDatabase databaseWithPath:sourcePath];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM tblCallDetail"];
    
    
    NSMutableArray *arrDetail = [NSMutableArray array];
    while ([results next]) {
        NSMutableDictionary *dictTemp = [NSMutableDictionary dictionary];
        
        [dictTemp setObject:[results stringForColumn:@"contactNum"] forKey:@"contactNum"];
        [dictTemp setObject:[results stringForColumn:@"callType"] forKey:@"callType"];
        [dictTemp setObject:[results stringForColumn:@"simNum"] forKey:@"simNum"];
        [dictTemp setObject:[results stringForColumn:@"callTime"] forKey:@"callTime"];
        
        [arrDetail addObject:dictTemp];
    }
    
    return arrDetail;
}
@end
