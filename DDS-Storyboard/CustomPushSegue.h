//
//  CustomPushSegue.h
//  Subclass of UIStoryboardSegue. This should be a drop-in-replacement for
//  a Push segue. It's function can, however, be customized in
//  prepareForSegue:sender: to not have animation (by setting the
//  withoutAnimation property to YES) and to perform the method set in the
//  didPushDestrinationAction property on the destinationViewController after
//  doing the push call on the navigation controller.
//
//  The didPushDestrinationAction method must take two arguments. The first will
//  be the segue and the second will be what the user has set in the
//  didPushDestinationParameter property.
//
//  Example usage:
//  - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//  {
//	if ([[segue identifier] isEqualToString: kNextLevelSegueIdentifier]) {
//		NSArray *selectionArray = nil;
//		NSIndexPath *indexPath;
//		if( [sender isKindOfClass: [UITableViewCell class]] ) {
//			indexPath = [self.myTableView indexPathForCell: sender];
//		} else if( [sender isKindOfClass: [NSArray class]] ) {
//			NSInteger row = [[sender objectAtIndex: 0] integerValue];
//			indexPath = [NSIndexPath indexPathForRow: row inSection: 0];
//			selectionArray = [sender objectAtIndex: 1];
//		} else {
//			NSLog( @"***** error: unrecognized sender class type \"%@\" in %s", NSStringFromClass([sender class]), __func__ );
//			indexPath = [NSIndexPath indexPathForRow: 0 inSection: 0];
//		}
//		
//		// save off this level's selection to our AppDelegate
//		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//		[appDelegate.savedLocation replaceObjectAtIndex:0 withObject:[NSNumber numberWithInteger:indexPath.row]];
//		[appDelegate.savedLocation replaceObjectAtIndex:1 withObject:[NSNumber numberWithInteger:-1]];
//		[appDelegate.savedLocation replaceObjectAtIndex:2 withObject:[NSNumber numberWithInteger:-1]];
//		
//		// provide the 2nd level its content
//		Level2ViewController *l2vc = segue.destinationViewController;
//		l2vc.listContent = [[self.listContent objectAtIndex:indexPath.row] objectForKey:kChildrenKey];
//		
//		// if we are restoring to a stored level then set the action to be executed
//		// after the segue performs the push
//		if( selectionArray && [segue isKindOfClass: [CustomPushSegue class]] ) {
//			CustomPushSegue *mySeg = (CustomPushSegue *) segue;
//			mySeg.withoutAnimation = YES;
//			mySeg.didPushDestinationAction = @selector(restoreLevel:withSelectionArray:);
//			mySeg.didPushDestinationParameter = selectionArray;
//		}
//		
//		// commit the drill down location preference setting
//		[[NSUserDefaults standardUserDefaults] setObject:appDelegate.savedLocation forKey:kRestoreLocationKey];
//	}
//  }
//  - (void)restoreLevel:(UIStoryboardSegue *)segue withSelectionArray:(NSArray *)selectionArray
//  {
//	// pull the selected row for this level (first entry in the selection array)
//	NSInteger itemIdx = [[selectionArray objectAtIndex: 0] integerValue];
//	// narrow down the selection array for level 3
//	NSArray *newSelectionArray = [selectionArray subarrayWithRange:NSMakeRange(1, [selectionArray count]-1)];
//	if( itemIdx >= 0 ) {
//		// build the sender that will be passed to "prepareForSegue:sender:" so it can be
//		// recognized as coming from restoreLevel and have the selection array.
//		// (since we are going to the leaf view controller this is all ignored)
//		NSArray *sender = [NSArray arrayWithObjects: [NSNumber numberWithInteger: itemIdx], newSelectionArray, nil];
//		[self performSegueWithIdentifier: kNextLevelSegueIdentifier sender: sender];
//	}
//  }
//
//
//  Created by David W. Stockton on 4/1/13.
//

#import <UIKit/UIKit.h>

@interface CustomPushSegue : UIStoryboardSegue

@property (nonatomic, assign) BOOL withoutAnimation;

@property (nonatomic, assign) SEL didPushDestinationAction;
@property (nonatomic, retain) id didPushDestinationParameter;

@end