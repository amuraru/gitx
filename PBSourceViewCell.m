//
//  PBSourceViewCell.m
//  GitX
//
//  Created by Nathan Kinsinger on 1/7/10.
//  Copyright 2010 Nathan Kinsinger. All rights reserved.
//

#import "PBSourceViewCell.h"
#import "PBGitSidebarController.h"
#import "PBSourceViewBadge.h"




@implementation PBSourceViewCell

@synthesize isCheckedOut;
@synthesize behind,ahead;

# pragma mark context menu delegate methods

- (NSMenu *) menuForEvent:(NSEvent *)event inRect:(NSRect)rect ofView:(NSOutlineView *)view
{
	NSPoint point = [view convertPoint:[event locationInWindow] fromView:nil];
	NSInteger row = [view rowAtPoint:point];
	
	PBGitSidebarController *controller = [view delegate];
	
	return [controller menuForRow:row];
}


#pragma mark drawing

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)outlineView
{
	if(behind || ahead || isCheckedOut){		
		NSMutableString *badge=[NSMutableString string];
		if(isCheckedOut) [badge appendString:@"✔ "];
		if(ahead) [badge appendFormat:@"+%@",ahead];
		if(behind) [badge appendFormat:@"-%@",behind];
		NSImage *checkedOutImage = [PBSourceViewBadge badge:badge forCell:self];
		NSSize imageSize = [checkedOutImage size];
		NSRect imageFrame;
		NSDivideRect(cellFrame, &imageFrame, &cellFrame, imageSize.width + 3, NSMaxXEdge);
		imageFrame.size = imageSize;
		
		if ([outlineView isFlipped])
			imageFrame.origin.y += floor((cellFrame.size.height + imageFrame.size.height) / 2);
		else
			imageFrame.origin.y += ceil((cellFrame.size.height - imageFrame.size.height) / 2);
		
		[checkedOutImage compositeToPoint:imageFrame.origin operation:NSCompositeSourceOver];
	}
	
	[super drawWithFrame:cellFrame inView:outlineView];
}

@end