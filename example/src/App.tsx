import * as React from 'react';

import { StyleSheet, View, Text } from 'react-native';
import {
  identifyAnonymous,
  initialize,
  showHelpCenter,
} from 'react-native-zendesk-support';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';

function Home() {
  const [initializeResult, setInitializeResult] = React.useState<string>();
  const [identifyAnonymousResult, setIdentifyAnonymousResult] =
    React.useState<string>();
  const [showHelpCenterResult, setShowHelpCenterResult] =
    React.useState<string>();

  React.useEffect(() => {
    (async () => {
      try {
        const a = await initialize({
          appId: '1e41a02a5f85d58e009ed4fa',
          clientId: 'mobile_sdk_client_e1c4e6262f1d02f43496',
          zendeskUrl: 'https://omniwear.zendesk.com',
        });
        setInitializeResult(a);
      } catch (error) {
        setInitializeResult((error as Error).message);
      }
      try {
        const b = await identifyAnonymous();
        setIdentifyAnonymousResult(b);
      } catch (error) {
        setIdentifyAnonymousResult((error as Error).message);
      }
      try {
        const c = await showHelpCenter();
        setShowHelpCenterResult(c);
      } catch (error) {
        setShowHelpCenterResult((error as Error).message);
      }
    })();
  }, []);

  return (
    <View style={styles.container}>
      <Text>initialize: {initializeResult}</Text>
      <Text>identifyAnonymous: {identifyAnonymousResult}</Text>
      <Text>showHelpCenter: {showHelpCenterResult}</Text>
    </View>
  );
}

const Stack = createNativeStackNavigator();

export default function App() {
  return (
    <NavigationContainer>
      <Stack.Navigator>
        <Stack.Screen name="Home" component={Home} />
      </Stack.Navigator>
    </NavigationContainer>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
