import { NativeModules, Platform } from 'react-native';
import type { Config, HelpCenterOptions } from './types';

const LINKING_ERROR =
  `The package 'react-native-zendesk-support' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const ZendeskSupport = NativeModules.ZendeskSupport
  ? NativeModules.ZendeskSupport
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export function initialize(config: Config): Promise<string> {
  return ZendeskSupport.initialize(config);
}

export function identifyAnonymous(
  name?: string,
  email?: string
): Promise<string> {
  return ZendeskSupport.identifyAnonymous(name, email);
}

export function showHelpCenter(options?: HelpCenterOptions): Promise<string> {
  return ZendeskSupport.showHelpCenter(options);
}
