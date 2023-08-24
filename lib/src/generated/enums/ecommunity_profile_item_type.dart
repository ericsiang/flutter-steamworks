// ignore_for_file: public_member_api_docs
import "dart:ffi";

typedef ECommunityProfileItemTypeAliasDart = int;
typedef ECommunityProfileItemTypeAliasC = Int32;

enum ECommunityProfileItemType {
  animatedAvatar(0),
  avatarFrame(1),
  profileModifier(2),
  profileBackground(3),
  miniProfileBackground(4),
  ;

  final int value;

  const ECommunityProfileItemType(this.value);

  factory ECommunityProfileItemType.fromValue(int value) {
    switch (value) {
      case 0:
        return ECommunityProfileItemType.animatedAvatar;
      case 1:
        return ECommunityProfileItemType.avatarFrame;
      case 2:
        return ECommunityProfileItemType.profileModifier;
      case 3:
        return ECommunityProfileItemType.profileBackground;
      case 4:
        return ECommunityProfileItemType.miniProfileBackground;
      default:
        throw "Unknown value for 'ECommunityProfileItemType'. The value was: '$value'";
    }
  }
}
