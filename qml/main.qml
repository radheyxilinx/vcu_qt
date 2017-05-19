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

    property var errorMessageText: ""
    property var errorNameText: ""
    property var barColors: "#1FF7F7F0"
    property var barTitleColorsPut: "#F0AAAAAA"
    property var cellColor: "#FFEEEEEE"
    property var cellHighlightColor: "#FFAAAAAA"
    property var borderColors: "#F0AAAAAA"
    property int boarderWidths: 1

    property var videoResolution: "4k"
    property var fpsValue: "30"

    property var videoInput: 0
    property var presetSelect: 0
    property var plotDisplay: true

    property int bitrate: 10000000
    property var b_frame: 2
    property var enc_name: "omxh264enc"
    property var goP_len: 30

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
                }
                onDoubleClicked: {
                    inputRectangle.visible = false
                    controlRectangle.visible = false
                    graphPlot.visible = !graphPlot.visible
                    titleBar.y = graphPlot.visible ? 0 : -100
                    encoderDecoderPanel.visible = false
                }
                onPositionChanged: {
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
                Image{
                    id: logoImg
                    anchors{
                        left: parent.left
                        leftMargin: 0
                        top: parent.top
                        topMargin: 0
                    }
                    fillMode: Image.PreserveAspectCrop
                    width: 160
                    height: 55
                    source: "qrc:///images/xilinxLogo.png"
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
                    text: "Zynq UltraScale+MPSoC Video Codec Unit Targeted Reference Design"
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
                            root.play = !root.play;

                            if(root.play){
                                controller.updateInputParam(root.format, root.num_src, root.raw, root.src, root.device_type, "file://"+root.uri);
                                controller.updateEncParam(root.bitrate, root.b_frame, root.enc_name, root.goP_len);
                                controller.start_pipeline();
                            }else{
                                root.raw = true
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
                            width: 170
                            height: parent.height
                            Label{
                                id: ipSrcLbl
                                text: "No. of input source:"
                                height: parent.height
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                anchors{
                                    left: parent.left
                                    leftMargin: 0
                                }
                                width: 150
                            }
                            TextField{
                                text: "1"
                                anchors{
                                    left: ipSrcLbl.right
                                    leftMargin: 5
                                }
                                width: 20
                                height: parent.height
                                enabled: false
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }

                        Rectangle{
                            id: inputSrcLst
                            width: 150
                            height: parent.height
                            color: "gray"
                            property var showList: false
                            property var browseSrc: false

                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    inputRectangle.visible = !inputRectangle.visible
                                    parent.showList = !parent.showList
                                    encoderDecoderPanel.visible = false
                                    controlRectangle.visible = false
                                    controlLst.showList = false
                                }
                            }
                            Label{
                                anchors.left: parent.left
                                anchors.leftMargin: 20
                                height: parent.height
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                text: "Input Source"
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
                                        switch (indexval){
                                        case 0:
                                            fileList.visible = true
                                            break;
                                        case 1:
                                            root.src = "v4l2src"
                                            root.device_type = 0
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

                        Rectangle{
                            id: controlLst
                            width: 150
                            height: parent.height
                            color: "gray"
                            property var showList: false
                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    encoderDecoderPanel.visible = false
                                    parent.showList = !parent.showList
                                    controlRectangle.visible = !controlRectangle.visible
                                    inputRectangle.visible = false
                                    inputSrcLst.showList = false
                                }
                            }
                            Label{
                                anchors.left: parent.left
                                anchors.leftMargin: 20
                                height: parent.height
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                text: "Preset"
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
                                height: 120
                                visible: false
                                anchors.left: parent.left
                                border.color: root.borderColors
                                border.width: root.boarderWidths
                                clip: true
                                color: root.barColors
                                anchors.top: parent.bottom

                                ControlVu{
                                    anchors.fill: parent
                                    listModel.model: controlList
                                    selecteItem: root.presetSelect
                                    delgate: this
                                    width: parent.width
                                    function clicked(indexval){
                                        controlRectangle.visible = false
                                        controlLst.showList = false
                                        root.presetSelect = indexval
                                        root.setPresets(indexval)
                                    }
                                }
                            }
                        }

                        Button{
                            id: controlBtn
                            width: 70
                            height: parent.height
                            text: "Control"
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
                                encoderDecoderPanel.visible = !encoderDecoderPanel.visible
                                inputSrcLst.showList = false
                                inputRectangle.visible = false
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
                            titleBar.y = -100
                            inputRectangle.visible = false
                            controlRectangle.visible = false
                            graphPlot.visible = false
                            encoderDecoderPanel.visible = false
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
                            text: "Resolution: " + root.videoResolution
                        }
                        Label{
                            text: "Format: " + root.format
                        }
                        Label{
                            text: "FPS: " + root.fpsValue
                        }
                        Label{
                            text: "Bitrate: " + root.bitrate/1000000 + "Mbps"
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
                controller.updateThroughput(encoderBandWidthPlot.series(0),decoderBandWidthPlot.series(0))
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
        root.b_frame =  presetStructures[index].b_frame
        root.enc_name = presetStructure[index].enc_name
        root.goP_len = presetStructure[index].goP_len
        root.src = presetStructure[index].src
        root.device_type = presetStructure[index].device_type
        root.bitrate = presetStructure[index].bitrate
    }
}
