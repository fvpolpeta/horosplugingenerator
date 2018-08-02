//
//  MyFirstHorosPlugin.m
//  MyFirstHorosPlugin
//
//  Created automatically by the Horos Plugin Creator
//  Copyright (c) CURRENT_YEAR YOUR_NAME. All rights reserved.
//

#import "MyFirstHorosPlugin.h"

#import <Horos/PreferencesWindowController.h>
#import <Horos/N2Operators.h>

@interface MyFirstHorosPlugin ()
    
- (void) loopTroughImages;

@end



@implementation MyFirstHorosPlugin

- (void) initPlugin
{

}

- (long) filterImage:(NSString*) menuName
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:@"MyFirstHorosPlugin"];
    [alert setInformativeText:@"Hello from MyFirstHorosPlugin"];
    [alert setAlertStyle:NSWarningAlertStyle];
    
    if ([NSThread isMainThread])
    {
        [alert runModal];
    }
    else
    {
        [alert performSelectorOnMainThread:@selector(runModal) withObject:nil waitUntilDone:YES];
    }
    
    [alert release];
    
    [self loopTroughImages];
    
    return 0; // No Errors
}



// This method demonstrate how to loop through all the images of the current viewer
- (void) loopTroughImages;
{
    // the 'viewerController' variable is defined in PluginFilter.h
    // it is the selected viewer (if more than one is open)
    ViewerController *currentViewer = viewerController;
    
    // loop through time (for dynamic studies)
    for (NSUInteger frame=0; frame<[currentViewer maxMovieIndex]; frame++)
    {
        NSLog(@"Frame : %lu/%lu", frame+1, (NSUInteger)[currentViewer maxMovieIndex]);
        
        // the pixList contains all DCMPix for the current frame
        NSArray *pixList = [currentViewer pixList:frame];
        for (NSUInteger i=0; i<[pixList count]; i++)
        {
            DCMPix *pix = [pixList objectAtIndex:i];
            
            // do something with the DCMPix...
            NSLog(@"Image : %lu/%lu || Location : %f", i+1, [pixList count], pix.sliceLocation);
        }
    }
}

@end
