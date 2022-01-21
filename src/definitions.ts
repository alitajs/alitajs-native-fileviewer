export interface FileViewerPlugin {
  openDocument(options: OpenDocumentOptions): Promise<void>;
  previewImage(options: PreviewImageOptions): Promise<void>;
}

export interface OpenDocumentOptions {
  filePath: string;
}

export interface PreviewImageOptions {
  urls: string[];
  current: number;
}
