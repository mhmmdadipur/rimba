part of 'controllers.dart';

class CartController extends GetxController {
  Rx<List> selectedProducts = Rx<List>([]);

  void addToCart(Map product) {
    int index = selectedProducts.value
        .indexWhere((value) => product['id'] == value['id']);

    if (index > -1) {
      // When item has been added before
      selectedProducts
          .update((_) => selectedProducts.value[index]['quantity']++);
    } else {
      // When item has not been added before
      product['quantity'] = 1;
      selectedProducts.update((_) => selectedProducts.value.add(product));
    }
  }

  Future<void> removeFromCart(int index) async {
    selectedProducts.value.removeAt(index);
    List temp = selectedProducts.deepCopy();
    selectedProducts.update((_) => selectedProducts = Rx<List>([]));
    await Future.delayed(const Duration(milliseconds: 10));
    selectedProducts(temp);
  }
}
