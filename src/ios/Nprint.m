
#import <Cordova/CDVAvailability.h>
#import "ePOS-Print.h"
#import "ePOSBluetoothConnection.h"
#import "NPrint.h"

@interface MysObj : NSObject
@property NSString *name;
@property NSString *type;
@end


@interface NPrinter ()
    - (void) sendError:(int)errorStatus textForShow:(NSString*)text command:(CDVInvokedUrlCommand*)command;
    - (void) sendError:(NSString*)text command:(CDVInvokedUrlCommand*)command;
@end


@implementation NPrinter
/**
 * Find printers and print
 * Sends the printing content to the printer controller and opens them.
 *
 */

- (void) getAvailablePrinters:(CDVInvokedUrlCommand*)command
{
    int find_printers_status = EPSONIO_OC_SUCCESS;
    find_printers_status = [EpsonIoFinder start:EPSONIO_OC_DEVTYPE_BLUETOOTH FindOption:nil];
    
    [self sendError:find_printers_status textForShow:@"error during printer search" command:command];
    
    int get_printers_list_status = EPSONIO_OC_SUCCESS;
    
//    NSArray *printerList_ = [[NSArray alloc]initWithArray:
//                             [EpsonIoFinder getDeviceInfoList:&get_printers_list_status
//                                                 FilterOption:EPSONIO_OC_PARAM_DEFAULT]];
    
    
    
    MysObj *printer1;
    MysObj *printer2;
    MysObj *printer3;
    
    printer1.name = @"printer raz";
    printer2.name = @"printer dva";
    printer3.name = @"printer tri";
    printer1.type = @"type raz";
    printer2.type = @"type dva";
    printer3.type = @"type tri";
    
    NSMutableArray *printerList_ = [[NSMutableArray alloc] init];
    [printerList_ addObject:printer1];
    [printerList_ addObject:printer2];
    [printerList_ addObject:printer3];
    
    
    [EpsonIoFinder stop];
    
    if ( [printerList_ count] < 1 ) {
        [self sendError:@"printers not found" command:command];
    } else {
        
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                         messageAsArray:printerList_];
        
        [self.commandDelegate sendPluginResult:pluginResult
                                    callbackId:command.callbackId];
    }
}


- (void) print:(CDVInvokedUrlCommand*)command
{
    
    NSArray * arguments = [command arguments];
    NSString *str = [arguments objectAtIndex:0];
    EpsonIoDeviceInfo *chosenPrinter = [arguments objectAtIndex:1];
    
    

    NSString* deviceName = [chosenPrinter deviceName];
    NSString* printerName = [chosenPrinter printerName];

    //Initialize an EposBuilder class instance
    id builder = [[EposBuilder alloc] initWithPrinterModel: printerName Lang: EPOS_OC_MODEL_ANK];
    if ( builder == nil ) {
        [self sendError:@"builder initialize error" command:command];
    }

    //Create a print document
    int errorStatus = EPOS_OC_SUCCESS;
    errorStatus = [builder addTextLang: EPOS_OC_LANG_EN];
    errorStatus = [builder addTextSmooth: EPOS_OC_TRUE];
    errorStatus = [builder addTextFont: EPOS_OC_FONT_A];
    errorStatus = [builder addTextSize: 3 Height: 3];
    errorStatus = [builder addText: str];
    errorStatus = [builder addCut: EPOS_OC_CUT_FEED];

    //Initialize an EposPrint class instance
    id printer = [[EposPrint alloc] init];
    unsigned long status;

    //Send a print document
    if (printer == nil) {
        [self sendError:@"printer initialize error" command:command];
    }

    //<Start communication with the printer>
    errorStatus = [printer openPrinter:EPSONIO_OC_DEVTYPE_BLUETOOTH
    DeviceName:deviceName Enabled:EPOS_OC_TRUE
    Interval:EPOS_OC_PARAM_DEFAULT Timeout:EPOS_OC_PARAM_DEFAULT];

    //<Send data>
    errorStatus = [printer sendData:builder Timeout:10000 Status:&status];
    
    [self sendError:errorStatus textForShow:@"Failure to send data to printer" command:command];

    //<Delete the command buffers>
    if ((status & EPOS_OC_ST_PRINT_SUCCESS) == EPOS_OC_ST_PRINT_SUCCESS) {
        errorStatus = [builder clearCommandBuffer];
    }

    //<End communication with the printer>
    errorStatus = [printer closePrinter];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                     messageAsString:@"success"];

    [self.commandDelegate sendPluginResult:pluginResult
                          callbackId:command.callbackId];

}
 
- (void) sendError:(int)errorStatus textForShow:(NSString*)text command:(CDVInvokedUrlCommand*)command
{
    if (errorStatus != EPOS_OC_SUCCESS) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                         messageAsString:[NSString stringWithFormat:@"%@%i", text, errorStatus]];
        
        [self.commandDelegate sendPluginResult:pluginResult
                              callbackId:command.callbackId];
    }
}

- (void) sendError:(NSString*)text command:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                     messageAsString:text];
    
    [self.commandDelegate sendPluginResult:pluginResult
                          callbackId:command.callbackId];
}

@end