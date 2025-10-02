import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sasha_botique/features/products/domain/entities/products.dart';

class QuantitySelectorDialog extends StatefulWidget {
  final Product product;
  final String? initialSize;
  final Function(Product product, String size, int quantity) onAddToCart;

  const QuantitySelectorDialog({
    Key? key,
    required this.product,
    this.initialSize,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  State<QuantitySelectorDialog> createState() => _QuantitySelectorDialogState();
}

class _QuantitySelectorDialogState extends State<QuantitySelectorDialog> {
  int _quantity = 1;
  String? _selectedSize;
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.initialSize ??
        (widget.product.sizes.isNotEmpty ? widget.product.sizes.first : null);
    _quantityController.text = _quantity.toString();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _updateQuantity(int newQuantity) {
    if (newQuantity >= 1 && newQuantity <= 99) {
      setState(() {
        _quantity = newQuantity;
        _quantityController.text = _quantity.toString();
      });
    }
  }

  void _onQuantityTextChanged(String value) {
    final parsed = int.tryParse(value);
    if (parsed != null && parsed >= 1 && parsed <= 99) {
      setState(() {
        _quantity = parsed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add to Cart'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.product.name,
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),

            // Size Selection
            if (widget.product.sizes.isNotEmpty) ...[
              Text(
                'Size:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: widget.product.sizes.map((size) {
                  final isSelected = _selectedSize == size;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedSize = size),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              isSelected ? Colors.black : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        size,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // Quantity Selection
            Text(
              'Quantity:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  onPressed: _quantity > 1
                      ? () => _updateQuantity(_quantity - 1)
                      : null,
                  icon: const Icon(Icons.remove_circle_outline),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                Container(
                  width: 80,
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ],
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                    ),
                    onChanged: _onQuantityTextChanged,
                  ),
                ),
                IconButton(
                  onPressed: _quantity < 99
                      ? () => _updateQuantity(_quantity + 1)
                      : null,
                  icon: const Icon(Icons.add_circle_outline),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Min: 1, Max: 99',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _selectedSize != null
              ? () {
                  widget.onAddToCart(widget.product, _selectedSize!, _quantity);
                  Navigator.of(context).pop();
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          child: const Text('Add to Cart'),
        ),
      ],
    );
  }
}
