#import "LeanplumPlugin.h"
#if __has_include(<leanplum/leanplum-Swift.h>)
#import <leanplum/leanplum-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "leanplum-Swift.h"
#endif

@implementation LeanplumPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLeanplumPlugin registerWithRegistrar:registrar];
}
@end
