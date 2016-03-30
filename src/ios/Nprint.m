/*
 Copyright 2013-2014 appPlant UG

 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import "NPrint.h"
#import <Cordova/CDVAvailability.h>
#import "ePOS-Print.h"
#import "ePOSBluetoothConnection.h"
#import "ePOSEasySelect.h" 

@interface NPrinter ()

@end


@implementation NPrinter


/**
 * Sends the printing content to the printer controller and opens them.
 *
 * @param {NSString} content
 *      The (HTML encoded) content
 */
- (void) print:(CDVInvokedUrlCommand*)command
{
    int find_printers_status = EPSONIO_OC_SUCCESS;
    find_printers_status = [EpsonIoFinder start:EPSONIO_OC_DEVTYPE_BLUETOOTH FindOption:nil];

    int get_printers_list_status = EPSONIO_OC_SUCCESS;
    if ( find_printers_status == EPSONIO_OC_SUCCESS) {
        NSArray *printerList_ = [[NSArray alloc]initWithArray:
        [EpsonIoFinder getDeviceInfoList:&get_printers_list_status
        FilterOption:EPSONIO_OC_PARAM_DEFAULT]];
        [EpsonIoFinder stop];
    

        if ( [printerList_ count] < 1 ) {
            return;
        }

        NSString* deviceName = [[printerList_ objectAtIndex:0] deviceName];
        NSString* printerName = [[printerList_ objectAtIndex:0] printerName];

        //Initialize an EposBuilder class instance
        id builder = [[EposBuilder alloc] initWithPrinterModel: printerName Lang: EPOS_OC_MODEL_ANK];
        if ( builder == nil ) {
            return;
        }

        NSArray * arguments = [command arguments];
        NSString *str = [arguments objectAtIndex:0];

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
        long status;

        //Send a print document
        if (printer == nil) {
            return;
        }

        //<Start communication with the printer>
        errorStatus = [printer openPrinter:EPSONIO_OC_DEVTYPE_BLUETOOTH
        DeviceName:deviceName Enabled:EPOS_OC_TRUE
        Interval:EPOS_OC_PARAM_DEFAULT Timeout:EPOS_OC_PARAM_DEFAULT];

        //<Send data>
        errorStatus = [printer sendData:builder Timeout:10000 Status:&status];

        //<Delete the command buffers>
        if ((status & EPOS_OC_ST_PRINT_SUCCESS) == EPOS_OC_ST_PRINT_SUCCESS) {
            errorStatus = [builder clearCommandBuffer];
        }

        //<End communication with the printer>
        errorStatus = [printer closePrinter];
    }
}

@end