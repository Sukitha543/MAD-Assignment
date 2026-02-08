import 'package:flutter/material.dart';
import 'package:mad_assignment/models/product.dart';
import 'package:mad_assignment/widgets/spec_row.dart';

class SpecCard extends StatelessWidget {
  final Product product;

  const SpecCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[100]
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.12),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12),
            SpecRow(title: "Diameter", value: product.diameter),
            SpecRow(title: "Type", value: product.type),
            SpecRow(title: "Material", value: product.material),
            SpecRow(title: "Strap", value: product.strap),
            SpecRow(title: "Water Resistance", value: product.waterResistance),
            SpecRow(title: "Calibre", value: product.caliber),
          ],
        ),
      ),
    );
  }
}
