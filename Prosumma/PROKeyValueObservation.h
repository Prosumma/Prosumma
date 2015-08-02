//
//  PROKeyValueObservation.h
//  PRO
//
//  Created by Gregory Higley on 9/28/13.
//  Copyright (c) 2013 Prosumma. All rights reserved.
//

@import Foundation;

typedef void (^PROKeyValueObservationBlock)(id target, NSDictionary *changes);

/*!
 @abstract Better KVO.
 @warning If the object being observed will have a longer lifetime than the observation, you must manually deregister the observation by calling deregister.
 */
@interface PROKeyValueObservation : NSObject
+ (instancetype)observationWithTarget:(NSObject*)target keyPath:(NSString*)keyPath options:(NSKeyValueObservingOptions)options observation:(PROKeyValueObservationBlock)observe;
+ (instancetype)observationWithTarget:(NSObject*)target keyPath:(NSString*)keyPath options:(NSKeyValueObservingOptions)options observer:(id)observer selector:(SEL)selector;
- (instancetype)initWithTarget:(NSObject*)target keyPath:(NSString*)keyPath options:(NSKeyValueObservingOptions)options observation:(PROKeyValueObservationBlock)observe;
- (instancetype)initWithTarget:(NSObject*)target keyPath:(NSString*)keyPath options:(NSKeyValueObservingOptions)options observer:(id)observer selector:(SEL)selector;
- (void)deregister;
@end
