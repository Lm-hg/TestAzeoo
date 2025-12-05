import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import '../../domain/models/user.dart';

class ProfilePage extends ConsumerStatefulWidget {
  final int userId;

  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeTile(UserBadge badge) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.emoji_events, color: Colors.amber, size: 32),
        title: Text(badge.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(badge.description, maxLines: 2, overflow: TextOverflow.ellipsis),
      ),
    );
  }

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header avec photo et infos principales
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: user.profilePicture != null && user.profilePicture!.isNotEmpty
                                    ? NetworkImage(user.profilePicture!)
                                    : null,
                                child: user.profilePicture == null || user.profilePicture!.isEmpty
                                    ? Text(
                                        user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : '?',
                                        style: const TextStyle(fontSize: 32),
                                      )
                                    : null,
                              ),
                              if (user.countryFlag.isNotEmpty)
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundImage: NetworkImage(user.countryFlag),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            user.fullName,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.info,
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          if (user.city.isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(user.city, style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    const Divider(),
                    
                    // Statistiques
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatCard('Points', user.points.toString(), Icons.star, Colors.amber),
                        _buildStatCard('Followers', user.followersCount.toString(), Icons.people, Colors.blue),
                        _buildStatCard('Workouts', user.workoutsCount.toString(), Icons.fitness_center, Colors.green),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Compte et email
                    _buildInfoTile(Icons.email, 'Email', user.email),
                    _buildInfoTile(Icons.card_membership, 'Type de compte', user.accountType.toUpperCase()),
                    
                    const SizedBox(height: 24),
                    
                    // Badges
                    if (user.badges.isNotEmpty) ...[
                      const Text(
                        'Badges récents',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      ...user.badges.map((badge) => _buildBadgeTile(badge)),
                    ],
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
