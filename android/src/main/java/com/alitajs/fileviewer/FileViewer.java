package com.alitajs.fileviewer;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.util.Log;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.FileProvider;

import com.getcapacitor.JSObject;
import com.getcapacitor.PluginCall;

import java.io.File;
import java.util.List;

public class FileViewer {

    AppCompatActivity activity;

    public FileViewer(AppCompatActivity activity) {
        this.activity = activity;
    }

    private boolean isInstall(Context context, String packageName) {
        final PackageManager packageManager = context.getPackageManager();
        // 获取所有已安装程序的包信息
        List<PackageInfo> pinfo = packageManager.getInstalledPackages(0);
        for (int i = 0; i < pinfo.size(); i++) {
            if (pinfo.get(i).packageName.equalsIgnoreCase(packageName))
                return true;
        }
        return false;
    }

    public void openDoc(File file, PluginCall call){
        Uri uri = Uri.fromFile(file);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            //通过FileProvider创建一个content类型的Uri
            uri = FileProvider.getUriForFile(activity, activity.getPackageName() + ".fileprovider", file);
        }
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        if (isInstall(activity, "cn.wps.moffice_eng")) {
            intent.setClassName("cn.wps.moffice_eng",
                    "cn.wps.moffice.documentmanager.PreStartActivity2");
            intent.setData(uri);
        } else {
            intent.addCategory(Intent.CATEGORY_DEFAULT);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_DOCUMENT);
            intent.setDataAndType(uri, getFileType(file.getAbsolutePath()));
        }
        activity.startActivity(Intent.createChooser(intent, "打开"));
        call.resolve();
    }

    /**
     * 判断文件类型
     */
    private static String getFileType(String fName) {
        String type = "";
        /* 取得扩展名 */
        String end = fName.substring(fName.lastIndexOf(".") + 1, fName.length()).toLowerCase();
        /* 依扩展名的类型决定MimeType */
        if (end.equals("pdf")) {
            type = "application/pdf";
        } else if (end.equals("m4a") || end.equals("mp3") || end.equals("mid") ||
                end.equals("xmf") || end.equals("ogg") || end.equals("wav")) {
            type = "audio/*";
        } else if (end.equals("3gp") || end.equals("mp4")) {
            type = "video/*";
        } else if (end.equals("jpg") || end.equals("gif") || end.equals("png") ||
                end.equals("jpeg") || end.equals("bmp")) {
            type = "image/*";
        } else if (end.equals("apk")) {
            type = "application/vnd.android.package-archive";
        } else if (end.equals("pptx") || end.equals("ppt")) {
            type = "application/vnd.ms-powerpoint";
        } else if (end.equals("docx") || end.equals("doc")) {
            type = "application/vnd.ms-word";
        } else if (end.equals("xlsx") || end.equals("xls")) {
            type = "application/vnd.ms-excel";
        } else if (end.equals("txt")) {
            type = "text/plain";
        } else if (end.equals("html") || end.equals("htm")) {
            type = "text/html";
        } else {
            //如果无法直接打开，就跳出软件列表给用户选择
            type = "*/*";
        }
        return type;
    }

}
