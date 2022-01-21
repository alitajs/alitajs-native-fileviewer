import { WebPlugin } from '@capacitor/core';

import type {
  FileViewerPlugin,
  OpenDocumentOptions,
  PreviewImageOptions,
} from './definitions';

export class FileViewerWeb extends WebPlugin implements FileViewerPlugin {
  async openDocument(_: OpenDocumentOptions): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  async previewImage(_: PreviewImageOptions): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }
}
