import { NativeModules } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';

const NATIVE: any = (NativeModules as any).AzeooFlutter;
const STORAGE_KEY = 'azeoo_user_id';

async function openProfile(userId: number): Promise<boolean> {
  await AsyncStorage.setItem(STORAGE_KEY, String(userId));
  if (NATIVE && typeof NATIVE.openProfile === 'function') {
    try {
      const res = NATIVE.openProfile(userId);
      if (res && typeof res.then === 'function') {
        await res;
      }
      return true;
    } catch (e) {
      console.warn('[AzeooFlutter] native openProfile failed', e);
      return false;
    }
  } else {
    console.log('[AzeooFlutter] native module unavailable — running mock');
    return true;
  }
}

async function getSavedUserId(): Promise<number | null> {
  const v = await AsyncStorage.getItem(STORAGE_KEY);
  return v ? parseInt(v, 10) : null;
}

export default { openProfile, getSavedUserId };
