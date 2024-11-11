import 'package:flutter/material.dart';
import 'PaymentFormPage.dart';

class PaymentPage extends StatelessWidget {
  final List<Map<String, dynamic>> cart;
  final Function(Map<String, dynamic>) onRemoveFromCart;

  PaymentPage({required this.cart, required this.onRemoveFromCart});

  @override
  Widget build(BuildContext context) {
    // Print the contents of the cart to debug
    print("Cart Contents: $cart");

    // Calculate the total cost
    double totalCost = cart.fold(0, (sum, item) => sum + (item['price'] ?? 0));

    // Function to clear the cart
    void clearCart() {
      cart.clear(); // Clear all items from the cart
      Navigator.pop(context); // Navigate back after clearing
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Page'),
      ),
      body: cart.isEmpty
          ? Center(child: Text('Your cart is empty!', style: TextStyle(fontSize: 18)))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final course = cart[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(
                      course['title'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Price: \$${course['price']}"),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        onRemoveFromCart(course);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${totalCost.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.grey[200],
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: EdgeInsets.symmetric(vertical: 16.0),
          ),
          onPressed: () {
            // Debugging: Check cart contents before proceeding to payment
            print('Cart contents: $cart'); // Print the entire cart

            // Check if cart is not empty
            if (cart.isNotEmpty) {
              var firstCourse = cart[0]; // Get the first course
              var courseId = firstCourse['_id']; // Get the '_id' of the first course

              print('First course ID: $courseId'); // Print the course ID

              // Proceed only if the course ID is not null
              if (courseId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentFormPage(
                      totalCost: totalCost,
                      onPaymentSuccess: () {
                        clearCart(); // Clear cart after payment success
                      },
                      courseId: courseId,  // Pass the valid course ID to the next page
                    ),
                  ),
                );
              } else {
                print('Course ID is null!'); // Print if the course ID is missing
              }
            } else {
              print('Cart is empty!'); // Print if the cart is empty
            }
          },

          child: Text(
            'Proceed to Payment',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
