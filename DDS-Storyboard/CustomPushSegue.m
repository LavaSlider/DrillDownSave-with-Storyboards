//
//  CustomPushSegue.m
//  
//
//  Created by David W. Stockton on 4/1/13.
//

#import "CustomPushSegue.h"

@implementation CustomPushSegue
@synthesize withoutAnimation = _withoutAnimation;
@synthesize didPushDestinationAction = _didPushDestinationAction;
@synthesize didPushDestinationParameter = _didPushDestinationParameter;

- (void) perform {
	//NSLog( @"Doing a %@ perform for segue '%@' from %@ --> %@!!", NSStringFromClass([self class]), self.identifier, self.sourceViewController, self.destinationViewController );

	[[[self sourceViewController] navigationController] pushViewController: [self destinationViewController] animated: !self.withoutAnimation];
	
	if( self.didPushDestinationAction && [[self destinationViewController] respondsToSelector: self.didPushDestinationAction] ) {
		[[self destinationViewController] performSelector: self.didPushDestinationAction withObject: self withObject: self.didPushDestinationParameter];
	}
}

- (void) dealloc {
	[_didPushDestinationParameter release];
	[super dealloc];
}

@end
