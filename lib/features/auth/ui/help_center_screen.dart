import 'package:flutter/material.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';

class _FaqEntry {
  final String category;
  final String question;
  final String answer;
  const _FaqEntry({required this.category, required this.question, required this.answer});
}

// Placeholder Q&A — swap in your real support content.
const List<_FaqEntry> _kFaqs = [
  _FaqEntry(
    category: 'General',
    question: 'How do I track my order?',
    answer: 'Open the Orders tab, find your active order, and tap Track Driver to see live tracking.',
  ),
  _FaqEntry(
    category: 'General',
    question: 'How do I cancel an order?',
    answer: "Go to Orders, open the order you'd like to cancel, and tap Cancel Order. "
        "We'll ask you for a quick reason.",
  ),
  _FaqEntry(
    category: 'General',
    question: 'How do I save a dish to my favorites?',
    answer: 'Tap the heart icon on any dish from the Home screen or the Menu to add it to your Favorites tab.',
  ),
  _FaqEntry(
    category: 'General',
    question: 'How do I reorder something I got before?',
    answer: 'Open Orders > Completed, open the order, and tap Order Again — you can adjust the quantity first.',
  ),
  _FaqEntry(
    category: 'General',
    question: 'Is my order tracked in real time?',
    answer: "Tracking in this app is a demo simulation. It's not connected to a live courier yet.",
  ),
  _FaqEntry(
    category: 'Account',
    question: 'How do I update my profile details?',
    answer: 'Open your account settings from the profile menu to update your name, email, or photo.',
  ),
  _FaqEntry(
    category: 'Account',
    question: 'How do I change my password?',
    answer: 'Go to Account Settings > Security to update your password.',
  ),
  _FaqEntry(
    category: 'Account',
    question: 'How do I delete my account?',
    answer: 'Contact customer service from the Contact Us tab and we can help with that.',
  ),
  _FaqEntry(
    category: 'Services',
    question: 'What payment methods are accepted?',
    answer: 'This is a demo app, so no real payments are processed.',
  ),
  _FaqEntry(
    category: 'Services',
    question: 'Can I schedule a delivery for later?',
    answer: 'Scheduled delivery is not available yet, but it is on our roadmap.',
  ),
  _FaqEntry(
    category: 'Services',
    question: 'Do you deliver outside the city?',
    answer: 'Delivery areas depend on the restaurant you order from — check the restaurant details for its service area.',
  ),
];

class _ContactChannel {
  final IconData icon;
  final String title;
  final String detail;
  const _ContactChannel({required this.icon, required this.title, required this.detail});
}

// Placeholder contact details — replace with your real support channels.
const List<_ContactChannel> _kContactChannels = [
  _ContactChannel(icon: Icons.headset_mic, title: 'Customer service', detail: '+1 (555) 010-0143'),
  _ContactChannel(icon: Icons.public, title: 'Website', detail: 'www.yourrestaurant.example.com'),
  _ContactChannel(icon: Icons.chat, title: 'Whatsapp', detail: '+1 (555) 010-0143'),
  _ContactChannel(icon: Icons.facebook, title: 'Facebook', detail: 'facebook.com/yourrestaurant'),
  _ContactChannel(icon: Icons.camera_alt_outlined, title: 'Instagram', detail: '@yourrestaurant'),
];

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  int _topTab = 0; // 0 = FAQ, 1 = Contact Us
  int _category = 0; // 0 General, 1 Account, 2 Services
  String _query = '';
  final Set<String> _expandedFaqs = {};
  final Set<String> _expandedContacts = {};

  static const _categories = ['General', 'Account', 'Services'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.headerYellow,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 20, 4),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                  ),
                  Expanded(
                    child: Text('Help Center', textAlign: TextAlign.center, style: AppTextStyles.headerTitle),
                  ),
                  const SizedBox(width: 28),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'How Can We Help You?',
                style: AppTextStyles.body.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: _PillTab(label: 'FAQ', selected: _topTab == 0, onTap: () => setState(() => _topTab = 0)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _PillTab(
                              label: 'Contact Us',
                              selected: _topTab == 1,
                              onTap: () => setState(() => _topTab = 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: _topTab == 0 ? _buildFaqTab() : _buildContactTab()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqTab() {
    final filtered = _kFaqs
        .where((f) => f.category == _categories[_category])
        .where((f) => _query.isEmpty || f.question.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      children: [
        Row(
          children: List.generate(_categories.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _PillTab(
                label: _categories[index],
                selected: _category == index,
                onTap: () => setState(() => _category = index),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        TextField(
          onChanged: (value) => setState(() => _query = value),
          decoration: InputDecoration(
            hintText: 'Search',
            filled: true,
            fillColor: AppColors.fieldFill,
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 16),
        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text('No results found.', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
          )
        else
          ...filtered.map((faq) => _ExpandableRow(
                title: faq.question,
                isExpanded: _expandedFaqs.contains(faq.question),
                onTap: () => setState(() {
                  if (!_expandedFaqs.remove(faq.question)) _expandedFaqs.add(faq.question);
                }),
                child: Text(faq.answer, style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
              )),
      ],
    );
  }

  Widget _buildContactTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      children: _kContactChannels
          .map((c) => _ExpandableRow(
                icon: c.icon,
                title: c.title,
                isExpanded: _expandedContacts.contains(c.title),
                onTap: () => setState(() {
                  if (!_expandedContacts.remove(c.title)) _expandedContacts.add(c.title);
                }),
                child: Row(
                  children: [
                    Expanded(child: Text(c.detail, style: AppTextStyles.body.copyWith(color: AppColors.textSecondary))),
                    TextButton(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${c.title}: ${c.detail}')),
                      ),
                      child: const Text('Copy'),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class _PillTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _PillTab({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.peachCircle,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: selected ? Colors.white : AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _ExpandableRow extends StatelessWidget {
  final IconData? icon;
  final String title;
  final bool isExpanded;
  final VoidCallback onTap;
  final Widget child;
  const _ExpandableRow({
    this.icon,
    required this.title,
    required this.isExpanded,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: AppColors.primary, size: 20),
                  const SizedBox(width: 10),
                ],
                Expanded(child: Text(title, style: AppTextStyles.heading.copyWith(fontSize: 14))),
                Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.primary),
              ],
            ),
          ),
        ),
        if (isExpanded) Padding(padding: const EdgeInsets.only(bottom: 12), child: child),
        const Divider(height: 1),
      ],
    );
  }
}