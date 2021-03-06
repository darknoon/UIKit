//
//  UIScrollView.m
//  UIKit
//
//  Created by Shaun Harrison on 4/30/09.
//  Copyright 2009 enormego. All rights reserved.
//

#import "UIScrollView.h"
#import "UIColor.h"
#import "UIScrollKnob.h"
#import "UIView.h"

#import <QuartzCore/QuartzCore.h>

@implementation UIScrollView
@synthesize contentView;
@synthesize delegate;

- (void)setupScrollViewDefaults {
}

- (id)initWithFrame:(CGRect)frameRect {
	self = [super initWithFrame:frameRect];
	if (!self) return nil;
	
	contentView = [[UIView alloc] initWithFrame:self.bounds];
	self.contentView.autoresizingMask = 0;
	contentView.backgroundColor = [UIColor grayColor];
	[super addSubview:contentView];
	
	scroller = [[UIScrollKnob alloc] initWithScrollView:self];
	[super addSubview:scroller];
	
	return self;
}

- (void)dealloc {
	[contentView release];
	[scroller release];
	[super dealloc];
}

- (CGRect)scrollerFrame;
{
	CGRect bounds = self.bounds;
	return (CGRect) {
		.origin.x = bounds.size.width - 14.f,
		.origin.y = 5.f,
		.size.height = bounds.size.height - 10.f,
		.size.width = 14.f,
	};
}

- (void)setFrame:(CGRect)inFrame;
{
	[super setFrame:inFrame];
	//Constrain contentOffset to be feasible
	CGPoint contentOffset = self.contentOffset;
	contentOffset.x = fminf(contentOffset.x, fmaxf(0.0f, _contentSize.width - self.bounds.size.width));
	contentOffset.y = fminf(contentOffset.y, fmaxf(0.0f, _contentSize.height - self.bounds.size.height));
	self.contentOffset = contentOffset;
}

- (void)layoutSubviews;
{
	[super layoutSubviews];
	
	
	CGRect availableFrame = [self scrollerFrame];
	CGRect bounds = self.bounds;
	
	const CGFloat minimumScrollerSize = 20.0f;

	CGPoint maximumContentOffset = (CGPoint) {
		.x = fmaxf(_contentSize.width - bounds.size.width, 0.0f),
		.y = fmaxf(_contentSize.height - bounds.size.height, 0.0f),
	};
	
	BOOL showVerticalScroller = _contentSize.height > 0.0f && bounds.size.height < _contentSize.height;
	
	
	if (showVerticalScroller) {
		CGFloat verticalScrollerSize = availableFrame.size.height * bounds.size.height / _contentSize.height;

		verticalScrollerSize = fminf(fmaxf(minimumScrollerSize, verticalScrollerSize), availableFrame.size.height);
	
		CGRect scrollerFrame =  {
			.origin.x = availableFrame.origin.x,
			.origin.y = availableFrame.origin.y + (availableFrame.size.height - verticalScrollerSize) * (_contentOffset.y / maximumContentOffset.y),
			.size.width = availableFrame.size.width,
			.size.height = verticalScrollerSize,
		};
		
		//Fix scroller going off the end
		if (scrollerFrame.origin.y + scrollerFrame.size.height > CGRectGetMaxY(availableFrame)) {
			scrollerFrame.origin.y = CGRectGetMaxY(availableFrame) - scrollerFrame.size.height;
		}
		scroller.frame = scrollerFrame;
		scroller.alpha = 1.0f;
	} else {
		scroller.frame = availableFrame;
		scroller.alpha = 0.0f;
	}
	
	self.contentView.frame = (CGRect) {
		.origin.x = 0,
		.origin.y = 0,
		.size.width = fmaxf(_contentSize.width, bounds.size.width),
		.size.height = fmaxf(_contentSize.height, bounds.size.height),
		
	};
	
	contentView.bounds = (CGRect) {
		.origin.x = self.contentOffset.x,
		.origin.y = self.contentOffset.y,
		.size.width = fmaxf(_contentSize.width, bounds.size.width),
		.size.height = fmaxf(_contentSize.height, bounds.size.height),
	};

}

- (void)scrollWheel:(NSEvent *)inEvent;
{
	CGPoint contentOffset = _contentOffset;
	contentOffset.y -= 8.0f * [inEvent deltaY];
	
	contentOffset.y = floorf(fmaxf(0.0f, fminf(contentOffset.y, self.contentSize.height - self.frame.size.height)));
	
	self.contentOffset = contentOffset;
	
}

- (void)setContentSize:(CGSize)inSize {
	_contentSize = inSize;
	[self setNeedsLayout];
}

- (CGSize)contentSize;
{
	return _contentSize;
}

- (void)setContentOffset:(CGPoint)aPoint {
	_contentOffset = aPoint;
	[self setNeedsLayout];
}

- (CGPoint)contentOffset {
	return _contentOffset;
}

- (void)addSubview:(UIView*)aView {
	[self.contentView addSubview:aView];
}

- (void)_scrollerScrolled:(UIScrollKnob *)inScrollKnob withEvent:(NSEvent *)inEvent;
{
	//dy is backwards because of coordinate flipping. Do we care?
	CGFloat dy = -[inEvent deltaY];
	
	CGRect scrollerRect = [self scrollerFrame];
	CGPoint contentOffset = self.contentOffset;
	contentOffset.y -= (dy / scrollerRect.size.height) * self.contentSize.height;
	contentOffset.y = floorf(fmaxf(0.0f, fminf(contentOffset.y, self.contentSize.height - self.frame.size.height)));
	self.contentOffset = contentOffset;
}

@end
