// lib/features/payment/presentation/widgets/payment_method_card.dart
import 'package:flutter/material.dart';

import '../../domain/entities/payment_method.dart';

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethod paymentMethod;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onSetDefault;

  const PaymentMethodCard({
    Key? key,
    required this.paymentMethod,
    required this.onDelete,
    required this.onEdit,
    required this.onSetDefault,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Card details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Card icon (Visa, Mastercard, etc.)
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: paymentMethod.type == 'Credit'
                        ? Colors.purple.withOpacity(0.1)
                        : Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    paymentMethod.type == 'Credit' ? Icons.credit_card : Icons.credit_card,
                    color: paymentMethod.type == 'Credit' ? Colors.purple : Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                // Card details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${paymentMethod.type} Card',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (paymentMethod.isDefault) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Default',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '**** **** **** ${paymentMethod.last4Digits}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Expires: ${paymentMethod.expiryDate}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Edit button
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: onEdit,
                ),
              ],
            ),
          ),
          // Divider
          const Divider(height: 1),
          // Actions
          Row(
            children: [
              // Delete button
              Expanded(
                child: TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              // Vertical divider
              Container(
                height: 24,
                width: 1,
                color: Colors.grey[300],
              ),
              // Set as default button
              Expanded(
                child: TextButton.icon(
                  onPressed: paymentMethod.isDefault ? null : onSetDefault,
                  icon: Icon(
                    Icons.check_circle_outline,
                    color: paymentMethod.isDefault ? Colors.grey : Colors.green,
                  ),
                  label: Text(
                    'Set as Default',
                    style: TextStyle(
                      color: paymentMethod.isDefault ? Colors.grey : Colors.green,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}