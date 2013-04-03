//
//  AppDelegate.m
//  DDS-Storyboard
//
//  Created by David W. Stockton on 4/2/13.
//

#import "AppDelegate.h"
#import "Level1ViewController.h"

NSString *kRestoreLocationKey	= @"RestoreLocation";	// preference key to obtain our restore location

NSString *kItemTitleKey		= @"itemTitle";		// dictionary key for obtaining the item's title to display in each cell
NSString *kChildrenKey		= @"itemChildren";	// dictionary key for obtaining the item's children
NSString *kCellIdentifier	= @"MyIdentifier";	// the table view's cell identifier

NSString *kNextLevelSegueIdentifier = @"NextLevel";	// the segue identifier from the storyboard


@implementation AppDelegate

@synthesize window = _window;
@synthesize outlineData = _outlineData;
@synthesize savedLocation = _savedLocation;

- (id)init
{
	self = [super init];
	if (self)
	{
		// load the drill-down list content from the plist filem
		// this plist contains the outline mapping each level of the list hierarchy
		//
		NSString *path = [[NSBundle mainBundle] bundlePath];
		NSString *finalPath = [path stringByAppendingPathComponent:@"outline.plist"];
		self.outlineData = [NSDictionary dictionaryWithContentsOfFile:finalPath];
	}
	return self;
}

- (void)dealloc
{
	[_window release];
	[_outlineData release];
	[_savedLocation release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

	// after removing (renaming the key for) the UIMainStoryboardFile in the
	// info.plist file I need to take over the responsibility for loading it here
	// first get the storyboard from the main bundle
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName: [[NSBundle mainBundle] objectForInfoDictionaryKey: @"UIMainStoryboardFile-customLoad"] bundle: nil];
	// then get the initial view controller from it, this is set to be the navigation controller
	id initialViewController = [storyboard instantiateInitialViewController];

	// set the data model for the level one view controller from the outline data
	// fetch the top level items in our outline (level 1)
	NSArray *topLevel1Content = [self.outlineData objectForKey:kChildrenKey];
	Level1ViewController *l1vc = (Level1ViewController *) [initialViewController topViewController];
	l1vc.listContent = topLevel1Content;

	// load the stored preference of the user's last location from a previous launch
	NSMutableArray *tempMutableCopy = [[[NSUserDefaults standardUserDefaults] objectForKey:kRestoreLocationKey] mutableCopy];
	self.savedLocation = tempMutableCopy;
	[tempMutableCopy release];
	if (self.savedLocation == nil)
	{
		// user has not launched this app nor navigated to a particular level yet, start at level 1, with no selection
		self.savedLocation = [NSMutableArray arrayWithObjects:
				  [NSNumber numberWithInteger:-1],	// item selection at 1st level (-1 = no selection)
				  [NSNumber numberWithInteger:-1],	// .. 2nd level
				  [NSNumber numberWithInteger:-1],	// .. 3rd level
				  nil];
	}
	else
	{
		NSInteger selection = [[self.savedLocation objectAtIndex:0] integerValue];	// read the saved selection at level 1
		if (selection != -1)
		{
			//NSLog( @"Got the saved location... going to restore to %@.", self.savedLocation );
			// user was last at level 2 or deeper
			//
			// note: this starts a chain reaction down each level (2nd, 3rd, etc.)
			// so that each level restores itself and pushes further down until there's no further stored selections.
			//
			Level1ViewController *l1vc = (Level1ViewController *) [initialViewController topViewController];
			[l1vc restoreLevelWithSelectionArray:self.savedLocation];
		}
		else
		{
			// no saved selection, so user was at level 1 the last time
		}
	}

	// add the initial view controller's view to the window
	self.window = [[[UIWindow alloc] initWithFrame: UIScreen.mainScreen.bounds] autorelease];
	self.window.rootViewController = initialViewController;
	[self.window makeKeyAndVisible];

	// register our preference selection data to be archived
	[[NSUserDefaults standardUserDefaults] setObject: self.savedLocation forKey: kRestoreLocationKey];
	[[NSUserDefaults standardUserDefaults] synchronize];

    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	[[NSUserDefaults standardUserDefaults] setObject: self.savedLocation forKey: kRestoreLocationKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
