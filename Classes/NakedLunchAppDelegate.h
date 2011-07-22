//
//  NakedLunchAppDelegate.h
//  NakedLunch
//
//  Created by Adam Duke on 7/21/11.
//  Copyright 2011 appRenaissance, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NakedLunchAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

