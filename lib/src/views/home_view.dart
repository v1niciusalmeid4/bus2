import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:bus2/core/core.dart';
import 'package:bus2/src/view_models/view_models.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late HomeViewModel viewModel;
  late Ticker ticker;

  Duration _previousElapsed = Duration.zero;
  int _accumulatedMs = 0;

  static const int _intervalMs = 5000;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    viewModel = ContainerInjector().find<HomeViewModel>()..onInit();

    ticker = onCreateTicker;

    ticker.start();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    ticker.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ticker.start();
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      ticker.stop();
    }
    super.didChangeAppLifecycleState(state);
  }

  Ticker get onCreateTicker {
    return createTicker((elapsed) {
      final delta = elapsed - _previousElapsed;
      _previousElapsed = elapsed;

      _accumulatedMs += delta.inMilliseconds;

      if (_accumulatedMs >= _intervalMs) {
        onTickUsers();
        _accumulatedMs = _accumulatedMs % _intervalMs;
      }
    });
  }

  Future<void> onTickUsers() async {
    await viewModel.loadMore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Usuarios')),
      body: ListenableBuilder(listenable: viewModel, builder: _buildState),
      floatingActionButton: FloatingActionButton(
        onPressed: () => viewModel.toPersistedUsers(),
        child: Icon(Icons.bookmark),
      ),
    );
  }

  Widget _buildState(BuildContext context, Widget? child) {
    if (viewModel.loading) {
      return Center(child: CircularProgressIndicator.adaptive());
    }

    if (viewModel.error) {
      return buildError(context);
    }

    return buildData(context);
  }

  Widget buildData(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final user = viewModel.users[index];

        final addr = [
          user.location.city,
          user.location.state,
          user.location.country,
        ].join(', ');

        return GestureDetector(
          onTap: () => viewModel.toUserDetails(user),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(user.picture.thumbnail),
                  ),
                  title: Text(
                    '${user.name.title} ${user.name.first} ${user.name.last}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '@${user.login.username} · ${user.nat}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.mail_outline),
                    const SizedBox(width: 8),
                    Expanded(child: Text(user.email)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.place_outlined),
                    const SizedBox(width: 8),
                    Expanded(child: Text(addr)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.call_outlined),
                    const SizedBox(width: 8),
                    Expanded(child: Text(user.phone)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      itemCount: viewModel.users.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }

  Widget buildError(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(viewModel.failureMessage ?? ''),
          ElevatedButton(
            onPressed: () async => await viewModel.onInit(),
            child: Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}
