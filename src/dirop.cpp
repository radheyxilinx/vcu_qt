#include "dirop.h"
#include <QDebug>

QVariantList DirOp:: listDirectory(QString fileType){

    currentDir.setFilter(QDir :: Dirs | QDir::Files);
    QFileInfoList list = currentDir.entryInfoList();

    if(fileType != ""){
        currentDir.setNameFilters(QStringList()<<fileType);
        list = currentDir.entryInfoList();
    }

    QVariantList qfileList;
    for(int i = 0; i < list.size(); i++){

        QVariantMap map;
        map.insert("itemName", list.at(i).fileName());
        map.insert("itemType", list.at(i).isDir()? QVariant(true):false);

        qfileList.append(map);
    }
    return qfileList;
}

QVariantList DirOp:: previousClick(){
    currentDir.cdUp();
    return listDirectory("");
}
QVariantList DirOp ::changeFolder(QString dir){
    currentDir.cd(dir);
    return listDirectory("");
}

QString DirOp :: getFilePath(){
    return currentDir.absolutePath();
}

QVariantList DirOp ::applyTypeFilter(QString fileType){
    return listDirectory(fileType);
}
