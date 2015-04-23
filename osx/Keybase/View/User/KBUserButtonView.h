//
//  KBUserButtonView.h
//  Keybase
//
//  Created by Gabriel on 4/23/15.
//  Copyright (c) 2015 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KBAppKit.h"
#import "KBRPC.h"

@interface KBUserButtonView : KBButtonView

- (void)setUser:(KBRUser *)user;

@end
