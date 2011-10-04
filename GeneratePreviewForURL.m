#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>
#import <Cocoa/Cocoa.h>
#import "Functions.h"

/* -----------------------------------------------------------------------------
   Generate a preview for a sqlite file
   ----------------------------------------------------------------------------- */

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options)
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

	CFStringRef fullPath = CFURLCopyFileSystemPath(url, kCFURLPOSIXPathStyle);

    NSArray *tablesArr = [Functions getTables:(NSString *)fullPath];
        
	NSMutableDictionary *props=[[[NSMutableDictionary alloc] init] autorelease];
    [props setObject:@"UTF-8" forKey:(NSString *)kQLPreviewPropertyTextEncodingNameKey];
    [props setObject:@"text/html" forKey:(NSString *)kQLPreviewPropertyMIMETypeKey];
	[props setObject:[NSString stringWithFormat:@"Contents of %@", fullPath] forKey:(NSString *)kQLPreviewPropertyDisplayNameKey];
	    
    NSMutableString *html=[[[NSMutableString alloc] init] autorelease];
    [html appendString:@"<html>"];
    [html appendString:@"<style>"];
    [html appendString:@"body{font-family:Helvetica; font-size:12px}"];
    [html appendString:@"h1{font-size:18px}"];
    [html appendString:@"td{font-size:13px}"];
    [html appendString:@"th{font-size:14px}"];
    [html appendString:@"</style>"];
    
    [html appendString:@"<body bgcolor=white>"];
    
    for (NSString *tableName in tablesArr){
        if (![tableName isEqualToString:@""]){
            
            [html appendString: @"<h1>"];
            [html appendString: tableName];
            [html appendString: @"</h1>"];
            
            NSString *tableHTML = [Functions queryForDatabase:(NSString *)fullPath andTable:tableName];
            
            if (![tableHTML isEqualToString:@""]){    
                [html appendString: @"<table border=1 cellspacing=0 cellpadding=5>"];
                [html appendString:tableHTML];
                [html appendString: @"</table>"];
            } else {
                [html appendString: @"<p>No records found</p>"];
            }            
        }
    }
    
	[html appendString:@"</body></html>"];
	
	QLPreviewRequestSetDataRepresentation(preview,(CFDataRef)[html dataUsingEncoding:NSUTF8StringEncoding],kUTTypeHTML,(CFDictionaryRef)props);
	
    [pool release];
    return noErr;

}

void CancelPreviewGeneration(void* thisInterface, QLPreviewRequestRef preview)
{
    // implement only if supported
}
