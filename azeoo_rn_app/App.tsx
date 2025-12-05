/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import InputScreen from './src/screens/InputScreen';
import FlutterProfileScreen from './src/screens/FlutterProfileScreen.tsx';

const Tab = createBottomTabNavigator();

export default function App() {
  return (
    <NavigationContainer>
      <Tab.Navigator screenOptions={{ headerShown: false }}>
        <Tab.Screen name="Input" component={InputScreen} />
        <Tab.Screen name="Profile" component={FlutterProfileScreen} />
      </Tab.Navigator>
    </NavigationContainer>
  );
}
