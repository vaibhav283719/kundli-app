import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../../domain/entities/profile_entity.dart';
import '../../../../config/constants/app_constants.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profiles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/edit-profile'),
          ),
        ],
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: LoadingWidget());
          }

          if (provider.profiles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('👤', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  Text(
                    'No profiles yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add birth details to generate Kundli charts',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Add Profile',
                    onPressed: () => context.push('/edit-profile'),
                    useGradient: true,
                    icon: Icons.add,
                    width: 200,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.profiles.length,
            itemBuilder: (context, index) {
              return _ProfileCard(
                profile: provider.profiles[index],
                onEdit: () =>
                    context.push('/edit-profile?id=${provider.profiles[index].id}'),
                onDelete: () => _confirmDelete(context, provider, provider.profiles[index]),
                onSetPrimary: () => provider.setPrimary(provider.profiles[index].id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/edit-profile'),
        backgroundColor: AppConstants.primarySaffron,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Profile', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    ProfileProvider provider,
    ProfileEntity profile,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Profile'),
        content: Text('Are you sure you want to delete ${profile.name}\'s profile?'),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ctx.pop();
              provider.deleteProfile(profile.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final ProfileEntity profile;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetPrimary;

  const _ProfileCard({
    required this.profile,
    required this.onEdit,
    required this.onDelete,
    required this.onSetPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(profile.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      onDismissed: (_) => onDelete(),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppConstants.primarySaffron.withOpacity(0.15),
                  child: profile.photoUrl != null
                      ? ClipOval(
                          child: Image.network(
                            profile.photoUrl!,
                            errorBuilder: (_, __, ___) => _DefaultAvatar(profile.name),
                          ),
                        )
                      : _DefaultAvatar(profile.name),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            profile.name,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (profile.isPrimary) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppConstants.primarySaffron,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Primary',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (profile.birthDetails != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${profile.birthDetails!.formattedDate} • ${profile.birthDetails!.placeOfBirth}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                      if (profile.notes != null && profile.notes!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          profile.notes!,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                // Actions
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit': onEdit();
                      case 'delete': onDelete();
                      case 'primary': onSetPrimary();
                    }
                  },
                  itemBuilder: (ctx) => [
                    const PopupMenuItem(value: 'edit', child: ListTile(
                      leading: Icon(Icons.edit_outlined),
                      title: Text('Edit'),
                    )),
                    if (!profile.isPrimary)
                      const PopupMenuItem(value: 'primary', child: ListTile(
                        leading: Icon(Icons.star_outline),
                        title: Text('Set as Primary'),
                      )),
                    const PopupMenuItem(value: 'delete', child: ListTile(
                      leading: Icon(Icons.delete_outlined, color: Colors.red),
                      title: Text('Delete', style: TextStyle(color: Colors.red)),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DefaultAvatar extends StatelessWidget {
  final String name;

  const _DefaultAvatar(this.name);

  @override
  Widget build(BuildContext context) {
    return Text(
      name.isNotEmpty ? name[0].toUpperCase() : '?',
      style: const TextStyle(
        color: AppConstants.primarySaffron,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
