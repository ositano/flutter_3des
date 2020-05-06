#import "Flutter3desPlugin.h"
#if __has_include(<flutter_3des/flutter_3des-Swift.h>)
#import <flutter_3des/flutter_3des-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_3des-Swift.h"
#endif

@implementation Flutter3desPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutter3desPlugin registerWithRegistrar:registrar];
}
@end
