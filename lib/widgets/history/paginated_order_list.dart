import 'package:flutter/material.dart';
import '../../controllers/history_controller.dart';
import '../../core/theme/app_colors.dart';
import 'order_card.dart';

class PaginatedOrderList extends StatefulWidget {
  final List orders;
  final HistoryController controller;

  const PaginatedOrderList({
    super.key,
    required this.orders,
    required this.controller,
  });

  @override
  State<PaginatedOrderList> createState() => _PaginatedOrderListState();
}

class _PaginatedOrderListState extends State<PaginatedOrderList> {
  static const int _pageSize = 5;
  int _currentCount = _pageSize;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(PaginatedOrderList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.orders != widget.orders) {
      setState(() => _currentCount = _pageSize);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_isLoadingMore &&
        _currentCount < widget.orders.length) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      setState(() {
        _currentCount =
            (_currentCount + _pageSize).clamp(0, widget.orders.length);
        _isLoadingMore = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleOrders = widget.orders.take(_currentCount).toList();
    final hasMore = _currentCount < widget.orders.length;

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      itemCount: visibleOrders.length + (hasMore || _isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < visibleOrders.length) {
          return OrderCard(
            order: visibleOrders[index],
            controller: widget.controller,
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: _isLoadingMore
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: AppColors.primaryRed,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Scroll untuk memuat lebih banyak',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
          ),
        );
      },
    );
  }
}