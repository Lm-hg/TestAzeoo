import React, { useState, useEffect } from 'react';
import { View, Text, TextInput, Button, StyleSheet, Alert } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import AzeooFlutter from '../native/AzeooFlutter';

const STORAGE_KEY = '@azeoo_user_id';

export default function InputScreen({ navigation }: any) {
  const [userId, setUserId] = useState<string>('1');

  useEffect(() => {
    (async () => {
      const s = await AsyncStorage.getItem(STORAGE_KEY);
      if (s) setUserId(s);
    })();
  }, []);

  async function save() {
    if (!/^[0-9]+$/.test(userId)) {
      Alert.alert('userId invalide', 'Entrez un entier positif');
      return;
    }
    await AsyncStorage.setItem(STORAGE_KEY, userId);
    try {
      const ok = await AzeooFlutter.openProfile(parseInt(userId, 10));
      if (!ok) {
        console.warn('AzeooFlutter.openProfile returned false');
        Alert.alert('Attention', "L'ouverture du profil natif a échoué (voir console).");
      } else {
        navigation.navigate('Profile');
      }
    } catch (e) {
      console.warn('Error calling AzeooFlutter.openProfile', e);
      Alert.alert('Erreur', 'Impossible d appeler le module natif');
    }
  }

  return (
    <View style={styles.container}>
      <Text style={styles.label}>Entrez un userId</Text>
      <TextInput
        style={styles.input}
        value={userId}
        onChangeText={setUserId}
        keyboardType="number-pad"
        accessibilityLabel="userId-input"
      />
      <Button title="Sauvegarder" onPress={save} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, padding: 16, justifyContent: 'center' },
  label: { fontSize: 16, marginBottom: 8 },
  input: { borderWidth: 1, borderColor: '#ccc', padding: 8, marginBottom: 12, borderRadius: 4 },
});
