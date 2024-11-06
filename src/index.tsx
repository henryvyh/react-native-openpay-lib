import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-openpay-lib' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const OpenpayLib = NativeModules.OpenpayLib
  ? NativeModules.OpenpayLib
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export function multiply(a: number, b: number): Promise<number> {
  return OpenpayLib.multiply(a, b);
}

export async function initOpenpay(args: Args): Promise<boolean> {
  return await OpenpayLib.initOpenpay(args);
}
export async function getDeviceSessionId(): Promise<string> {
  return await OpenpayLib.getDeviceSessionId();
}
export async function createToken(card: Card): Promise<any> {
  return await OpenpayLib.createToken(card);
}

export type Args = {
  merchantId: string;
  apiKey: string;
  productionMode: boolean;
};

export type Card = {
  holderName: string;
  cardNumber: string;
  cvv: string;
  expirationMonth: string;
  expirationYear: string;
};
