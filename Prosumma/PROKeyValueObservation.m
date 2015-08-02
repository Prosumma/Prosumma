//
//  PROKeyValueObservation.m
//  PRO
//
//  Created by Gregory Higley on 9/28/13.
//  Copyright (c) 2013 Prosumma. All rights reserved.
//

#import <objc/runtime.h>
#import "PROKeyValueObservation.h"

static NSMutableSet *SwizzledClasses = nil;
static char ObservationsProperty = 0;

@implementation PROKeyValueObservation {
@private
    NSString *_keyPath;
    // We use this instead of __weak because weak references are
    // zeroed before dealloc is called, thus we'd never
    // be able to unregister our object.
    __unsafe_unretained NSObject *_target;
    PROKeyValueObservationBlock _observe;
}

+ (void)initialize
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        SwizzledClasses = [NSMutableSet new];
    });
}

+ (instancetype)observationWithTarget:(NSObject*)target keyPath:(NSString*)keyPath options:(NSKeyValueObservingOptions)options observation:(PROKeyValueObservationBlock)observe
{
    return [[self alloc] initWithTarget:target keyPath:keyPath options:options observation:observe];
}

+ (instancetype)observationWithTarget:(NSObject*)target keyPath:(NSString*)keyPath options:(NSKeyValueObservingOptions)options observer:(id)observer selector:(SEL)selector
{
    return [[self alloc] initWithTarget:target keyPath:keyPath options:options observer:observer selector:selector];
}

- (instancetype)initWithTarget:(NSObject*)target keyPath:(NSString*)keyPath options:(NSKeyValueObservingOptions)options observation:(PROKeyValueObservationBlock)observe
{
    NSParameterAssert(target != nil);
    NSParameterAssert(observe != nil);
    
    self = [super init];
    if (self) {
        _keyPath = [keyPath copy];
        _observe = [observe copy];
        @synchronized (SwizzledClasses) {
            if (![SwizzledClasses containsObject:target.class]) {
                SEL deallocSelector = NSSelectorFromString(@"dealloc");
                Method dealloc = class_getInstanceMethod(target.class, deallocSelector);
                IMP deallocImp = method_getImplementation(dealloc);
                IMP swizzleImp = imp_implementationWithBlock(^(void *obj) {
                    @autoreleasepool {
                        NSMutableArray *observations = objc_getAssociatedObject((__bridge id)obj, &ObservationsProperty);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                        [observations makeObjectsPerformSelector:@selector(deregister)];
#pragma clang diagnostic pop
                    }
                    ((void (*)(void *, SEL))deallocImp)(obj, deallocSelector);
                });
                class_replaceMethod(target.class, deallocSelector, swizzleImp, method_getTypeEncoding(dealloc));
                [SwizzledClasses addObject:target.class];
            }
        }
        @synchronized (target) {
            NSMutableArray *observations = objc_getAssociatedObject(target, &ObservationsProperty);
            if (!observations) objc_setAssociatedObject(target, &ObservationsProperty, observations = [NSMutableArray new], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [observations addObject:self];
        }
        [target addObserver:self forKeyPath:keyPath options:options context:NULL];
        _target = target;
    }
    return self;
}

- (instancetype)initWithTarget:(NSObject*)target keyPath:(NSString*)keyPath options:(NSKeyValueObservingOptions)options observer:(id)observer selector:(SEL)selector
{
    NSParameterAssert(observer != nil);
    NSParameterAssert(selector != NULL);
    
    __weak id weakObserver = observer;
    PROKeyValueObservationBlock observe = ^(id target, NSDictionary *changes) {
        id observer = weakObserver;
        if (observer) {
            IMP observe = [observer methodForSelector:selector];
            ((void (*)(id, SEL, id, NSDictionary *))observe)(observer, selector, target, changes);
        }
    };
    
    return [self initWithTarget:target keyPath:keyPath options:options observation:observe];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    _observe(object, change);
}

- (void)deregister
{
    NSObject *target = _target;
    if (target) {
        _target = nil;
        [target removeObserver:self forKeyPath:_keyPath];
        NSMutableArray *observations = objc_getAssociatedObject(target, &ObservationsProperty);
        @synchronized (observations) {
            [observations removeObject:self];
        }
    }
}

- (void)dealloc
{
    [self deregister];
}

@end
