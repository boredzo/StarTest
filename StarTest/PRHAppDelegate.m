//
//  PRHAppDelegate.m
//  StarTest
//
//  Created by Peter Hosey on 2012-06-02.
//

#import "PRHAppDelegate.h"

#import "PRHStarWindowController.h"

@implementation PRHAppDelegate
{
	PRHStarWindowController *starWC;
}

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
	starWC = [PRHStarWindowController new];
	NSLog(@"Showing %@", starWC);
	[starWC showWindow:nil];
}
- (void)applicationWillTerminate:(NSNotification *)notification {
	[starWC close];
	starWC = nil;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	return YES;
}

@end
