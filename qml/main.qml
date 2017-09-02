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

import QtQuick 2.0

ApplicationWindow {
    visible: true
    width: 1800
    height: 780
    title: qsTr("VCU TRD 2017.1")
    color: "transparent"
    id: root

    ConfigProperty{
        id: configuration
    }

    property alias fileinfoListModel: fileList.fileListModel
    property bool play: configuration.play
    property bool errorFound: configuration.errorFound

    property var errorMessageText: configuration.errorMessageText
    property var errorNameText: configuration.errorNameText
    property var barColors: configuration.barColors
    property var barTitleColorsPut: configuration.barTitleColorsPut
    property var cellColor: configuration.cellColor
    property var cellHighlightColor: configuration.cellHighlightColor
    property var borderColors: configuration.borderColors
    property int boarderWidths: configuration.boarderWidths

    property var videoResolution: configuration.videoResolution
    property var fpsValue:configuration.fpsValue

    property var videoInput: configuration.videoInput
    property var presetSelect: configuration.presetSelect
    property var outputSelect: configuration.outputSelect
    property var plotDisplay: configuration.plotDisplay

    property var bitrate: configuration.bitrate
    property var bitrateUnit: configuration.bitrateUnit
    property var b_frame: configuration.b_frame
    property var enc_name: configuration.enc_name
    property var goP_len: configuration.goP_len
    property int enc_enum: configuration.enc_enum
    property var profile: configuration.profile
    property var qpMode: configuration.qpMode
    property var rateControl: configuration.rateControl
    property var l2Cache: configuration.l2Cache
    property var sliceCount: configuration.sliceCount
    property var ipAddress: configuration.ipAddress
    property bool isStreamUp: configuration.isStreamUp
    property var hostIP: configuration.hostIP
    property var port: configuration.port
    property var fileDuration: configuration.fileDuration

    property var format : configuration.format
    property var num_src : configuration.num_src
    property var raw : configuration.raw
    property var src : configuration.src
    property var device_type : configuration.device_type
    property var uri : configuration.uri
    property var sinkType: configuration.sinkType
    property var outputFileName: configuration.outputFileName
    property var outputFilePath: configuration.outputFilePath
    property var outputDirName: configuration.outputDirName

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
                    outputLst.showList = false
                    inputRectangle.visible = false
                    outputRectangle.visible = false

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
                            outputLst.showList = false
                            inputRectangle.visible = false
                            outputRectangle.visible = false
                            fileList.visible = false
                            encoderDecoderPanel.visible = false
                            encoderCB.enabled = false
                            decoderCB.enabled = false

                            if(!root.play){
                                if(!root.isStreamUp && (root.sinkType == 0)){
                                    errorMessageText = "No ethernet connection"
                                    errorNameText = "Error"
                                }else{
                                    playBtn.enabled = false
                                    var opFile = outputFilePath + "/" + root.outputFileName + "_rec_" + Qt.formatDateTime(new Date(), "yyyyMMddHHmmss") + ".mp4"
                                    controller.updateInputParam(root.format, root.num_src, root.raw, root.src, root.device_type, "file://"+root.uri);
                                    controller.updateOutputParam(opFile, root.hostIP, root.fileDuration, root.sinkType, root.port);
                                    controller.updateEncParam((root.bitrate * ((root.bitrateUnit == "Mbps") ? 1000000 : 1000)), root.b_frame, root.enc_name, root.goP_len, root.profile, root.qpMode, root.rateControl, root.l2Cache, root.sliceCount);
                                    controller.start_pipeline();
                                    playBtn.enabled = true
                                }
                            }else{
                                playBtn.enabled = false
                                controller.stop_pipeline();
                                root.errorFound = false;
                                playBtn.enabled = true
                            }
                            encoderCB.enabled = (root.src == "uridecodebin") ? false : !root.play
                            decoderCB.enabled = (root.src == "uridecodebin") ? false : !root.play
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
                                height: parent.height
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
                                height: parent.height
                                verticalAlignment: Text.AlignVCenter
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
                                        outputRectangle.visible = false
                                        outputLst.showList = false
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
                                                break;
                                            case 1:
                                                root.src = "v4l2src"
                                                root.device_type = 2
                                                encoderCB.enabled = true
                                                decoderCB.enabled = true
                                                outputLbl.text = (encoderCB.checked && !decoderCB.checked) ? outputSinkList[outputSelect].shortName : outputSinkList[2].shortName
                                                break;
                                            case 2:
                                                root.src = "v4l2src"
                                                root.device_type = 1
                                                encoderCB.enabled = true
                                                decoderCB.enabled = true
                                                outputLbl.text = (encoderCB.checked && !decoderCB.checked) ? outputSinkList[outputSelect].shortName : outputSinkList[2].shortName
                                                break;
                                            default:
                                                root.src = "v4l2src"
                                                root.device_type = 1
                                                encoderCB.enabled = true
                                                decoderCB.enabled = true
                                                outputLbl.text = (encoderCB.checked && !decoderCB.checked) ? outputSinkList[outputSelect].shortName : outputSinkList[2].shortName
                                            }
                                            root.videoInput = indexval
                                        }
                                    }
                                }
                            }
                        }

                        Rectangle{
                            height: parent.height
                            width: 80
                            color: "transparent"
                            CheckBox{
                                id: encoderCB
                                text: "<b>Encode</b>"
                                anchors.verticalCenter: parent.verticalCenter
                                checked: true
                                enabled: (root.src == "uridecodebin") ? false : !root.play
                                onCheckedChanged: {
                                    inputRectangle.visible = false
                                    inputSrcLst.showList = false
                                    outputLst.showList = false
                                    outputRectangle.visible = false
                                    if(!encoderCB.checked){
                                        decoderCB.checked = false
                                    }
                                    if(encoderCB.checked == decoderCB.checked){
                                        outputLbl.text = outputSinkList[2].shortName
                                        root.sinkType = 2
                                    }else{
                                        outputLbl.text = outputSinkList[outputSelect].shortName
                                    }
                                    changeOutputSink()
                                }
                            }
                        }

                        Rectangle{
                            height: parent.height
                            width: 80
                            color: "transparent"
                            enabled: encoderCB.checked
                            CheckBox{
                                id: decoderCB
                                text: "<b>Decode</b>"
                                checked: true
                                anchors.verticalCenter: parent.verticalCenter
                                enabled: (root.src == "uridecodebin") ? false : !root.play
                                onCheckedChanged: {
                                    inputRectangle.visible = false
                                    inputSrcLst.showList = false
                                    outputLst.showList = false
                                    outputRectangle.visible = false
                                    if(encoderCB.checked == decoderCB.checked){
                                        outputLbl.text = outputSinkList[2].shortName
                                        root.sinkType = 2
                                    }else{
                                        outputLbl.text = outputSinkList[outputSelect].shortName
                                    }
                                    changeOutputSink()
                                }
                            }
                        }

                        Rectangle{
                            width: 250
                            height: parent.height
                            color: "transparent"
                            Label{
                                anchors.left: parent.left
                                width: 100
                                height: parent.height
                                verticalAlignment: Text.AlignVCenter
                                text: "<b>Output Sink: </b>"
                            }
                            Rectangle{
                                id: outputLst
                                anchors.right: parent.right
                                width: 150
                                height: parent.height
                                color: ((root.src == "uridecodebin") || (encoderCB.checked == decoderCB.checked) || root.play) ? "lightGray" : "gray"
                                enabled: (root.src == "uridecodebin") ? false : !root.play
                                property var showList: false
                                border.color: "black"
                                border.width: 1
                                radius: 2

                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        if(encoderCB.checked && !decoderCB.checked){
                                            fileList.visible = false
                                            encoderDecoderPanel.visible = false
                                            outputLst.showList = !outputLst.showList
                                            outputRectangle.visible = !outputRectangle.visible
                                            inputRectangle.visible = false
                                            inputSrcLst.showList = false
                                        }
                                    }
                                }
                                Label{
                                    id: outputLbl
                                    anchors.left: parent.left
                                    anchors.leftMargin: 10
                                    height: parent.height
                                    color: "white"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: outputSinkList[2].shortName
                                }
                                Image{
                                    anchors.right: parent.right
                                    anchors.rightMargin: 5
                                    width: parent.height
                                    height: parent.height
                                    source: outputLst.showList ? "qrc:///images/upArrow.png" : "qrc:///images/downArrow.png"
                                }

                                Rectangle{
                                    id: outputRectangle
                                    width: parent.width
                                    height: 40
                                    visible: false
                                    anchors.left: parent.left
                                    border.color: root.borderColors
                                    border.width: root.boarderWidths
                                    clip: true
                                    color: root.barColors
                                    anchors.top: parent.bottom

                                    OutputDropDown{
                                        id: outputList
                                        anchors.fill: parent
                                        listModel.model: outputSinkList
                                        selecteItem: root.presetSelect
                                        delgate: this
                                        width: parent.width
                                        function clicked(indexval){
                                            outputRectangle.visible = false
                                            outputLst.showList = false
                                            root.outputSelect = indexval
                                            outputLbl.text = outputSinkList[indexval].shortName
                                            changeOutputSink()
                                        }
                                    }
                                }
                            }
                        }

                        Button{
                            id: controlBtn
                            width: 70
                            height: parent.height
                            text: "Settings"
                            enabled: ((root.src == "uridecodebin") || root.raw) ? false : !root.play
                            style: ButtonStyle{
                                background: Rectangle {
                                    implicitWidth: 100
                                    implicitHeight: 25
                                    border.width: controlBtn.activeFocus ? 2 : 1
                                    border.color: "#888"
                                    radius: 4
                                    gradient: Gradient {
                                        GradientStop { position: 0 ; color: controlBtn.down ? "#ccc" : "#eee" }
                                        GradientStop { position: 1 ; color: controlBtn.down ? "#aaa" : "#ccc" }
                                    }
                                }
                            }
                            onClicked: {
                                fileList.visible = false
                                encoderDecoderPanel.visible = !encoderDecoderPanel.visible
                                inputSrcLst.showList = false
                                inputRectangle.visible = false
                                outputLst.showList = false
                                outputRectangle.visible = false
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
                            controller.uninitAll()
                            controller.freeMemory()
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
                                outputRectangle.visible = false
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
                            text: "<b>Encoder: </b>" + (((root.src == "uridecodebin") || root.raw) ? "NA" : ((1 === root.enc_enum) ? "AVC" : "HEVC"))
                        }
                        Rectangle{
                            width: 2
                            height: 20
                            color: "darkGray"
                        }
                        Label{
                            text:  ((root.src == "uridecodebin") || root.raw) ? "<b>Bitrate: </b>NA" :"<b>Bitrate: </b>" + ((root.bitrate.length === 0) ? "0": root.bitrate) + root.bitrateUnit
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

                        ValueAxis {
                            id: axisYcpu
                            min: 0
                            max: 100
                            labelFormat: "%d"
                            labelsFont.pointSize: 10
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
                            labelsFont.pointSize: 1
                        }

                        LineSeries {
                            name: "CPU Utilization(0.00%)"
                            axisX: axisXcpu
                            axisY: axisYcpu
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
                            max: 24
                            labelFormat: "%d"
                            labelsFont.pointSize: 10
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
                            labelsFont.pointSize: 1
                        }


                        LineSeries {
                            axisX: axisXEncBW
                            axisY: axisYEncBW
                            name: "Encoder Memory Bandwidth(0.00 Gbps)"

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
                            max: 24
                            labelFormat: "%d"
                            labelsFont.pointSize: 10
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
                            labelsFont.pointSize: 1
                        }

                        LineSeries {
                            axisX: axisXDecBW
                            axisY: axisYDecBW
                            name: "Decoder Memory Bandwidth (0.00 Gbps)"
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
                controller.getLocalIpAddress()
                controller.updatecpu(chart_line_CPU.series(0))
                controller.updateThroughput(encoderBandWidthPlot.series(0),decoderBandWidthPlot.series(0))
                if(root.play && !root.errorFound){
                    controller.updateFPS()
                    controller.pollError();
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
        root.bitrateUnit = presetStructure[index].bitrateUnit
        root.profile = presetStructure[index].profile
        root.qpMode = presetStructure[index].qpMode
        root.rateControl = presetStructure[index].rateControl
        root.l2Cache = presetStructure[index].l2Cache
        root.sliceCount = presetStructure[index].sliceCount
    }
    function changeOutputSink(){
        if(encoderCB.checked == decoderCB.checked){
            root.sinkType = 2
        }else{
            if(root.outputSelect == 0){
                root.sinkType = 1
            }else{
                root.sinkType = 0
            }
        }
    }
}
