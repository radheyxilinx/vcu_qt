import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle {
    anchors{
        horizontalCenter: parent.horizontalCenter
        verticalCenter: parent.verticalCenter
    }

    width: 480
    height: 320
    color: "#ffffff"
    border.color: "black"
    border.width: 2
    radius: 5

    Label{
        anchors{
            left: parent.left
            leftMargin: 10
            topMargin: 10
            top: parent.top
        }
        text: "Encoder Parameter"
        font.bold: true
        font.pointSize: 13
        width: parent.width
        height: 30
        id: header
    }

    Rectangle{
        anchors{
            left: parent.left
            right: parent.right
            top: header.bottom
        }
        height: 2
        color: "black"
    }

    Label{
        id: bitRateLbl
        anchors{
            left: parent.left
            leftMargin: 10
            top: header.bottom
            topMargin: 10
        }
        width: 110
        height: 25
        verticalAlignment: Text.AlignVCenter
        text: "Bit Rate: "
    }
    TextField{
        id: bitRateTxt
        anchors{
            left: bitRateLbl.right
            leftMargin: 5
            top: header.bottom
            topMargin: 10
        }
        width: 125
        height: 25
        text: "High"
        MouseArea{
            anchors.fill: parent
            onClicked: {
                bitRate.visible = !bitRate.visible
                entropyType.visible = false
                encoderType.visible = false
            }
        }
    }

    Button {
        id: dropButton
        anchors{
            left: bitRateTxt.right
            leftMargin: -2
            bottom: bitRateTxt.bottom
            top: bitRateTxt.top
        }
        width: bitRateTxt.height
        height: bitRateTxt.height
        Image{
            anchors.fill: parent
            source: "qrc:///images/downArrow.png"
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                bitRate.visible = !bitRate.visible
                //                entropyType.visible = false
                encoderType.visible = false
            }
        }
    }

    Rectangle{
        anchors{
            left: parent.left
            right: parent.right
            top: bitRateLbl.bottom
            topMargin: 5
        }
        height: 1
        color: "black"
    }
    /*
    Label {
        anchors{
            left:  parent.left
            leftMargin: 10
            top: bitRateLbl.bottom
            topMargin: 10
        }
        id: gopStructLbl
        width: 110
        height: 25
        verticalAlignment: Text.AlignVCenter
        text: qsTr("GoP Structure: ")
    }


    TextField{
        width: 150
        height: 25
        anchors{
            left:  gopStructLbl.right
            leftMargin: 5
            top: bitRateLbl.bottom
            topMargin: 10
        }
        placeholderText: "length"
        text: "IBBP"

    }
*/
    Rectangle {

        anchors{
            left:  parent.left
            leftMargin: 10
            right: parent.right
            rightMargin: 10
            top: bitRateLbl.bottom
            topMargin: 10
        }
        id: frameSupportBox
        height: 75
        Label{
            text: "Frame Support: "
            height: 20
        }
        /*
        CheckBox {
            id: pFrame
            anchors{
                left: parent.left
                leftMargin: 80
                top: parent.top
                topMargin: 25
            }

            width: 110
            height: 15
            checked: true
            text: qsTr("P-Frame")
            onClicked: getGopStructure()
        }
*/
        CheckBox {
            id: bFrame
            anchors{
                left: parent.left
                leftMargin: 80
                top: parent.top
                topMargin: 25
            }

            width: 110
            height: 15
            text: qsTr("B Frame")
            onClicked: getGopStructure()
        }

        TextField{
            id: framesCountLbl
            anchors{
                left: bFrame.right
                leftMargin: 5
                top: parent.top
                topMargin: 25

            }
            width: 30
            height: 20
            visible: bFrame.checked
            enabled: bFrame.checked

            text: qsTr(framesCount.value.toString())
        }

        Slider {
            id: framesCount
            anchors{
                left: framesCountLbl.right
                leftMargin: 10
                top: parent.top
                topMargin: 25

            }
            visible: bFrame.checked
            //                    anchors.rightMargin: 5
            maximumValue: 4.0
            stepSize: 1.0
            value : 2
            style: SliderStyle {
                groove: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 5
                    color: "gray"
                    radius: 5
                }
            }
        }
    }


    Label {
        id: gopLenLbl
        width: 110
        height: 25
        anchors{
            left:  parent.left
            leftMargin: 10
            top: frameSupportBox.bottom
            topMargin: 10
        }
        text: qsTr("GoP Length: ")
        verticalAlignment: Text.AlignVCenter
    }

    TextField{
        width: 150
        height: 25
        anchors{
            left:  gopLenLbl.right
            leftMargin: 5
            top: frameSupportBox.bottom
            topMargin: 10
        }
        placeholderText: "length"
        text: "30"

    }

    Rectangle{
        anchors{
            left: parent.left
            right: parent.right
            top: gopLenLbl.bottom
            topMargin: 5
        }
        height: 1
        color: "black"
    }
    /*
    Label {
        id: entropyLbl
        anchors{
            left:  parent.left
            leftMargin: 10
            top: gopLenLbl.bottom
            topMargin: 15
        }
        width: 110
        height: 25
        verticalAlignment: Text.AlignVCenter
        text: qsTr("Entropy Type: ")
    }

    TextField{
        id: entropyTxt
        anchors{
            left:  entropyLbl.right
            leftMargin: 5
            top: gopLenLbl.bottom
            topMargin: 10
        }
//        horizontalAlignment: Text.AlignHCenter
        width: 125
        height: 25
        text: "CABAC"
        MouseArea{
            anchors.fill: parent
            onClicked: {
                entropyType.visible = !entropyType.visible
                bitRate.visible = false
                encoderType.visible = false
            }
        }
    }

    Button {
        anchors{
            left: entropyTxt.right
            leftMargin: -2
            bottom: entropyTxt.bottom
            top: entropyTxt.top
        }
        width: entropyTxt.height
        height: entropyTxt.height
        Image{
            anchors.fill: parent
            source: "qrc:///images/downArrow.png"
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                entropyType.visible = !entropyType.visible
                bitRate.visible = false
                encoderType.visible = false
            }
        }
    }
*/
    Label {
        id: encoderLbl
        anchors{
            left:  parent.left
            leftMargin: 10
            top: gopLenLbl.bottom
            topMargin: 15
        }
        width: 110
        height: 25
        verticalAlignment: Text.AlignVCenter
        text: qsTr("Encoder Type: ")
    }

    TextField{
        id: encoderTxt
        anchors{
            left:  encoderLbl.right
            leftMargin: 5
            top: gopLenLbl.bottom
            topMargin: 10
        }
        width: 125
        height: 25
        text: "H264"
        MouseArea{
            anchors.fill: parent
            onClicked: {
                encoderType.visible = !encoderType.visible
                bitRate.visible = false
                //                entropyType.visible = false
            }
        }
    }

    Button {
        anchors{
            left: encoderTxt.right
            leftMargin: -2
            bottom: encoderTxt.bottom
            top: encoderTxt.top
        }
        width: encoderTxt.height
        height: encoderTxt.height
        Image{
            anchors.fill: parent
            source: "qrc:///images/downArrow.png"
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                encoderType.visible = !encoderType.visible
                bitRate.visible = false
                //                entropyType.visible = false
            }
        }
    }

    Button {
        id: okButton
        anchors{
            right: parent.right
            rightMargin: 10
            bottom: parent.bottom
            bottomMargin: 10
        }
        width: 80
        height: 30
        text: qsTr("Ok")
        MouseArea{
            anchors.fill: parent
            onClicked: {
                bitRate.visible = false
                encoderType.visible = false
                //                entropyType.visible = false
                encoderDecoderPanel.visible = false
            }
        }
    }

    Button {
        id: cancelButton
        anchors{
            right: okButton.left
            rightMargin: 20
            bottom: parent.bottom
            bottomMargin: 10
        }
        width: 80
        height: 30
        text: qsTr("Cancel")
        onClicked:{
            bitRate.visible = false
            encoderType.visible = false
            //            entropyType.visible = false
            encoderDecoderPanel.visible = false
        }
    }

    Rectangle{
        id: bitRate
        anchors{
            left: bitRateTxt.left
            top: bitRateTxt.bottom
        }
        visible: false
        width: bitRateTxt.width
        height: 85
        color: "white"
        ColumnLayout{
            width: parent.width
            height: parent.height
            spacing: 1
            Rectangle{
                width: parent.width
                height: parent.height/3-2
                color: "lightGray"
                Label{
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    text: "High"
                    verticalAlignment: Text.AlignVCenter
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        bitRateTxt.text = "High"
                        bitRate.visible = false
                    }
                }
            }

            Rectangle{
                width: parent.width
                height: parent.height/3-2
                color: "lightGray"
                Label{
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    text: "Medium High"
                    verticalAlignment: Text.AlignVCenter
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        bitRateTxt.text = "Medium High"
                        bitRate.visible = false
                    }
                }
            }
            Rectangle{
                width: parent.width
                height: parent.height/3-2
                color: "lightGray"
                Label{
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    text: "Medium"
                    verticalAlignment: Text.AlignVCenter
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        bitRateTxt.text = "Medium"
                        bitRate.visible = false
                    }
                }
            }
            Rectangle{
                width: parent.width
                height: parent.height/3-2
                color: "lightGray"
                Label{
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    text: "Medium Low"
                    verticalAlignment: Text.AlignVCenter
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        bitRateTxt.text = "Medium Low"
                        bitRate.visible = false
                    }
                }
            }
            Rectangle{
                width: parent.width
                height: parent.height/3-2
                color: "lightGray"
                Label{
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    text: "Low"
                    verticalAlignment: Text.AlignVCenter
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        bitRateTxt.text = "Low"
                        bitRate.visible = false
                    }
                }
            }
        }
    }

    /*
    Rectangle{
        id: entropyType
        anchors{
            left: entropyTxt.left
            top: entropyTxt.bottom
        }
        visible: false
        width: entropyTxt.width
        height: 40
        color: "white"
        ColumnLayout{
            width: parent.width
            height: parent.height
            spacing: 1
            Rectangle{
                width: parent.width
                height: parent.height/2
                color: "lightGray"
                Label{
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    text: "CABAC"
//                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        entropyTxt.text = "CABAC"
                        entropyType.visible = false
                    }
                }
            }

            Rectangle{
                width: parent.width
                height: parent.height/2
                color: "lightGray"
                Label{
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    text: "CAVLC"
//                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        entropyTxt.text = "CAVLC"
                        entropyType.visible = false
                    }
                }
            }
        }
    }
*/

    Rectangle{
        id: encoderType
        anchors{
            left: encoderTxt.left
            top: encoderTxt.bottom
        }
        visible: false
        width: encoderTxt.width
        height: 40
        color: "white"
        ColumnLayout{
            width: parent.width
            height: parent.height
            spacing: 1
            Rectangle{
                width: parent.width
                height: parent.height/2
                color: "lightGray"
                Label{
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    text: "H264"
                    verticalAlignment: Text.AlignVCenter
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        encoderTxt.text = "H264"
                        encoderType.visible = false
                    }
                }
            }

            Rectangle{
                width: parent.width
                height: parent.height/2
                color: "lightGray"
                Label{
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    text: "H265"
                    verticalAlignment: Text.AlignVCenter
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        encoderTxt.text = "H265"
                        encoderType.visible = false
                    }
                }
            }
        }
    }
    function getGopStructure(){

    }
}
