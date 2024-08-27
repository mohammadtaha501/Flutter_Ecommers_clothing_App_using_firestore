import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testapp/overlays.dart';
import 'main_screen.dart';


class OrderOverlay extends StatefulWidget {
  final Item item;
  const OrderOverlay({super.key, required this.item});
  @override
  State<OrderOverlay> createState() => _OrderOverlayState();
}

class _OrderOverlayState extends State<OrderOverlay> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  void _submitOrder() async {
    final name = _nameController.text;
    final email = _emailController.text.isEmpty ? '' : _emailController.text;
    final address = _addressController.text;

    if (name.isEmpty && address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and Address are required')),
      );
      return;
    }

    // Simulating waiting screen
    waitingScreen.show(context: context);

    // Send data to Firebase Firestore
    await FirebaseFirestore.instance.collection('orders').add({
      'name': name,
      'email': email,
      'address': address,
      'documentId':widget.item.documentId,
    });

    // Simulating done screen
    waitingScreen.close();
    doneScreen.show(context: context);
    await Future.delayed(Duration(seconds: 1));
    doneScreen.close();

    Navigator.of(context).pop(); // Close the overlay
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order submitted successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9, // Full width with padding
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(labelText: 'Address'),
                  ),
                ],
              ),
            ),
            OverflowBar(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the overlay
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _submitOrder,
                  child: Text('Order'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailPage extends StatefulWidget {
  final Item item;
  const ProductDetailPage({super.key, required this.item});
  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {

  @override
  Widget build(BuildContext context) {
    final List<String> links=widget.item.imageUrl;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel
            SizedBox(
              height: 300.0,
              child: PageView.builder(
                itemCount: links.length,
                itemBuilder: (context, index) {
                  return Image.network(links[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            // Product Title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Stylish ${widget.item.category}',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Product Price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Rs${widget.item.price}',
                  style: const TextStyle(
                  fontSize: 22.0,
                  color: Colors.red,
                ),
              ),
            ),
            // Product Rating
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < 4 ? Icons.star : Icons.star_border,
                    color: index < 4 ? Colors.yellow[700] : Colors.grey,
                  );
                },
              ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${widget.item.description} ',
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
            // Add to Cart and Buy Now buttons
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return OrderOverlay(item:widget.item);
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    ),
                    child: const Text('Buy Now'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
