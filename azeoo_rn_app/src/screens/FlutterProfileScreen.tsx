import React, { useEffect, useState, useCallback } from 'react';
import { View, Text, StyleSheet, Image } from 'react-native';
import { useIsFocused } from '@react-navigation/native';
import AzeooFlutter from '../native/AzeooFlutter';

const USERS: Record<number, { firstName: string; lastName: string; email: string; avatar?: string }> = {
  1: { firstName: 'Jean', lastName: 'Dupont', email: 'jean.dupont@example.com', avatar: '' },
  3: { firstName: 'Marie', lastName: 'Curie', email: 'marie.curie@example.com', avatar: '' },
};

export default function FlutterProfileScreen() {
  const [userId, setUserId] = useState<number | null>(null);
  const [user, setUser] = useState<typeof USERS[number] | null>(null);
  const isFocused = useIsFocused();

  const refresh = useCallback(async () => {
    const id = await AzeooFlutter.getSavedUserId();
    if (id) {
      setUserId(id);
      try {
        await AzeooFlutter.openProfile(id);
      } catch (e) {
        console.warn('AzeooFlutter.openProfile failed', e);
      }
      const found = USERS[id];
      setUser(found ?? { firstName: 'Inconnu', lastName: String(id), email: '' });
    } else {
      setUserId(null);
      setUser(null);
    }
  }, []);

  useEffect(() => {
    if (isFocused) refresh();
  }, [isFocused, refresh]);

  return (
    <View style={styles.container}>
      <Text style={styles.hint}>Onglet 2 — Profil utilisateur</Text>
      {user ? (
        <View style={styles.profile}>
          {user.avatar ? (
            <Image source={{ uri: user.avatar }} style={styles.avatar} />
          ) : (
            <View style={styles.avatarPlaceholder} />
          )}
          <Text style={styles.name}>{user.firstName} {user.lastName}</Text>
          {user.email ? <Text style={styles.email}>{user.email}</Text> : null}
          <Text style={styles.small}>userId: {userId}</Text>
          <Text style={styles.note}>Si le module natif Flutter est lié, il affichera l'écran Flutter réel.</Text>
        </View>
      ) : (
        <Text style={styles.sub}>Aucun userId enregistré. Entrez un id sur l'onglet Entrée.</Text>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, padding: 16, justifyContent: 'center', alignItems: 'center' },
  hint: { fontSize: 16, marginBottom: 8 },
  sub: { fontSize: 14, color: '#555' },
  profile: { alignItems: 'center' },
  avatar: { width: 96, height: 96, borderRadius: 48, marginBottom: 12 },
  avatarPlaceholder: { width: 96, height: 96, borderRadius: 48, backgroundColor: '#ddd', marginBottom: 12 },
  name: { fontSize: 18, fontWeight: '600' },
  email: { fontSize: 14, color: '#666' },
  small: { fontSize: 12, color: '#888', marginTop: 6 },
  note: { fontSize: 11, color: '#999', marginTop: 8, textAlign: 'center', paddingHorizontal: 12 },
});
