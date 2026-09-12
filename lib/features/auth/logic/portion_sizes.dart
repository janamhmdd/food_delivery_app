class PortionSize {
  final String label;
  final double extraPrice;
  const PortionSize(this.label, this.extraPrice);
}

/// Cosmetic, single-select portion sizes (Figma "Personal portion").
/// The API has no serving-size concept, so this only adjusts the
/// locally-displayed total — it isn't sent with the order.
const List<PortionSize> kPortionSizes = [
  PortionSize('Personal (4 Slices)', 0.00),
  PortionSize('Medium (8 Slices)', 3.00),
  PortionSize('Familiar (10 Slices)', 6.00),
  PortionSize('Jumbo (12 Slices)', 10.00),
];