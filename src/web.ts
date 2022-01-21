import { WebPlugin } from '@capacitor/core';

import type { FileViewerPlugin } from './definitions';

export class FileViewerWeb extends WebPlugin implements FileViewerPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
