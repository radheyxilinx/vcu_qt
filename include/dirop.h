#ifndef DIROP_H
#define DIROP_H
#include <QObject>
#include <QDir>
#include <QQuickItem>

class DirOp : public QObject
{
    Q_OBJECT
public:
    QDir currentDir;
    QQuickItem *ctx;

public slots :
    QVariantList listDirectory(QString);
    QVariantList previousClick();
    QVariantList changeFolder(QString);
    QVariantList applyTypeFilter(QString);
    QString getFilePath();
};

#endif // DIROP_H
