//
//  RootViewController.h
//  NakedLunch
//
//  Created by Adam Duke on 7/21/11.
//  Copyright 2011 appRenaissance, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController
{
	NSMutableArray *eateries;
	UIBarButtonItem *addBarButton;
	UIBarButtonItem *shuffleBarButton;

}

@property(nonatomic,retain) NSMutableArray *eateries;
@property (nonatomic, retain) UIBarButtonItem *addBarButton;
@property (nonatomic, retain) UIBarButtonItem *shuffleBarButton;

@end
