import React, { FC, useState } from 'react';
import styles from './index.less';
import { Http } from '@capacitor-community/http';
import { FileViewer } from '@alitajs/fileviewer';
import { Filesystem, Directory } from '@capacitor/filesystem';
import { Toast } from 'antd-mobile';

interface HomePageProps {}

const HomePage: FC<HomePageProps> = () => {
  const [url, setUrl] = useState(
    'https://www2.deloitte.com/content/dam/Deloitte/cn/Documents/consumer-business/deloitte-cn-cb-brand-customer-experience-in-now-consumer-zh-210507.pdf',
  );

  const [filePath, setFilePath] = useState('');
  const startDownload = async () => {
    const fileName = url.split('/').pop();
    const dir = 'Download';
    const path = `Download/${fileName}`;
    try {
      await Filesystem.mkdir({ path: dir, directory: Directory.Documents });
    } catch (error) {}
    try {
      await Filesystem.deleteFile({ path: path, directory: Directory.Documents });
    } catch (error: any) {
      alert(error.message);
    }
    try {
      Toast.show({ icon: 'loading', duration: 0 });
      const result = await Http.downloadFile({
        filePath: path,
        fileDirectory: Directory.Documents,
        url: url,
      });
      setFilePath(result.path || '');
      Toast.clear();
    } catch (error: any) {
      Toast.clear();
      alert(error.message);
    }
  };
  const openDocument = async () => {
    Toast.show({ icon: 'loading', duration: 0 });
    await FileViewer.openDocument({ filePath: filePath });
    Toast.clear();
  };
  return (
    <div className={styles.page}>
      <div className={styles.item}>
        <label style={{ display: 'block' }}>文件地址</label>
        <input
          className={styles.input}
          type="text"
          value={url}
          onChange={(e) => {
            setUrl(e.target.value);
          }}
        ></input>
      </div>
      <div style={{ paddingTop: 10 }}>
        <button onClick={startDownload}>下载文件</button>
        <button onClick={openDocument}>打开文件</button>
      </div>
      <div className={styles.item}>
        <label>本地路径</label>
        <code>{filePath}</code>
      </div>
    </div>
  );
};

export default HomePage;
