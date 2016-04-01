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

var NPrinter = function () {

};

NPrinter.prototype = {
    /**
     * Finds and return available printers.
     *
     * @param {Function} successCallback
     *      returns founded printers array
     * @param {Function?} errorCallback
     *      returns error message
     *
     */
    getAvailablePrinters: function (successCallback, errorCallback) {

        cordova.exec(successCallback, errorCallback, 'NPrinter', 'getAvailablePrinters', []);
    },

    /**
     * Sends the content to the printer app or service.
     *
     * @param {String} content
     *      HTML string 
     * @param {EpsonIoDeviceInfo} printer
     *      Chosen EpsonIoDeviceInfo-type printer that returns from 
     *      getAvailablePrinters method
     * @param {Function} successCallback
     *      
     * @param {Function} errorCallback
     *      
     */
    print: function (content, printer, successCallback, errorCallback) {
        
        var page = content.innerHTML || content;

        if (typeof page != 'string') {
            console.log('Print function requires an HTML string. Not an object');
            return;
        }

        if (!printer) {
            console.log('Print function requires printer');
            return;
        }

        cordova.exec(successCallback, errorCallback, 'NPrinter', 'print', [page, printer]);
    }
};

var plugin = new NPrinter();

module.exports = plugin;