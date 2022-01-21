# @alitajs/fileviewer

Documents and images viewer

## Install

```bash
npm install @alitajs/fileviewer
npx cap sync
```

## API

<docgen-index>

* [`openDocument(...)`](#opendocument)
* [`previewImage(...)`](#previewimage)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### openDocument(...)

```typescript
openDocument(options: OpenDocumentOptions) => Promise<void>
```

| Param         | Type                                                                |
| ------------- | ------------------------------------------------------------------- |
| **`options`** | <code><a href="#opendocumentoptions">OpenDocumentOptions</a></code> |

--------------------


### previewImage(...)

```typescript
previewImage(options: PreviewImageOptions) => Promise<void>
```

| Param         | Type                                                                |
| ------------- | ------------------------------------------------------------------- |
| **`options`** | <code><a href="#previewimageoptions">PreviewImageOptions</a></code> |

--------------------


### Interfaces


#### OpenDocumentOptions

| Prop           | Type                |
| -------------- | ------------------- |
| **`filePath`** | <code>string</code> |


#### PreviewImageOptions

| Prop          | Type                  |
| ------------- | --------------------- |
| **`urls`**    | <code>string[]</code> |
| **`current`** | <code>number</code>   |

</docgen-api>
