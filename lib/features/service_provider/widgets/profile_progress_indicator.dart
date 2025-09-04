import 'package:flutter/material.dart';
import 'package:service_hub/core/utils/app_colors.dart';

class ProfileProgressIndicator extends StatelessWidget {
  final int currentStep;

  const ProfileProgressIndicator({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          ...List.generate(3, (index) {
            return Expanded(
              child: _buildStepIndicator(index),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int index) {
    final isActive = index <= currentStep;
    final isCompleted = index < currentStep;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        if (index < 2) const SizedBox(width: 8),

        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isCompleted
                ? AppColors.secondary
                : isActive
                ? AppColors.primary
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text(
              '${index + 1}',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        if (index < 2) const SizedBox(width: 8),
      ],
    );
  }
}