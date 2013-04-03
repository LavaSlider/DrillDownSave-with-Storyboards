//
//  AppDelegate.h
//  DDS-Storyboard
//
//  Created by David W. Stockton on 4/2/13.
//

#import <UIKit/UIKit.h>

extern NSString *kRestoreLocationKey; //preference key to obtain our restore location

extern NSString *kItemTitleKey;		// dictionary key for obtaining the item's title to display in each cell
extern NSString *kChildrenKey;		// dictionary key for obtaining the item's children
extern NSString *kCellIdentifier;	// the table view's cell identifier

extern NSString *kNextLevelSegueIdentifier; // the segue identifier from the storyboard

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSDictionary *outlineData;
@property (nonatomic, retain) NSMutableArray *savedLocation;

@end
