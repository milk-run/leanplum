#import "FlutterLeanplumPlugin.h"
#if __has_include(<flutter_leanplum/flutter_leanplum-Swift.h>)
#import <flutter_leanplum/flutter_leanplum-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_leanplum-Swift.h"
#endif

@implementation FlutterLeanplumPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterLeanplumPlugin registerWithRegistrar:registrar];
}
@end
