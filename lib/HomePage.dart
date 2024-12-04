import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'ImageDetailPage.dart';
import 'ImageProviderModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ImageProviderModel>(context, listen: false).fetchImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImageProviderModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          // Top Tab bar
          Container(
            height: 50,
            decoration: const BoxDecoration(
              color: Colors.black,
              border: Border(bottom: BorderSide(color: Colors.black, width: 0.5)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Activity',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  'Community',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  'Shop',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              child: const Text(
                'All Products',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Consumer<ImageProviderModel>(
              builder: (context, provider, _) {
                if (provider.images.isEmpty && provider.isLoading) {
                  // Show initial loading indicator
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification.metrics.pixels ==
                        scrollNotification.metrics.maxScrollExtent) {
                      provider.fetchImages();
                    }
                    return true;
                  },
                  child: MasonryGridView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: provider.images.length + 1,
                    gridDelegate:
                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      if (index == provider.images.length) {
                        return provider.isLoading
                            ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                            : const SizedBox.shrink();
                      }
                      final image = provider.images[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ImageDetailPage(imageUrl: image['url']),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 2,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Lazy loading of images
                          FadeInImage(
                          placeholder: AssetImage('lib/assets/img.png'),
                          image: NetworkImage(image['url']),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 250,
                          placeholderFit: BoxFit.contain,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error, size: 250);
                          },
                        ),

                          const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Product Name',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding:
                                EdgeInsets.only(left: 8.0, bottom: 8.0),
                                child: Text(
                                  '\$32',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
