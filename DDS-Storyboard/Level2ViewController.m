/*
     File: Level2ViewController.m
 Abstract: The application's level 2 view controller.
  Version: 1.3
 
 Changes from DrillDownSave by David W. Stockton:
 - Removed Level3ViewController property (connections are now through the
   storyboard).
 - Modified the @synthesis statements and property usage.
 - Removed "tableView:didSelectRowAtIndexPath:" since this is handled
   through segues in the storyboard.
 - Added the #import for the custom push segue that is used.
 - Added "prepareForSegue:sender:" to manage everything that
   "tableView:didSelectRowAtIndexPath:" had been doing plus deal with the
   restore chain reaction initiated segues.
 - Changed "restoreLevel:withSelectionArray:" to take a segue as its
   first argument since this is how the CustomPushSegue is designed and the
   list of items is no longer needed since the segue already initializes
   the view's content model. It then initiates a segue to the next
   level if a valid selection is in the selection array

 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

#import "AppDelegate.h"
#import "Level2ViewController.h"
#import "Level3ViewController.h"
#import "CustomPushSegue.h"

@implementation Level2ViewController

//@synthesize listContent, level3ViewController, myTableView;
@synthesize listContent = _listContent;
@synthesize myTableView = _myTableView;

- (void)dealloc
{
    [_myTableView release];
	[_listContent release];
	//[level3ViewController release];
	[super dealloc];
}

- (void)awakeFromNib
{	
	self.title = @"Level 2";
}


#pragma mark UIViewController delegates

- (void)viewWillAppear:(BOOL)animated
{
	[self.myTableView reloadData];	// populate our table's data
	
	NSIndexPath *tableSelection = [self.myTableView indexPathForSelectedRow];
	[self.myTableView deselectRowAtIndexPath:tableSelection animated:NO];
}


#pragma mark UITableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.listContent count];
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	// save off this level's selection to our AppDelegate
//	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//	[appDelegate.savedLocation replaceObjectAtIndex:1 withObject:[NSNumber numberWithInteger:indexPath.row]];
//	[appDelegate.savedLocation replaceObjectAtIndex:2 withObject:[NSNumber numberWithInteger:-1]];
//	
//	// provide the 3nd level its content
//	level3ViewController.listContent = [[listContent objectAtIndex:indexPath.row] objectForKey:kChildrenKey];
//	
//	// move to the 3rd level
//	[[self navigationController] pushViewController:level3ViewController animated:YES];
//    
//    // commit the drill down location preference setting
//    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.savedLocation forKey:kRestoreLocationKey];
//}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	/*
	 When a row is selected, the segue creates the detail view controller as the destination.
	 Set the detail view controller's detail item to the item associated with the selected row.
	 */
	if ([[segue identifier] isEqualToString: kNextLevelSegueIdentifier]) {
		NSArray *selectionArray = nil;
		NSIndexPath *indexPath;
		if( [sender isKindOfClass: [UITableViewCell class]] ) {
			indexPath = [self.myTableView indexPathForCell: sender];
		} else if( [sender isKindOfClass: [NSArray class]] ) {
			NSInteger row = [[sender objectAtIndex: 0] integerValue];
			indexPath = [NSIndexPath indexPathForRow: row inSection: 0];
			selectionArray = [sender objectAtIndex: 1];
		} else {
			NSLog( @"***** error: unrecognized sender class type \"%@\" in %s", NSStringFromClass([sender class]), __func__ );
			indexPath = [NSIndexPath indexPathForRow: 0 inSection: 0];
		}
		
		// save off this level's selection to our AppDelegate
		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
		[appDelegate.savedLocation replaceObjectAtIndex:1 withObject:[NSNumber numberWithInteger:indexPath.row]];
		[appDelegate.savedLocation replaceObjectAtIndex:2 withObject:[NSNumber numberWithInteger:-1]];
		
		// provide the 3nd level its content
		Level3ViewController *l3vc = segue.destinationViewController;
		l3vc.listContent = [[self.listContent objectAtIndex:indexPath.row] objectForKey:kChildrenKey];
		
		// if we are restoring to a stored level then set the action to be executed
		// after the segue performs the push
		if( selectionArray && [segue isKindOfClass: [CustomPushSegue class]] ) {
			CustomPushSegue *mySeg = (CustomPushSegue *) segue;
			mySeg.withoutAnimation = YES;
			mySeg.didPushDestinationAction = @selector(restoreLevel:withSelectionArray:);
			mySeg.didPushDestinationParameter = selectionArray;
		}
		
		// commit the drill down location preference setting
		[[NSUserDefaults standardUserDefaults] setObject:appDelegate.savedLocation forKey:kRestoreLocationKey];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	// get the view controller's info dictionary based on the indexPath's row
	NSDictionary* item = [self.listContent objectAtIndex:indexPath.row];
	cell.textLabel.text = [item objectForKey:kItemTitleKey];
	
	return cell;
}

// User was last at level 2 or deeper
//
// note: this is a part of a chain reaction down each level.
// so that each level restores itself and pushes further down until there's no further stored selections.
//
//- (void)restoreLevel:(NSArray*)items withSelectionArray:(NSArray *)selectionArray
//{
//	// user was last at level 2 or deeper
//	//
//	self.listContent = items;	// remember our content here at level 1 in case user navigates back to this level
//	
//	NSInteger itemIdx = [[selectionArray objectAtIndex:0] integerValue];
//	if (itemIdx != -1)
//	{
//		// we have a selection, move one more level deep and restore its content
//		// (not animated since the user should not see the restore process)
//		[[self navigationController] pushViewController:level3ViewController animated:NO];
//		
//		// get the level 3 content
//		NSArray *itemContent = [[items objectAtIndex:itemIdx] objectForKey:kChildrenKey];
//	
//		// narrow down the selection array for level 3
//		NSArray *newSelectionArray = [selectionArray subarrayWithRange:NSMakeRange(1, [selectionArray count]-1)];
//		
//		// restore that level
//		[level3ViewController restoreLevel:itemContent withSelectionArray:newSelectionArray];
//	}
//}
- (void)restoreLevel:(UIStoryboardSegue *)segue withSelectionArray:(NSArray *)selectionArray
{
	// pull the selected row for this level (first entry in the selection array)
	NSInteger itemIdx = [[selectionArray objectAtIndex: 0] integerValue];
	// narrow down the selection array for level 3
	NSArray *newSelectionArray = [selectionArray subarrayWithRange:NSMakeRange(1, [selectionArray count]-1)];
	if( itemIdx >= 0 ) {
		// build the sender that will be passed to "prepareForSegue:sender:" so it can be
		// recognized as coming from restoreLevel and have the selection array.
		// (since we are going to the leaf view controller this is all ignored)
		NSArray *sender = [NSArray arrayWithObjects: [NSNumber numberWithInteger: itemIdx], newSelectionArray, nil];
		[self performSegueWithIdentifier: kNextLevelSegueIdentifier sender: sender];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	// we have moved to level 2, remove it's stored selection
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate.savedLocation replaceObjectAtIndex:1 withObject:[NSNumber numberWithInteger:-1]];
    
    // commit the drill down location preference setting
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.savedLocation forKey:kRestoreLocationKey];
}

@end

