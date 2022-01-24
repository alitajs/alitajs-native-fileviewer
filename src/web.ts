import { WebPlugin } from '@capacitor/core';

import type {
  FileViewerPlugin,
  OpenDocumentOptions,
  PreviewImageOptions,
  PreviewImageResult,
} from './definitions';

export class FileViewerWeb extends WebPlugin implements FileViewerPlugin {
  async openDocument(_: OpenDocumentOptions): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  async previewImage(_: PreviewImageOptions): Promise<PreviewImageResult> {
    throw this.unimplemented('Not implemented on web.');
  }
}
