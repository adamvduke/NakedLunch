/* */

/*  NakedLunchAppDelegate.m
 *  NakedLunch
 *
 *  Created by Adam Duke on 7/21/11.
 *  Copyright 2011 Adam Duke. All rights reserved.
 *
 */

#import "NakedLunchAppDelegate.h"
#import "RootViewController.h"

@implementation NakedLunchAppDelegate

@synthesize window, navigationController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	/* Override point for customization after application launch. */
	self.navigationController = [[[UINavigationController alloc] init ] autorelease];

	/* Set the navigation controller as the window's root view controller and display. */
	self.window.rootViewController = self.navigationController;

	RootViewController *rootViewController = [[[RootViewController alloc] init] autorelease];
	[self.navigationController pushViewController:rootViewController animated:NO];
	[self.window makeKeyAndVisible];

	return YES;
}

- (void)dealloc
{
	[navigationController release];
	[window release];
	[super dealloc];
}

@end
