# react-native-zendesk-support

react-native-zendesk-support

## Overview

Limited React Native wrapper around the [classic Zendesk Support SDK](https://developer.zendesk.com/documentation/classic-web-widget-sdks/#support-sdk).

- Minimum iOS version: 11
- Minimum Android version: API level 21 (Lollipop/5.0)

## Installation

```sh
npm install @metalpay/react-native-zendesk-support
```

## Usage

```js
import {
  identifyAnonymous,
  initialize,
  showHelpCenter,
} from 'react-native-zendesk-support';

// ...

// 1 - initialize the Zendesk client
await initialize({
  appId: 'appId',
  clientId: 'clientId',
  zendeskUrl: 'zendeskUrl',
});

// 2 - identify the user
await identifyAnonymous(
  'name', // optional
  'email' // optional
);

// ...

// 3 - show the help center
const result = await showHelpCenter(
  {
    subject: 'subject',
    tags: ['tag1', 'tag2', 'tag3'],
    hideContactSupport: false,
    groupType: 2, // 0: DEFAULT, 1: SECTION, 2: CATEGORY
    groupIds: [123, 456], // array of section/category IDs
  } // optional
);
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
