import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:bus2/src/models/models.dart';

import 'package:bus2/core/core.dart';

import '../view_models/view_models.dart';

class UserDetailsView extends StatefulWidget {
  const UserDetailsView({super.key});

  @override
  State<UserDetailsView> createState() => _UserDetailsViewState();
}

class _UserDetailsViewState extends State<UserDetailsView>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final UserDetailsViewModel viewModel;

  bool get isPersisted => viewModel.isPersisted;

  @override
  void initState() {
    super.initState();
    viewModel = ContainerInjector().find<UserDetailsViewModel>()..onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text('Detalhes'),
        actions: [
          ListenableBuilder(
            listenable: viewModel,
            builder: (_, __) {
              return IconButton(
                tooltip: isPersisted ? 'Remover dos salvos' : 'Salvar',
                icon: Icon(
                  isPersisted ? Icons.bookmark : Icons.bookmark_outline,
                ),
                onPressed: isPersisted
                    ? () => viewModel.onRemovePersistedUser()
                    : () => viewModel.onPersistUser(),
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(listenable: viewModel, builder: _buildState),
    );
  }

  Widget _buildState(BuildContext context, Widget? child) {
    final user = viewModel.user;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: Header(user: user)),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          sliver: SliverList.list(
            children: [
              SectionCard(
                title: 'Identidade',
                children: [
                  InfoRow(
                    'Nome',
                    '${user.name.title} ${user.name.first} ${user.name.last}',
                  ),
                  InfoRow('Username', '@${user.login.username}'),
                  InfoRow('Nacionalidade', user.nat),
                ],
              ),
              SectionCard(
                title: 'Contato',
                children: [
                  InfoRow.tapToCopy(
                    context,
                    'E-mail',
                    user.email,
                    copyValue: user.email,
                    icon: Icons.mail_outline,
                  ),
                  InfoRow.tapToCopy(
                    context,
                    'Telefone',
                    user.phone,
                    copyValue: user.phone,
                    icon: Icons.call_outlined,
                  ),
                  InfoRow.tapToCopy(
                    context,
                    'Celular',
                    user.cell,
                    copyValue: user.cell,
                    icon: Icons.smartphone_outlined,
                  ),
                ],
              ),
              SectionCard(
                title: 'Endereço',
                children: [
                  InfoRow(
                    'Rua',
                    '${user.location.street.number} ${user.location.street.name}',
                  ),
                  InfoRow('Cidade', user.location.city),
                  InfoRow('Estado', user.location.state),
                  InfoRow('País', user.location.country),
                  InfoRow('CEP', '${user.location.postcode}'),
                ],
              ),
              SectionCard(
                title: 'Conta',
                children: [
                  InfoRow('Registrado em', user.registered.date),
                  InfoRow(
                    'Nascimento',
                    user.dob.date,
                    trailing: '(${user.dob.age} anos)',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Header extends StatelessWidget {
  final UserModel user;

  const Header({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Hero(
            tag: user.id.name,
            child: CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(user.picture.thumbnail),
              onBackgroundImageError: (_, __) {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.name.title} ${user.name.first} ${user.name.last}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '@${user.login.username} · ${user.nat}',
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SectionCard({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(top: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ..._withDividers(children),
          ],
        ),
      ),
    );
  }

  List<Widget> _withDividers(List<Widget> items) {
    final out = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      out.add(items[i]);
      if (i != items.length - 1) {
        out.add(const Divider(height: 12, thickness: 0.6));
      }
    }
    return out;
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final String? trailing;
  final IconData? icon;
  final VoidCallback? onTap;

  const InfoRow(
    this.label,
    this.value, {
    this.trailing,
    this.icon,
    this.onTap,
    super.key,
  });

  factory InfoRow.tapToCopy(
    BuildContext context,
    String label,
    String value, {
    required String copyValue,
    IconData? icon,
  }) {
    return InfoRow(
      label,
      value,
      icon: icon,
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: copyValue));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Copiado para a área de transferência'),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Padding(
            padding: const EdgeInsets.only(top: 2, right: 8),
            child: Icon(icon, size: 18),
          ),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                value.isEmpty ? '-' : value,
                style: textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (trailing != null)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(trailing!, style: textTheme.bodySmall),
          ),
      ],
    );

    if (onTap == null) return row;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: row,
    );
  }
}
