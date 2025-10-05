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
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0,4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12),
            specRow("Diameter", product.diameter),
            specRow("Type", product.type),
            specRow("Material", product.material),
            specRow("Strap", product.strap),
            specRow("Water Resistance", product.waterResistence),
            specRow("Calibre", product.calibre),
          ],
        ),
      ),
    );
  }
}