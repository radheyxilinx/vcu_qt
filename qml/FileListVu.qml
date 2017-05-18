import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.0

Rectangle{
    onVisibleChanged: {
        if(visible){
            var lst = dirOPS.changeFolder("/")
            updateTable(lst)
        }
    }

    id: browseVU
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    property alias fileListModel: listView.model
    property var fileName: ""
    width: 600
    height: 400
    color: "lightGray"
    radius: 2
    border.color: "gray"

    Button{
        id: prevDirBtn
        anchors{
            left: parent.left
            leftMargin: 10
            top: parent.top
            topMargin: 10
        }
        width: 25
        height: 25
        Image {
            anchors.centerIn: parent
            source: "qrc:///images/backFolder.png"
            anchors.fill: parent
        }
        style: ButtonStyle{
            background: Rectangle{
                color: "transparent"
            }
        }
        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor

            onExited: {

            }
            onClicked:{
                dirOPS.applyTypeFilter("*")
                var lst = dirOPS.previousClick()
                updateTable(lst)
                fileName = ""
            }
        }
    }

    Rectangle{
        anchors{
            left: prevDirBtn.right
            leftMargin: 10
            right: parent.right
            rightMargin: 10
            top: parent.top
            topMargin: 10
        }
        height: 25
        color: "white"
        Label{
            height: parent.height
            color: "black"
            id: filePathLbl
            verticalAlignment: Text.AlignVCenter
        }
    }

    Rectangle{
        anchors{
            left: parent.left
            right: parent.right
            top: prevDirBtn.bottom
            topMargin: 3
        }
        height: 2
        color: "black"
    }

    TableView {
        id: listView
        clip: true
        anchors{
            left: parent.left
            leftMargin: 5
            right: parent.right
            rightMargin: 5
            top: prevDirBtn.bottom
            topMargin: 5
            bottom: openBtn.top
            bottomMargin: 2
        }
        TableViewColumn {
            role: "icon"
            title: ""
            width: 20
            delegate: Image {
                fillMode: Image.PreserveAspectFit
                height:20
                cache : true;
                asynchronous: true;
                source:  styleData.value
            }
            resizable: false
            movable: false
        }
        TableViewColumn {
            role: "itemName"
            title: "Title"
            width: 200
            movable: false
        }
        model: libraryModel

        Component {
            id: folderImageDelegate
            Item {
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    fillMode: Image.PreserveAspectFit
                    height:20
                    cache : true;
                    asynchronous: true;
                    source:  "qrc:///images/folder.png"
                }
            }
        }

        Component {
            id: fileImageDelegate
            Item {
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    fillMode: Image.PreserveAspectFit
                    height:20
                    cache : true;
                    asynchronous: true;
                    source:  "qrc:///images/textFile.png"
                }
            }
        }

        onClicked: {
            if(!libraryModel.get(row).itemType){
                fileName = libraryModel.get(row).itemName
            }else{
                fileName = ""
            }
        }
        ListModel {
            id: libraryModel
        }
        onDoubleClicked: {

            if(libraryModel.get(row).itemType){
                var lst = dirOPS.changeFolder(libraryModel.get(row).itemName)
                updateTable(lst)
            }else{
                root.uri = filePathLbl.text + "/" + libraryModel.get(row).itemName
                root.src = "uridecodebin"
                fileList.visible = false
            }
        }
    }

    Button{
        id: cancelBtn
        anchors{
            right: openBtn.left
            rightMargin: 20
            bottom: parent.bottom
            bottomMargin: 10
        }
        width: 100
        height: 30
        text: "Cancel"
        style: ButtonStyle{
            background: Rectangle{
            }
        }
        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor

            onExited: {

            }
            onClicked:{
                fileList.visible = false
                fileName = ""
                dirOPS.applyTypeFilter("*")
            }
        }
    }

    Button{
        id: openBtn
        anchors{
            right: parent.right
            rightMargin: 10
            bottom: parent.bottom
            bottomMargin: 10
        }
        width: 100
        height: 30
        text: "Open"
        style: ButtonStyle{
            background: Rectangle{
            }
        }
        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor

            onExited: {

            }
            onClicked:{
                if(fileName.length){
                    root.uri = filePathLbl.text + "/" + fileName
                    root.src = "uridecodebin"
                    fileList.visible = false
                    dirOPS.applyTypeFilter("*")
                }else{
                    dirOPS.applyTypeFilter("*")
                }
            }
        }
    }
    TextField{
        id: filterType
        anchors{
            left: parent.left
            leftMargin: 10
            right: cancelBtn.left
            rightMargin: 10
            bottom: parent.bottom
            bottomMargin: 10
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                dirOPS.applyTypeFilter("*.so")
            }
        }
    }

    function setFilePath(){
        filePathLbl.text = dirOPS.getFilePath()
    }
    function updateTable(lst){
        libraryModel.clear()
        for(var i = 0; i <lst.length; i++){
            libraryModel.append({"itemName": lst[i].itemName, "itemType": lst[i].itemType,"icon": (lst[i].itemType ? "qrc:///images/folder.png" : "qrc:///images/textFile.png")});
        }
        setFilePath()
    }
}
