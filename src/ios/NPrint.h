
#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

@interface NPrinter : CDVPlugin

// Prints the content
- (void) print:(CDVInvokedUrlCommand*)command;
// Find available printers and return founded printers array
- (void) getAvailablePrinters:(CDVInvokedUrlCommand*)command;

@end
