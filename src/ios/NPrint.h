
#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

@interface NPrinter : CDVPlugin

// Prints the content
- (void) print:(CDVInvokedUrlCommand*)command;
// Find out whether printing is supported on this platform
- (void) isServiceAvailable:(CDVInvokedUrlCommand*)command;

@end
