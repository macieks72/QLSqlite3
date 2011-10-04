//
//  Functions.m
//  QLSqlite3
//
//  Created by Maciej Szymanski on 11-10-04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Functions.h"


@implementation Functions

+ (NSArray *) getTables:(NSString*) path
{    
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/usr/bin/sqlite3"];
	
    NSArray *arguments;
    
	arguments = [NSArray arrayWithObjects: path, @"SELECT name FROM sqlite_master WHERE type='table'",  nil];	
    
    [task setArguments: arguments];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
        
    [task launch];
	
    NSData *data;
    data = [file readDataToEndOfFile];
    
	[task waitUntilExit];
    
    NSString *retStr = [[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] autorelease];
    
    [task release];
    
    return [retStr componentsSeparatedByString:@"\n"];
}

///////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *) queryForDatabase:(NSString*)path andTable:(NSString*)tableName
{   
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@", tableName];

    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/usr/bin/sqlite3"];
	
    NSArray *arguments;
    
	arguments = [NSArray arrayWithObjects: @"-header", @"-html", path, query,  nil];	
    
    [task setArguments: arguments];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    [task launch];
	
    NSData *data;
    data = [file readDataToEndOfFile];
    
	[task waitUntilExit];
    
    NSString *retStr = [[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] autorelease];
    
    [task release];
    
    return retStr;
}


@end
