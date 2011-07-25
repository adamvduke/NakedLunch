//
//  NLListViewController.m
//  NakedLunch
//
//  Created by Adam Duke on 7/24/11.
//  Copyright 2011 appRenaissance, LLC. All rights reserved.
//

#import "NLListViewController.h"
#include <stdlib.h>

#define foo4random() ( arc4random() % ( (unsigned)RAND_MAX + 1 ) )
#define kEateriesKey @"savedeateries"

/* adding these private methods to the UIAlertView API to avoid
 * compiler warning about possibly not responding to the selector
 */

/* FIXME: Write your own UIAlertView that has these methods */
@interface UIAlertView ()
- (id)addTextFieldWithValue:(id)arg1 label:(id)arg2;
- (id)textFieldAtIndex:(int)arg1;
@end

@interface NLListViewController ()
- (void)shuffle;
- (void)addEatery;
- (void)saveEateries;
- (NSArray *)retrieveEateries;
static BOOL accelerationIsShaking(UIAcceleration *last, UIAcceleration *current, double threshold);
@end

@implementation NLListViewController

@synthesize eateries, addBarButton, shuffleBarButton, lastAcceleration;

#pragma mark -
#pragma mark View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
		self.eateries = [[[self retrieveEateries] mutableCopy] autorelease];
		if(!self.eateries)
		{
			self.eateries = [[[NSMutableArray alloc] init] autorelease];
			[self.eateries addObject:@"Pho Cali"];
			[self.eateries addObject:@"Kyhber"];
			[self.eateries addObject:@"National Mechanics"];
			[self.eateries addObject:@"Sassafras Market"];
			[self.eateries addObject:@"Race Street Cafe"];
			[self.eateries addObject:@"Cafe Ole"];
			[self.eateries addObject:@"Kingdom of Vegetarians"];
			[self.eateries addObject:@"A Full Plate"];
			[self.eateries addObject:@"PYT"];
			[self.eateries addObject:@"Gunner's Run"];
			[self.eateries addObject:@"El Vez"];
			[self.eateries addObject:@"Singapore"];
			[self saveEateries];
		}
	}
	return self;
}

- (void)saveEateries
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:self.eateries forKey:kEateriesKey];
	[defaults synchronize];
}

- (NSArray *)retrieveEateries
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults objectForKey:kEateriesKey];
}

/* Ensures the shake is strong enough on at least two axes before declaring it a shake.
 * "Strong enough" means "greater than a client-supplied threshold" in G's.
 */
static BOOL accelerationIsShaking(UIAcceleration *last, UIAcceleration *current, double threshold)
{
	double
	deltaX = fabs(last.x - current.x),
	deltaY = fabs(last.y - current.y),
	deltaZ = fabs(last.z - current.z);
	
	return (deltaX > threshold && deltaY > threshold) ||
	(deltaX > threshold && deltaZ > threshold) ||
	(deltaY > threshold && deltaZ > threshold);
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	if(self.lastAcceleration)
	{
		if( !histeresisExcited && accelerationIsShaking(self.lastAcceleration, acceleration, 0.7) )
		{
			histeresisExcited = YES;
			[self shuffle];
		}
		else
			if( histeresisExcited && !accelerationIsShaking(self.lastAcceleration, acceleration, 0.2) )
			{
				histeresisExcited = NO;
			}
	}
	
	self.lastAcceleration = acceleration;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[UIAccelerometer sharedAccelerometer].delegate = self;
	
	/* Uncomment the following line to display an Edit button in the navigation bar for this
	 * view controller. */
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	UIBarButtonItem *leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Shuffle"
	                                                                       style:UIBarButtonItemStylePlain
	                                                                      target:self
	                                                                      action:@selector(shuffle)] autorelease];
	self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)shuffle
{
	int rowNumber = foo4random() % [self.eateries count];
	
	NSString *message = [NSString stringWithFormat:@"You're eating at %@", [self.eateries objectAtIndex:rowNumber]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!"
	                                                message:message
	                                               delegate:self
	                                      cancelButtonTitle:@"OK"
	                                      otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)addEatery
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Eatery"
	                                                message:@"Indicate what eatery you would like to add."
	                                               delegate:self
	                                      cancelButtonTitle:@"Cancel"
	                                      otherButtonTitles:@"OK", nil];
	[alert addTextFieldWithValue:@"" label:@"New eatery name"];
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	UITextField *textField = [alertView textFieldAtIndex:0];
	NSString *eateryName = textField.text;
	if(eateryName)
	{
		[self.eateries addObject:eateryName];
		[self saveEateries];
		[self.tableView reloadData];
	}
}

#pragma mark -
#pragma mark Table view data source

/* Customize the number of sections in the table view. */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

/* Customize the number of rows in the table view. */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.eateries count];
}

/* Customize the appearance of table view cells. */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	NSString *text = [self.eateries objectAtIndex:indexPath.row];
	cell.textLabel.text = text;
	return cell;
}

#pragma mark -
#pragma mark List Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];
	[self.tableView setEditing:editing animated:YES];
	if(editing)
	{
		if(!self.addBarButton)
		{
			UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
			                                                                           target:self
			                                                                           action:@selector(addEatery)];
			self.addBarButton = addButton;
			[addButton release];
		}
		
		/* hold onto the current left bar button (compose) so it can
		 * be put back after editing
		 */
		self.shuffleBarButton = self.navigationItem.leftBarButtonItem;
		
		/* set the right bar button to the add bar button */
		self.navigationItem.leftBarButtonItem = self.addBarButton;
	}
	else
	{
		/* set the right bar button to the compose bar button */
		self.navigationItem.leftBarButtonItem = self.shuffleBarButton;
	}
}

/* Override to support conditional editing of the table view. */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

/* Override to support editing the table view. */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(editingStyle == UITableViewCellEditingStyleDelete)
	{
		/* Delete the row from the data source. */
		[self.eateries removeObjectAtIndex:indexPath.row];
		[self saveEateries];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning
{
	/* Releases the view if it doesn't have a superview. */
	[super didReceiveMemoryWarning];
}

- (void)dealloc
{
	[super dealloc];
	[addBarButton release];
	[shuffleBarButton release];
	[eateries release];
	[lastAcceleration release];
	addBarButton = nil;
	eateries = nil;
	eateries = nil;
	lastAcceleration = nil;
}

@end
