# helix_indicator

A customizable animated Helix indicator widget for Flutter.

## Features

- Smooth animation.
- Customizable color, size, and padding.
- Easy to integrate.

## Usage

    class MyApp extends StatelessWidget {
    	const MyApp({super.key});

    	@override
    	Widget build(BuildContext context) {
    		return MaterialApp(
    			title: 'Her OS Loader',
    			theme: ThemeData.dark(),
    			home: const Scaffold(
    				backgroundColor: Color(0xffd1684e),
    				body: Center(
    					child: HelixIndicator(color: Colors.white, size: 150),
    				),
    			),
    		);
    	}
    }

## License

MIT
