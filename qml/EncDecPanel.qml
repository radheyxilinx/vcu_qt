/******************************************************************************
 * (c) Copyright 2017 Xilinx, Inc. All rights reserved.
 *
 * This file contains confidential and proprietary information of Xilinx, Inc.
 * and is protected under U.S. and international copyright and other
 * intellectual property laws.
 *
 * DISCLAIMER
 * This disclaimer is not a license and does not grant any rights to the
 * materials distributed herewith. Except as otherwise provided in a valid
 * license issued to you by Xilinx, and to the maximum extent permitted by
 * applicable law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL
 * FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS,
 * IMPLIED, OR STATUTORY, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
 * MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE;
 * and (2) Xilinx shall not be liable (whether in contract or tort, including
 * negligence, or under any other theory of liability) for any loss or damage
 * of any kind or nature related to, arising under or in connection with these
 * materials, including for any direct, or any indirect, special, incidental,
 * or consequential loss or damage (including loss of data, profits, goodwill,
 * or any type of loss or damage suffered as a result of any action brought by
 * a third party) even if such damage or loss was reasonably foreseeable or
 * Xilinx had been advised of the possibility of the same.
 *
 * CRITICAL APPLICATIONS
 * Xilinx products are not designed or intended to be fail-safe, or for use in
 * any application requiring fail-safe performance, such as life-support or
 * safety devices or systems, Class III medical devices, nuclear facilities,
 * applications related to the deployment of airbags, or any other applications
 * that could lead to death, personal injury, or severe property or
 * environmental damage (individually and collectively, "Critical
 * Applications"). Customer assumes the sole risk and liability of any use of
 * Xilinx products in Critical Applications, subject only to applicable laws
 * and regulations governing limitations on product liability.
 *
 * THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE
 * AT ALL TIMES.
 *******************************************************************************/

import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle {
    property int tmpBitrate: 10000000
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

    MouseArea{
        anchors.fill: parent
        onClicked: {
            bitRate.visible = false
            encoderType.visible = false
        }
    }
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
    RowLayout{
        anchors{
            right: parent.right
            rightMargin: 20
            top: parent.top
            topMargin: 10
        }
        height: 30
        ExclusiveGroup { id: frameTypeGroup }

        RadioButton {
            id: radioButton
            checked: true
            text: qsTr("Raw")
            exclusiveGroup: frameTypeGroup
            onClicked: root.raw = true
        }

        RadioButton {
            id: radioButton1
            text: qsTr("Processed")
            exclusiveGroup: frameTypeGroup
            onClicked: root.raw = false
        }
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
        text: "Low"
        enabled: !root.raw
        MouseArea{
            anchors.fill: parent
            onClicked: {
                bitRate.visible = !bitRate.visible
//                entropyType.visible = false
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
        enabled: !root.raw
        width: bitRateTxt.height
        height: bitRateTxt.height
        Image{
            anchors.fill: parent
            source: bitRate.visible ? "qrc:///images/upArrow.png" : "qrc:///images/downArrow.png"
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
            enabled: !root.raw
            width: 110
            height: 15
            text: qsTr("B Frame")
            onClicked: {
                bitRate.visible = false
                encoderType.visible = false
            }
        }
        Rectangle{
            id: framesCountLblContainer
            anchors{
                left: bFrame.right
                leftMargin: 5
                top: parent.top
                topMargin: 25

            }
            visible: bFrame.checked
            width: 30
            height: 20
            border.color: "black"
            border.width: 1
            Label{
                id: framesCountLbl
                anchors.fill: parent
                visible: bFrame.checked
                enabled: !root.raw
                text: qsTr(framesCount.value.toString())
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }

        Slider {
            id: framesCount
            anchors{
                left: framesCountLblContainer.right
                leftMargin: 10
                top: parent.top
                topMargin: 25

            }
            enabled: !root.raw
            visible: bFrame.checked
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

    Rectangle{
        width: 100
        height: 25
        id: goPLenTxtRect
        anchors{
            left:  gopLenLbl.right
            leftMargin: 5
            top: frameSupportBox.bottom
            topMargin: 10
        }
        enabled: !root.raw
        border.color: "black"
        Label{
            width: parent.width-4
            height: parent.height-4
            id: goPLenTxt
            anchors{
                left:  parent.left
                leftMargin: 2
                top: parent.top
                topMargin: 2
            }
            text: qsTr(gopLengthCount.value.toString())
            verticalAlignment: Text.AlignVCenter
        }
    }
    Slider {
        id: gopLengthCount
        anchors{
            left: goPLenTxtRect.right
            leftMargin: 10
            top: frameSupportBox.bottom
            topMargin: 10

        }
        enabled: !root.raw
        maximumValue: 1000
        minimumValue: 10
        stepSize: 1.0
        value : 30
        style: SliderStyle {
            groove: Rectangle {
                implicitWidth: 220
                implicitHeight: 5
                color: "gray"
                radius: 5
            }
        }
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
        enabled: !root.raw
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
        enabled: !root.raw
        width: encoderTxt.height
        height: encoderTxt.height
        Image{
            anchors.fill: parent
            source: encoderType.visible ? "qrc:///images/upArrow.png" : "qrc:///images/downArrow.png"
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

                root.b_frame = bFrame.checked? framesCount.value :2
                root.goP_len = goPLenTxt.text
                root.enc_name = "omx" + encoderTxt.text.toLowerCase() + "enc"
                root.raw = false
                root.bitrate = tmpBitrate
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
        width: bitRateTxt.width+dropButton.width-5
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
                        tmpBitrate = 100000000
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
                        tmpBitrate = 50000000
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
                        tmpBitrate = 30000000
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
                        tmpBitrate = 20000000
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
                        tmpBitrate = 10000000
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
        width: encoderTxt.width+dropButton.width-5
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
}
