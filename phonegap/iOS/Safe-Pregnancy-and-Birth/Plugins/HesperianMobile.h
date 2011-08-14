//
//  HesperianMobile.h
//  HesperianMobile
//
//  Created by Matthew Litwin on 6/11/11.
//  Copyright 2011 Hesperian. All rights reserved.
//

#ifdef PHONEGAP_FRAMEWORK
#import <Foundation/Foundation.h>
#import <PhoneGap/PGPlugin.h>
#else
#import "PGPlugin.h"
#endif


@interface HesperianMobile : PGPlugin {
    NSString* callbackID;
}

@property (nonatomic, copy) NSString* callbackID;

- (void) OnDeviceReady:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
