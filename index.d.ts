declare module 'react-native-openpay-lib' {
  // TODO: Redefines the types
  export const multiply: (a: number, b: number) => Promise<any>;
  export const initOpenpay: (args: any) => Promise<boolean>;
  export const getDeviceSessionId: () => Promise<string>;
  export const createToken: (card: any) => Promise<any>;
}
