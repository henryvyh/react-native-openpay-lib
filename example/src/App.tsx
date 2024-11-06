import { useState, useEffect } from 'react';
import { StyleSheet, View, Text, Button } from 'react-native';
import {
  multiply,
  initOpenpay,
  getDeviceSessionId,
  createToken,
} from 'react-native-openpay-lib';

export default function App() {
  const [result, setResult] = useState<number | undefined>();
  const [inited, setInited] = useState<boolean>(false);
  const [deviceId, setDeviceId] = useState<string | undefined>();
  const [token, setToken] = useState<any | undefined>();

  useEffect(() => {
    multiply(3, 7).then(setResult);
  }, []);

  const handleInit = async () => {
    try {
      const response = await initOpenpay({
        merchantId: 'mpexlotmiibzxkfe6xnd',
        apiKey: 'sk_1f8f58f7552245bb97f026b0cde51015',
        productionMode: false,
      });
      setInited(response);
      console.log('inited', response);
    } catch (error) {
      console.log('Error', error);
    }
  };

  const handleDeviceSessionId = async () => {
    const sessionId = await getDeviceSessionId();
    console.log('Device session id', sessionId);
    setDeviceId(sessionId);
  };

  const handleCreateToken = async () => {
    try {
      console.log('Creating token');
      const resp = await createToken({
        holderName: 'John Doe',
        cardNumber: '4111111111111111',
        cvv: '123',
        expirationMonth: '12',
        expirationYear: '25',
      });
      console.log('Token', resp);
      setToken(resp);
    } catch (error) {
      console.log('Error', error);
    }
  };

  return (
    <View style={styles.container}>
      <Text>Result: {result}</Text>
      {inited ? (
        <View>
          <Button
            title="Get device session id"
            onPress={handleDeviceSessionId}
          />
          <Text>Device session id: {deviceId}</Text>

          <Button title="Create card token" onPress={handleCreateToken} />
          <Text>Card Token: {token}</Text>
        </View>
      ) : (
        <Button title="Init openpay" onPress={handleInit} />
      )}
    </View>
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
