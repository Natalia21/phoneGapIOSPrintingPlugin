Cordova IOS-Bluetooth-Print plugin
==================================

## Adding the Plugin to your project
Through the [Command-line Interface](http://cordova.apache.org/docs/en/3.0.0/guide_cli_index.md.html#The%20Command-line%20Interface):

```bash

cordova plugin add https://github.com/Natalia21/phoneGapIOSPrintingPlugin.git
cordova build


## Removing the Plugin from your project

cordova plugin rm intspirit.cordova.plugin.printer
```


## Using the plugin
The plugin creates the object ```window.plugin.printer```

### Printing 

** Below example uses print share app for printing files.
```javascript
	window.plugin.printer.getAvailablePriner(successCallback, errorCallback);

	function successCallback(printers) {
		console.log('found printers: ', printers);
	}

	function errorCallback(error) {
		console.log(error);
	}

	window.plugin.printer.print('content', chosenPrinter, function() {
		console.log('success');
	}, function() {
		console.log('error');
	});

```


## License

This software is released under the [Apache 2.0 License](http://opensource.org/licenses/Apache-2.0).
