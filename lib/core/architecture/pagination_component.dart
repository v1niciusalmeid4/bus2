import 'package:flutter/material.dart';

class PaginationComponent<T> extends StatefulWidget {
  final int itemCount;
  final bool reachMax;

  final Function() onFetch;
  final Function() onPullRefresh;
  final Widget Function(BuildContext context, int index) builder;

  final bool reverse;
  final bool pullRefresh;
  final bool separated;
  final ScrollController? scrollController;

  const PaginationComponent({
    required this.itemCount,
    required this.reachMax,
    required this.onFetch,
    required this.onPullRefresh,
    required this.builder,
    this.separated = false,
    this.reverse = false,
    this.pullRefresh = true,
    this.scrollController,
    super.key,
  });

  @override
  State<PaginationComponent> createState() => _PaginationComponentState();
}

class _PaginationComponentState extends State<PaginationComponent> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = widget.scrollController ?? ScrollController()
      ..addListener(onScrollChanged);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void onScrollChanged() {
    bool isOnBottomOfScrollList =
        scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange;

    if (isOnBottomOfScrollList && !widget.reachMax) {
      widget.onFetch();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.pullRefresh) {
      return ListView.builder(
        reverse: widget.reverse,
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        itemCount: widget.itemCount + 1,
        itemBuilder: (context, index) {
          if (index == widget.itemCount) {
            if (widget.reachMax) {
              return const SizedBox.shrink();
            }
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          return widget.builder(context, index);
        },
      );
    }

    return RefreshIndicator.adaptive(
      onRefresh: () async {
        widget.onPullRefresh();
      },
      child: ListView.separated(
        reverse: widget.reverse,
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        itemCount: widget.itemCount + 1,
        itemBuilder: (context, index) {
          if (index == widget.itemCount) {
            if (widget.reachMax) {
              return const SizedBox.shrink();
            }
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          return widget.builder(context, index);
        },
        separatorBuilder: (BuildContext context, int index) => Divider(),
      ),
    );
  }
}
