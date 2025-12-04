import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

class ProfilePage extends ConsumerStatefulWidget {
  final int userId;

  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final asyncUser = ref.watch(userProvider(widget.userId));

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: asyncUser.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
        data: (user) {
          final messenger = ScaffoldMessenger.of(context);
          return RefreshIndicator(
            onRefresh: () async {
              try {
                await ref.read(userRepositoryProvider).refreshUser(widget.userId);
                final _ = ref.refresh(userProvider(widget.userId));
              } catch (e) {
                messenger.showSnackBar(SnackBar(content: Text('Erreur lors du rafraîchissement: $e')));
              }
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    CircleAvatar(
                      radius: 48,
                      backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
                      child: user.avatarUrl == null ? Text(user.firstName.isNotEmpty ? user.firstName[0] : '') : null,
                    ),
                    const SizedBox(height: 16),
                    Text(user.fullName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('ID: ${user.id}'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
