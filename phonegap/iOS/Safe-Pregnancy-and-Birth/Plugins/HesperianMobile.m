//
//  HesperianMobile.m
//  HesperianMobile
//
//  Created by Matthew Litwin on 6/11/11.
//  Copyright 2011 Hesperian. All rights reserved.
//

#import "HesperianMobile.h"

/*
	Disable the bounce (elastic scrolling) effect in a web view.
	
	The method is to recurse down to find the UIScrollView,
	and there set bounces = NO.
	
	This assumes that there's a UIScrollView doing the scrolling,
	which seems to be true at at least by iOS 4.0.
	
	On a 3.1.4 device at at least, that doesn't seem to be the case -
	this method doesn't disable bounces there.
	
*/
static void DisableScrollViewBounce(UIView* view)
{
	if( [view isKindOfClass:[UIScrollView class] ]) {
		UIScrollView* sv = (UIScrollView*) view;
		sv.bounces = NO;

	} else for(UIView* v in view.subviews)
	{
		DisableScrollViewBounce( v);
	}
}
 
@implementation HesperianMobile

@synthesize callbackID;

- (void) OnDeviceReady:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
	DisableScrollViewBounce( self.webView);
}

@end
