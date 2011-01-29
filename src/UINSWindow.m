//
//  UINSWindow.m
//  UIKit
//
//  Created by Andrew Pouliot on 1/28/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import "UINSWindow.h"


@implementation UINSWindow

- (id)initWithUIWindow:(UIWindow *)inWindow type:(UINSWindowType)inWindowType;
{
	self = [super initWithContentRect:[inWindow frame]
							styleMask:(NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask) 
							  backing:NSBackingStoreBuffered defer:YES];
	if (!self) return nil;
	
	uiWindow = inWindow;
	
	return self;
}

- (void)sendEvent:(NSEvent *)inEvent;
{
	//TODO: support more event types
	if ([inEvent type] == NSLeftMouseDown || [inEvent type] == NSLeftMouseUp) {
		//TODO: create a new UIEvent for this baby
		[uiWindow sendEvent:inEvent];
	} else {		
		[super sendEvent:inEvent];
	}
}

@end