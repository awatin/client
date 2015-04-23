//
//  KBAppToolbar.m
//  Keybase
//
//  Created by Gabriel on 4/22/15.
//  Copyright (c) 2015 Gabriel Handford. All rights reserved.
//

#import "KBAppToolbar.h"

#import "KBUserButtonView.h"

@interface KBAppToolbar ()
@property KBUserButtonView *userProfileButton;
@property NSArray *buttons;
@end

#define ImageWidth (30)

@implementation KBAppToolbar

- (void)viewInit {
  [super viewInit];
  GHWeakSelf gself = self;

  /*
  KBLabel *label = [[KBLabel alloc] init];
  [label setText:@"Keybase" font:[NSFont systemFontOfSize:18] color:KBAppearance.currentAppearance.textColor alignment:NSCenterTextAlignment];
  [self addSubview:label];
   */

  KBButton *usersButton = [KBButton buttonWithText:@"Users" image:[KBIcons.icons imageForIcon:KBIconUsers size:CGSizeMake(30, 30)] style:KBButtonStyleEmpty];
  usersButton.tag = KBAppViewItemUsers;
  usersButton.toggleEnabled = YES;
  usersButton.targetBlock = ^{ [self notifyItemSelected:KBAppViewItemUsers]; };
  [usersButton.cell setImagePosition:NSImageAbove];
  [self addSubview:usersButton];

  KBButton *foldersButton = [KBButton buttonWithText:@"Folders" image:[KBIcons.icons imageForIcon:KBIconGroupFolder size:CGSizeMake(ImageWidth, ImageWidth)] style:KBButtonStyleEmpty];
  foldersButton.tag = KBAppViewItemFolders;
  foldersButton.toggleEnabled = YES;
  foldersButton.targetBlock = ^{ [self notifyItemSelected:KBAppViewItemFolders]; };
  [foldersButton.cell setImagePosition:NSImageAbove];
  [self addSubview:foldersButton];

  //KBButton *devicesButton = [KBButton buttonWithImage:[KBIcons.icons imageForIcon:KBIconMacbook size:CGSizeMake(ImageWidth, ImageWidth)]];
  KBButton *devicesButton = [KBButton buttonWithText:@"Devices" image:[KBIcons.icons imageForIcon:KBIconMacbook size:CGSizeMake(ImageWidth, ImageWidth)] style:KBButtonStyleEmpty];
  devicesButton.tag = KBAppViewItemDevices;
  devicesButton.toggleEnabled = YES;
  devicesButton.targetBlock = ^{ [self notifyItemSelected:KBAppViewItemDevices]; };
  [devicesButton.cell setImagePosition:NSImageAbove];
  [self addSubview:devicesButton];

  KBBox *border = [KBBox horizontalLine];
  [self addSubview:border];

  _userProfileButton = [[KBUserButtonView alloc] init];
  [_userProfileButton setButtonStyle:KBButtonStyleToolbar];
  _userProfileButton.button.toggleEnabled = YES;
  _userProfileButton.button.tag = KBAppViewItemProfile;
  _userProfileButton.hidden = YES;
  _userProfileButton.button.targetBlock = ^{ [self notifyItemSelected:KBAppViewItemProfile]; };
  [self addSubview:_userProfileButton];

  _buttons = @[usersButton, foldersButton, devicesButton, _userProfileButton.button];

  self.viewLayout = [YOLayout layoutWithLayoutBlock:^CGSize(id<YOLayout> layout, CGSize size) {
    CGFloat x = 8;
    CGFloat y = 20;

//    CGSize labelSize = [label sizeThatFits:CGSizeMake(size.width, 32)];
//    [layout centerWithSize:labelSize frame:CGRectMake(0, 0, size.width, 32) view:label];

    x += [layout setFrame:CGRectMake(x, y, ImageWidth + 20, ImageWidth + 20) view:usersButton].size.width + 5;
    x += [layout setFrame:CGRectMake(x, y, ImageWidth + 20, ImageWidth + 20) view:foldersButton].size.width + 5;
    x += [layout setFrame:CGRectMake(x, y, ImageWidth + 20, ImageWidth + 20) view:devicesButton].size.width + 5;
    y += 54;

    CGSize userButtonSize = [gself.userProfileButton sizeThatFits:CGSizeMake(size.width - x, 44)];
    [layout setFrame:CGRectMake(size.width - userButtonSize.width - 10, y - userButtonSize.height - 10, userButtonSize.width, userButtonSize.height) view:gself.userProfileButton];

    [layout setFrame:CGRectMake(0, y - 1, size.width, y) view:border];

    return CGSizeMake(size.width, y);
  }];
}

- (void)setUser:(KBRUser *)user {
  _userProfileButton.hidden = !user;
  [_userProfileButton setUser:user];
}

- (KBButton *)buttonWithTag:(NSInteger)tag {
  return [_buttons detect:^BOOL(KBButton *b) { return b.tag == tag; }];
}

- (void)setStateOffExcept:(KBAppViewItem)item {
  for (KBButton *button in _buttons) {
    if (button.state == NSOnState && button.tag != item) {
      button.state = NSOffState;
      //[button setNeedsDisplay];
    }
  }
}

- (void)selectItem:(KBAppViewItem)item {
  [self setStateOffExcept:item];
  [self buttonWithTag:item].state = NSOnState;
}

- (void)notifyItemSelected:(KBAppViewItem)item {
  [self setStateOffExcept:item];
  [self.delegate appToolbar:self didSelectItem:item];
}

@end
