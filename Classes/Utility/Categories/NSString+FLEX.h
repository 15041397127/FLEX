//
//  NSString+FLEX.h
//  FLEX
//
//  Created by Tanner on 3/26/17.
//  Copyright © 2017 Tanner Bennett. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLEXRuntimeUtility.h"

@interface NSString (FLEXTypeEncoding)

///@return whether this type starts with the const specifier
@property (nonatomic, readonly) BOOL typeIsConst;
/// @return the first char in the type encoding that is not the const specifier
@property (nonatomic, readonly) FLEXTypeEncoding firstNonConstType;
/// @return whether this type is an objc object of any kind, even if it's const
@property (nonatomic, readonly) BOOL typeIsObjectOrClass;
/// Includes C strings and selectors as well as regular pointers
@property (nonatomic, readonly) BOOL typeIsNonObjcPointer;

@end

@interface NSString (KeyPaths)

- (NSString *)stringByRemovingLastKeyPathComponent;
- (NSString *)stringByReplacingLastKeyPathComponent:(NSString *)replacement;

@end
