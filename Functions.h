//
//  Functions.h
//  QLSqlite3
//
//  Created by Maciej Szymanski on 11-10-04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Functions : NSObject {

    
}

+ (NSArray *) getTables:(NSString*) path;
+ (NSString *) queryForDatabase:(NSString*)path andTable:(NSString*)tableName;

@end
