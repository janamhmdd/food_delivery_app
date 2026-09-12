import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../domain/entities/menu_item.dart';
import '../logic/generic_add_ons.dart';
import '../logic/item_details_cubit.dart';
import '../logic/item_details_state.dart';
import '../logic/cart_cubit.dart';
import '../logic/portion_sizes.dart';
import '../domain/pseudo_discount.dart';


class ItemDetailsScreen extends StatelessWidget {
  final MenuItem item;
  const ItemDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
     create: (_) => ItemDetailsCubit(item),
     child: _ItemDetailsView(item: item),
    );
  }
}

class _ItemDetailsView extends StatefulWidget {
  final MenuItem item;
  const _ItemDetailsView({required this.item});

  @override
  State<_ItemDetailsView> createState() => _ItemDetailsViewState();
}

class _ItemDetailsViewState extends State<_ItemDetailsView> {
  bool _isFavorite = false; // cosmetic only — no favorites field/endpoint exists

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
     builder: (context, state) {
     final cubit = context.read<ItemDetailsCubit>();
     return Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              _Header(
                item: widget.item,
                isFavorite: _isFavorite,
                onFavoriteToggle: () => setState(() => _isFavorite = !_isFavorite),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: widget.item.imageUrl,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (_, _) =>
                                  Container(height: 180, color: AppColors.peachCircle),
                              errorWidget: (_, _, _) => Container(
                                height: 180,
                                color: AppColors.peachCircle,
                                child: Icon(Icons.fastfood, color: AppColors.primary, size: 40),
                              ),
                            ),
                            if (hasPseudoDiscount(widget.item.itemId))
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                                  child: const Text(
                                    '-30%',
                                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${widget.item.itemPrice.toStringAsFixed(2)}',
                                style: AppTextStyles.heading.copyWith(color: AppColors.primary, fontSize: 22),
                              ),
                              if (hasPseudoDiscount(widget.item.itemId)) ...[
                                const SizedBox(width: 8),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  child: Text(
                                    '\$${(widget.item.itemPrice / 0.7).toStringAsFixed(2)}',
                                    style: AppTextStyles.body.copyWith(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          _QuantityStepper(
                            quantity: state.quantity,
                            onIncrement: cubit.incrementQuantity,
                            onDecrement: cubit.decrementQuantity,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.item.itemDescription.isNotEmpty
                            ? widget.item.itemDescription
                            : 'No description available.',
                        style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 20),
                      Text('Portion size', style: AppTextStyles.heading.copyWith(fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(
                        'Cosmetic — adjusts the total shown here, not sent with your order',
                        style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, fontSize: 11),
                      ),
                      const SizedBox(height: 8),
                      ...kPortionSizes.map((portion) => _PortionRow(
                            portion: portion,
                            isSelected: state.selectedPortion == portion.label,
                            onTap: () => cubit.selectPortion(portion.label),
                          )),
                      const SizedBox(height: 20),
                      Text('Add on ingredients', style: AppTextStyles.heading.copyWith(fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(
                        'Optional — for display only, not sent with your order',
                        style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, fontSize: 11),
                      ),
                      const SizedBox(height: 8),
                      ...kGenericAddOns.map((addOn) => _AddOnRow(
                            addOn: addOn,
                            isSelected: state.selectedAddOns.contains(addOn.name),
                            onTap: () => cubit.toggleAddOn(addOn.name),
                          )),
                      const SizedBox(height: 90),
                    ],
                  ),
                ),
              ),
            ],
          ),
        bottomNavigationBar: Padding(
         padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
         child: AppButton(
         text: 'Add to Cart · \$${cubit.displayTotal.toStringAsFixed(2)}',
         onPressed: () {
          context.read<CartCubit>().addItem(widget.item, quantity: state.quantity);
         ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to cart!')),
      );
      Navigator.of(context).pop();
    },
  ),
),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final MenuItem item;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const _Header({required this.item, required this.isFavorite, required this.onFavoriteToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.headerYellow,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        bottom: 16,
        left: 8,
        right: 16,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(
              item.itemName,
              style: AppTextStyles.headerTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: onFavoriteToggle,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: AppColors.primary,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _QuantityStepper({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StepButton(icon: Icons.remove, onTap: onDecrement),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('$quantity', style: AppTextStyles.heading.copyWith(fontSize: 16)),
        ),
        _StepButton(icon: Icons.add, onTap: onIncrement),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 14,
        backgroundColor: AppColors.primary,
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}

class _PortionRow extends StatelessWidget {
  final PortionSize portion;
  final bool isSelected;
  final VoidCallback onTap;

  const _PortionRow({required this.portion, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(portion.label, style: AppTextStyles.body),
            ),
            Text(
              '\$${portion.extraPrice.toStringAsFixed(2)}',
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(width: 10),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: AppColors.primary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddOnRow extends StatelessWidget {
  final AddOn addOn;
  final bool isSelected;
  final VoidCallback onTap;

  const _AddOnRow({required this.addOn, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(addOn.name, style: AppTextStyles.body),
            ),
            Text(
              '\$${addOn.price.toStringAsFixed(2)}',
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(width: 10),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: AppColors.primary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}