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

import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.1
import QtCharts 2.0
import Qt.labs.folderlistmodel 2.1
import Qt.labs.folderlistmodel 1.0
import QtQuick 2.2
import QtQuick.Layouts 1.2
import "./"

ApplicationWindow {
    visible: true
    width: 1800
    height: 780
    title: qsTr("VCU TRD 2017.1")
    color: "transparent"
    id: root

    property alias fileinfoListModel: fileList.fileListModel
    property bool play: false
    property bool isPreset: false

    property var errorMessageText: ""
    property var errorNameText: ""
    property var barColors: "#1FF7F7F0"
    property var barTitleColorsPut: "#F0AAAAAA"
    property var cellColor: "#FFEEEEEE"
    property var cellHighlightColor: "#FFAAAAAA"
    property var borderColors: "#F0AAAAAA"
    property int boarderWidths: 1

    property var videoResolution: "4k"
    property var fpsValue: 0

    property var videoInput: 2
    property var presetSelect: 7
    property var plotDisplay: true

    property int bitrate: 10000000
    property var b_frame: 0
    property var enc_name: "omxh264enc"
    property var goP_len: 30
    property int enc_enum: 2

    property var format : "NV12"
    property var num_src : 1
    property var raw : true
    property var src : "v4l2src"
    property var device_type : 1
    property var uri : ""

    property alias presetStructure: presetValues.presetStruct

    PresetProperties{
        id: presetValues
    }

    FontLoader { id: fontFamily; source: "/font/luxisr.ttf" }

    Rectangle {
        visible: true
        width: parent.width
        height: parent.height
        color: root.play? "transparent": "black"

        Rectangle{
            anchors.fill: parent
            color: "transparent"
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    inputSrcLst.showList = false
                    controlLst.showList = false
                    inputRectangle.visible = false
                    controlRectangle.visible = false

                    titleBar.y = 0
                    graphPlot.visible = true
                }
            }

            Rectangle{
                id: titleBar
                y: 0
                anchors{
                    left: parent.left
                    right: parent.right
                }

                height: 90
                color: "lightGray"
                Rectangle{
                    id: logoImg
                    anchors{
                        left: parent.left
                        leftMargin: 0
                        top: parent.top
                        topMargin: 0
                    }
                    width: 160
                    height: 55
                    color: "white"
                    Image{
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectCrop
                        source: "qrc:///images/xilinxLogo.png"
                    }
                }
                Label{
                    id: prjTitle
                    anchors{
                        left: logoImg.right
                        leftMargin: 10
                        right: logo1Img.left
                        rightMargin: 10
                        top: parent.top
                        topMargin: 5
                    }
                    height: 40
                    font.pointSize: 20
                    color: "black"
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: "Zynq UltraScale+ MPSoC VCU Targeted Reference design"
                }
                Image{
                    id: logo1Img
                    anchors{
                        right: parent.right
                        rightMargin: 0
                        top: parent.top
                        topMargin: 0
                    }
                    width: 160
                    height: 55
                    source: "qrc:///images/zynqLogo.png"
                }
                Rectangle{
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.top: prjTitle.bottom
                    anchors.topMargin: 10
                    anchors.bottom: parent.bottom

                    border.color: "gray"
                    color: "transparent"
                    radius: 2

                    Button{
                        id: playBtn
                        anchors{
                            left: parent.left
                            leftMargin: 10
                            top: parent.top
                            topMargin: 5
                            bottom: parent.bottom
                            bottomMargin: 5
                        }

                        width: parent.height
                        height: parent.height-10
                        Image{
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            height: parent.height
                            width: parent.height
                            anchors.fill: parent
                            source: root.play? "qrc:///images/pause.png" :"qrc:///images/play_arrow.png"

                        }
                        style: ButtonStyle{
                            background: Rectangle {
                                implicitWidth: 100
                                implicitHeight: 25
                                border.width: control.activeFocus ? 2 : 1
                                border.color: "#888"
                                radius: 4
                                gradient: Gradient {
                                    GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                                    GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                                }
                            }
                        }
                        onClicked: {
                            inputSrcLst.showList = false
                            controlLst.showList = false
                            inputRectangle.visible = false
                            controlRectangle.visible = false
                            root.play = !root.play;
                            fileList.visible = false
                            encoderDecoderPanel.visible = false
                            if(root.play){
                                controller.updateInputParam(root.format, root.num_src, root.raw, root.src, root.device_type, "file://"+root.uri);
                                controller.updateEncParam(root.bitrate, root.b_frame, root.enc_name, root.goP_len);
                                controller.start_pipeline();
                            }else{
                                controller.stop_pipeline();
                            }
                        }
                    }

                    Row{
                        anchors.left: playBtn.right
                        anchors.leftMargin: 10
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 5
                        spacing: 20

                        Rectangle{
                            width: 130
                            height: parent.height
                            color: "transparent"
                            Label{
                                id: ipSrcLbl
                                text: "<b>Num. of input:</b>"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                anchors{
                                    left: parent.left
                                    leftMargin: 0
                                }
                            }
                            TextField{
                                text: "1"
                                anchors{
                                    left: ipSrcLbl.right
                                    leftMargin: 5
                                }
                                width: 20
                                enabled: false
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }

                        Rectangle{
                            width: 180
                            height: parent.height
                            color: "transparent"
                            Label{
                                anchors.left: parent.left
                                width: 80
                                text: "<b>Input: </b>"
                            }
                            Rectangle{
                                id: inputSrcLst
                                anchors.right: parent.right
                                width: 130
                                height: parent.height
                                color: root.play ? "lightGray" : "gray"
                                property var showList: false
                                property var browseSrc: false
                                enabled: !root.play
                                border.color: "black"
                                border.width: 1
                                radius: 2
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        fileList.visible = false
                                        inputRectangle.visible = !inputRectangle.visible
                                        parent.showList = !parent.showList
                                        encoderDecoderPanel.visible = false
                                        controlRectangle.visible = false
                                        controlLst.showList = false
                                    }
                                }
                                Label{
                                    id: srcNameLbl
                                    anchors.left: parent.left
                                    anchors.leftMargin: 10
                                    height: parent.height
                                    color: "white"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: "Test Pattern"
                                }
                                Image{
                                    anchors.right: parent.right
                                    anchors.rightMargin: 5
                                    width: parent.height
                                    height: parent.height
                                    source: inputSrcLst.showList ? "qrc:///images/upArrow.png" : "qrc:///images/downArrow.png"
                                }

                                Rectangle{
                                    id: inputRectangle
                                    width: inputSrcLst.width
                                    anchors.left: inputSrcLst.left
                                    height: 60
                                    visible: false
                                    border.color: root.borderColors
                                    border.width: root.boarderWidths

                                    clip: true
                                    color: root.barColors
                                    anchors.top: inputSrcLst.bottom
                                    anchors.bottomMargin: 0
                                    MouseArea{
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onExited: {

                                        }
                                    }

                                    OptionsScrollVu{
                                        id: videoSrcOptionsSV
                                        anchors.fill: parent
                                        listModel.model: videoSourceList
                                        selecteItem: root.videoInput
                                        delgate: this
                                        width: parent.width
                                        function clicked(indexval){
                                            inputRectangle.visible = false
                                            inputSrcLst.showList = false
                                            srcNameLbl.text = videoSourceList[indexval].shortName
                                            switch (indexval){
                                            case 0:
                                                fileList.visible = true
                                                root.device_type = 1
                                                break;
                                            case 1:
                                                root.src = "v4l2src"
                                                root.device_type = 2
                                                break;
                                            case 2:
                                                root.src = "v4l2src"
                                                root.device_type = 1
                                                break;
                                            default:
                                                root.src = "v4l2src"
                                                root.device_type = 1
                                            }
                                            root.videoInput = indexval
                                        }
                                    }
                                }
                            }
                        }

                        Rectangle{
                            width: 210
                            height: parent.height
                            color: "transparent"
                            Label{
                                anchors.left: parent.left
                                width: 80
                                text: "<b>Preset: </b>"
                            }
                            Rectangle{
                                id: controlLst
                                anchors.right: parent.right
                                width: 150
                                height: parent.height
                                color: ((root.src == "uridecodebin") || root.play) ? "lightGray" : "gray"
                                enabled: (root.src == "uridecodebin") ? false : !root.play
                                property var showList: false
                                border.color: "black"
                                border.width: 1
                                radius: 2
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        fileList.visible = false
                                        encoderDecoderPanel.visible = false
                                        parent.showList = !parent.showList
                                        controlRectangle.visible = !controlRectangle.visible
                                        inputRectangle.visible = false
                                        inputSrcLst.showList = false
                                    }
                                }
                                Label{
                                    id: presetLbl
                                    anchors.left: parent.left
                                    anchors.leftMargin: 10
                                    height: parent.height
                                    color: "white"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: presetLbl.text = controlList[root.presetSelect].shortName
                                }
                                Image{
                                    anchors.right: parent.right
                                    anchors.rightMargin: 5
                                    width: parent.height
                                    height: parent.height
                                    source: controlLst.showList ? "qrc:///images/upArrow.png" : "qrc:///images/downArrow.png"
                                }

                                Rectangle{
                                    id: controlRectangle
                                    width: parent.width
                                    height: 160
                                    visible: false
                                    anchors.left: parent.left
                                    border.color: root.borderColors
                                    border.width: root.boarderWidths
                                    clip: true
                                    color: root.barColors
                                    anchors.top: parent.bottom

                                    ControlVu{
                                        id: presetList
                                        anchors.fill: parent
                                        listModel.model: controlList
                                        selecteItem: root.presetSelect
                                        delgate: this
                                        width: parent.width
                                        function clicked(indexval){
                                            if(indexval == 7){
                                                root.raw = true
                                                isPreset = false
                                            }else if(indexval == 6){
                                                root.raw = false
                                                isPreset = false
                                                encoderDecoderPanel.visible = true
                                            }else{
                                                root.raw = false
                                                isPreset = true
                                            }
                                            controlRectangle.visible = false
                                            controlLst.showList = false
                                            root.presetSelect = indexval
                                            root.setPresets(indexval)
                                            presetLbl.text = controlList[indexval].shortName
                                        }
                                    }
                                }
                            }
                        }

                        Button{
                            id: controlBtn
                            width: 70
                            height: parent.height
                            text: "Control"
                            enabled: (root.src == "uridecodebin") ? false : !root.play
                            style: ButtonStyle{
                                background: Rectangle {
                                    implicitWidth: 100
                                    implicitHeight: 25
                                    border.width: control.activeFocus ? 2 : 1
                                    border.color: "#888"
                                    radius: 4
                                    gradient: Gradient {
                                        GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                                        GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                                    }
                                }
                            }
                            onClicked: {
                                fileList.visible = false
                                encoderDecoderPanel.visible = !encoderDecoderPanel.visible
                                inputSrcLst.showList = false
                                inputRectangle.visible = false
                                controlLst.showList = false
                                controlRectangle.visible = false
                            }
                        }
                    }

                    Button{
                        id: stopButton
                        anchors{
                            right: parent.right
                            rightMargin: 10
                            top: parent.top
                            topMargin: 5
                            bottom: parent.bottom
                            bottomMargin: 5
                        }

                        width: parent.height
                        height: parent.height-10

                        Image{
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            height: parent.height
                            width: parent.height
                            anchors.fill: parent
                            source: "qrc:///images/close.png"

                        }
                        style: ButtonStyle{
                            background: Rectangle {
                                implicitWidth: 100
                                implicitHeight: 25
                                border.width: control.activeFocus ? 2 : 1
                                border.color: "#888"
                                radius: 4
                                gradient: Gradient {
                                    GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                                    GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                                }
                            }
                        }
                        onClicked: {
                            controller.stop_pipeline();
                            refreshTimer.stop()
                            Qt.quit()
                        }
                    }

                    Button{
                        id: fullScrnButton
                        anchors{
                            right: stopButton.left
                            rightMargin: 10
                            top: parent.top
                            topMargin: 5
                            bottom: parent.bottom
                            bottomMargin: 5
                        }

                        width: parent.height
                        height: parent.height-10
                        Image{
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            height: parent.height-5
                            width: parent.height-5
                            source: "qrc:///images/fullScreen.png"

                        }
                        style: ButtonStyle{
                            background: Rectangle {
                                implicitWidth: 100
                                implicitHeight: 25
                                border.width: control.activeFocus ? 2 : 1
                                border.color: "#888"
                                radius: 4
                                gradient: Gradient {
                                    GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                                    GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                                }
                            }
                        }
                        onClicked: {
                            if(root.play){
                                fileList.visible = false
                                titleBar.y = -100
                                inputRectangle.visible = false
                                controlRectangle.visible = false
                                graphPlot.visible = false
                                encoderDecoderPanel.visible = false
                            }
                        }
                    }

                    RowLayout{
                        anchors{
                            right: fullScrnButton.left
                            rightMargin: 20
                            top: parent.top
                            topMargin: 5
                            bottom: parent.bottom
                            bottomMargin: 5
                        }

                        height: parent.height-10
                        spacing: 10
                        Label{
                            text: "<b>Resolution: </b>" + root.videoResolution
                        }
                        Rectangle{
                            width: 2
                            height: 20
                            color: "darkGray"
                        }
                        Label{
                            text: "<b>Format: </b>" + root.format
                        }
                        Rectangle{
                            width: 2
                            height: 20
                            color: "darkGray"
                        }
                        Label{
                            text: "<b>FPS: </b>" + root.fpsValue
                        }
                        Rectangle{
                            width: 2
                            height: 20
                            color: "darkGray"
                        }
                        Label{
                            text: root.raw ? "<b>Bitrate: </b>NA" :"<b>Bitrate: </b>" + root.bitrate/1000000 + " Mbps"
                        }
                    }
                }
            }

            Rectangle {
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                color: "transparent"
                id: graphPlot
                width: parent.width
                height: 200

                Rectangle {
                    id: cpuUtilizationPlot
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    width: (parent.width-80)/3
                    height: 200 * 1
                    visible: root.plotDisplay
                    border.color: root.borderColors
                    border.width: root.boarderWidths
                    color: "#E9E9E9"
                    ChartView{
                        id: chart_line_CPU
                        anchors.fill: parent
                        theme: ChartView.ChartThemeBlueCerulean
                        antialiasing: true
                        title: "CPU Utilization(%)"

                        ValueAxis {
                            id: axisYcpu
                            min: 0
                            max: 100
                            labelsFont.pointSize: 10 * resoluteFrac
                            labelsColor: "white"
                            gridLineColor: "white"
                            lineVisible: false
                        }
                        ValueAxis {
                            id: axisXcpu
                            min: 0
                            max: 60
                            labelsVisible: false
                            gridLineColor: "white"
                            lineVisible: false
                            labelsFont.pointSize: 1 * resoluteFrac
                        }

                        LineSeries {
                            name: "CPU 1"
                            axisX: axisXcpu
                            axisY: axisYcpu
                        }
                        LineSeries {
                            name: "CPU 2"
                            axisX: axisXcpu
                            axisY: axisYcpu
                            color: "red"
                        }
                        LineSeries {
                            name: "CPU 3"
                            axisX: axisXcpu
                            axisY: axisYcpu
                            color: "green"
                        }
                        LineSeries {
                            name: "CPU 4"
                            axisX: axisXcpu
                            axisY: axisYcpu
                            color: "blue"
                        }
                    }
                }

                Rectangle {
                    id: hpPortUtilizationPlot
                    anchors.left: cpuUtilizationPlot.right
                    anchors.leftMargin: 20
                    width: (parent.width-80)/3
                    height: 200 * 1
                    visible: root.plotDisplay
                    border.color: root.borderColors
                    border.width: root.boarderWidths
                    color: "#E9E9E9"
                    ChartView{
                        anchors.fill: parent
                        theme: ChartView.ChartThemeBlueCerulean
                        antialiasing: true
                        id: encoderBandWidthPlot
                        ValueAxis {
                            id: axisYEncBW
                            min: 0
                            max: 8
                            labelsFont.pointSize: 10 * resoluteFrac
                            labelsColor: "white"
                            gridLineColor: "white"
                            lineVisible: false
                        }
                        ValueAxis {
                            id: axisXEncBW
                            min: 0
                            max: 60
                            labelsVisible: false
                            gridLineColor: "white"
                            lineVisible: false
                            labelsFont.pointSize: 1 * resoluteFrac
                        }


                        LineSeries {
                            axisX: axisXEncBW
                            axisY: axisYEncBW
                            name: "Encoder Bandwidth Utilization(Gbps)"

                        }
                    }
                }
                Rectangle {
                    id: latencyPlot
                    anchors.left: hpPortUtilizationPlot.right
                    anchors.leftMargin: 20
                    width: (parent.width-80)/3
                    height: 200 * 1
                    visible: root.plotDisplay
                    border.color: root.borderColors
                    border.width: root.boarderWidths
                    color: "#E9E9E9"
                    ChartView{
                        anchors.fill: parent
                        theme: ChartView.ChartThemeBlueCerulean
                        antialiasing: true
                        id: decoderBandWidthPlot
                        ValueAxis {
                            id: axisYDecBW
                            min: 0
                            max: 8
                            labelsFont.pointSize: 10 * resoluteFrac
                            labelsColor: "white"
                            gridLineColor: "white"
                            lineVisible: false
                        }
                        ValueAxis {
                            id: axisXDecBW
                            min: 0
                            max: 60
                            labelsVisible: false
                            gridLineColor: "white"
                            lineVisible: false
                            labelsFont.pointSize: 1 * resoluteFrac
                        }

                        LineSeries {
                            axisX: axisXDecBW
                            axisY: axisYDecBW
                            name: "Decoder Bandwidth Utilization(Gbps)"
                        }
                    }
                }

                Behavior on x{
                    NumberAnimation {
                        duration: 500
                        easing.type: Easing.OutSine
                    }
                }
            }
        }

        Timer {
            id: refreshTimer
            interval: 1000
            running: true
            repeat: true
            onTriggered: {
                controller.updatecpu(chart_line_CPU.series(0),chart_line_CPU.series(1),chart_line_CPU.series(2),chart_line_CPU.series(3))
                if(root.play){
                    controller.updateThroughput(encoderBandWidthPlot.series(0),decoderBandWidthPlot.series(0))
                    controller.updateFPS()
                }else{
                    root.fpsValue = 0
                }
            }
        }
    }

    FileListVu{
        id: fileList
        visible: false
    }

    EncDecPanel{
        id: encoderDecoderPanel
        visible: false
    }

    /*Error message*/
    ErrorMessage{
        width: parent.width
        height: parent.height
        id: errorMessage
        messageText: errorMessageText
        errorName: errorNameText
        message.onClicked:{
            errorMessageText = ""
            errorNameText = ""
        }
    }
    function setPresets(index){
        root.b_frame =  presetStructure[index].b_frame
        root.enc_name = presetStructure[index].enc_name
        root.goP_len = presetStructure[index].goP_len
        root.src = presetStructure[index].src
        root.device_type = presetStructure[index].device_type
        root.bitrate = presetStructure[index].bitrate
        root.enc_enum = presetStructure[index].enc_enum
    }
}
