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

Rectangle{
    id: encParamTempRec
    width: parent.width-6
    height: parent.height-110
    color: "transparent"

    onVisibleChanged: {
        if(visible){
            bitRateCount.value = root.bitrate
            framesCount.value = root.b_frame
            sliceCount.value = root.sliceCount
            gopLengthCount.value = root.goP_len
            if(1 == root.enc_enum){
                h264Radio.checked = true
            }else{
                h265Radio.checked = true
            }

            switch (root.profile) {
            case 0:
                profileBaseline.checked = true
                break;
            case 1:
                profileMain.checked = true
                break
            case 2:
                profileHigh.checked = true
                break
            default:
                profileMain.checked = true
                break
            }
            if(0 == root.qpMode){
                qpModeUniform.checked = true
            }else{
                qpModeAuto.checked = true
            }
            switch (root.rateControl){
            case 1:
                 vbrRadio.checked = true
                break;
            case 2:
                cbrRadio.checked = true
                break;
            default:
                vbrRadio.checked = true
                break;
            }
            if(0 == root.l2Cache){
                disableL2Cache.checked = true
            }else{
                enableL2Cache.checked = true
            }
        }
    }

    Column{
        anchors.top: parent.top
        anchors.topMargin: 10
        spacing: 10
        width: parent.width
        Rectangle{
            width: parent.width
            height: 25
            color: "transparent"
            Label{
                id: presetL
                anchors{
                    left: parent.left
                    leftMargin: 10
                    top: parent.top
                }
                width: 140
                height: 25
                verticalAlignment: Text.AlignVCenter
                text: "Preset:"
            }
            Rectangle{
                id: controlLst
                anchors.left: presetL.right
                anchors.leftMargin: 5
                width: 150
                height: parent.height
                color: ((root.src == "uridecodebin") || root.play) ? "lightGray" : "lightGray"
                enabled: (root.src == "uridecodebin") ? false : !root.play
                property var showList: false
                border.color: "black"
                border.width: 1
                radius: 2
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        fileList.visible = false
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
                    text: (root.src == "uridecodebin")? "None" : presetLbl.text = controlList[root.presetSelect].shortName
                }
                Image{
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    width: parent.height
                    height: parent.height
                    source: controlLst.showList ? "qrc:///images/upArrow.png" : "qrc:///images/downArrow.png"
                }

                           }

        }

        Rectangle{
            width: parent.width
            height: 25
            color: "transparent"

            Label {
                id: encoderLbl
                anchors{
                    left: parent.left
                    leftMargin: 10
                    top: parent.top
                }
                width: 140
                height: 25
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Encoder Type: ")
            }

            Row{
                anchors{
                    left: encoderLbl.right
                    leftMargin: 5
                    top: parent.top
                }
                height: 25
                spacing: 20
                ExclusiveGroup{
                    id: encTypeGroup
                }

                RadioButton{
                    id: h264Radio
                    text: "H264"
                    exclusiveGroup: encTypeGroup
                    width: 80
                    onCheckedChanged: {
                        sliceCount.value = 0
                        if(checked){
                            root.enc_enum = 1
                            root.enc_name =  "omxh264enc"
                            profileBaseline.checked = true
                            root.profile = 0
                        }
                    }
                }
                RadioButton{
                    id: h265Radio
                    width: 80
                    text: "H265"
                    checked: true
                    exclusiveGroup: encTypeGroup
                    onCheckedChanged: {
                        sliceCount.value = 0
                        if(checked){
                            root.enc_enum= 2
                            root.enc_name =  "omxh265enc"
                            profileMain.checked = true
                            root.profile = 1
                        }
                    }
                }
            }
        }

        Rectangle{
            width: parent.width
            height: 25
            color: "transparent"

            Label{
                id: profileLbl
                anchors{
                    left:  parent.left
                    leftMargin: 10
                    top: parent.top
                }
                width: 140
                height: 25
                verticalAlignment: Text.AlignVCenter
                text: "Profile: "
            }
            Row{
                anchors{
                    left:  profileLbl.right
                    leftMargin: 5
                    top: parent.top
                }
                height: 25
                spacing: 20
                ExclusiveGroup{
                    id: profileGroup
                }
                RadioButton{
                    id: profileBaseline
                    width: 80
                    text: "Baseline"
                    exclusiveGroup: profileGroup
                    visible: !h265Radio.checked
                    onCheckedChanged: {
                        if(checked){
                            root.profile = 0
                        }
                    }
                }
                RadioButton{
                    id: profileMain
                    width: 80
                    text: "Main"
                    checked: true
                    exclusiveGroup: profileGroup
                    onCheckedChanged: {
                        if(checked){
                            root.profile = 1
                        }
                    }
                }
                RadioButton{
                    id: profileHigh
                    width: 80
                    text: "High"
                    exclusiveGroup: profileGroup
                    visible: !h265Radio.checked
                    onCheckedChanged: {
                        if(checked){
                            root.profile = 2
                        }
                    }
                }
            }
        }

        Rectangle{
            width: parent.width
            height: 25
            color: "transparent"
            Label{
                id: qpModeLbl
                anchors{
                    left:  parent.left
                    leftMargin: 10
                    top: parent.top
                }
                width: 140
                height: 25
                verticalAlignment: Text.AlignVCenter
                text: "QPMode: "
            }


            Row{
                anchors{
                    left:  qpModeLbl.right
                    leftMargin: 5
                    top: parent.top
                }
                height: 25
                spacing: 20
                ExclusiveGroup{
                    id: qpModeGroup
                }
                RadioButton{
                    id: qpModeUniform
                    width: 80
                    text: "Uniform"
                    exclusiveGroup: qpModeGroup
                    checked: true
                    onCheckedChanged: {
                        if(checked){
                            root.qpMode = 0
                        }
                    }
                }
                RadioButton{
                    id: qpModeAuto
                    width: 80
                    text: "Auto"
                    exclusiveGroup: qpModeGroup
                    onCheckedChanged: {
                        if(checked){
                            root.qpMode = 1
                        }
                    }
                }
            }
        }

        Rectangle{
            width: parent.width
            height: 25
            color: "transparent"
            Label{
                id: ratecontrolLbl
                anchors{
                    left:  parent.left
                    leftMargin: 10
                    top: parent.top
                }
                width: 140
                height: 25
                verticalAlignment: Text.AlignVCenter
                text: "Rate control mode:"
            }
            Row{
                anchors{
                    left:  ratecontrolLbl.right
                    leftMargin: 5
                    top: parent.top
                }
                height: 25
                spacing: 20
                ExclusiveGroup{
                    id: ratecontrolGroup
                }
                RadioButton{
                    id: cbrRadio
                    width: 80
                    text: "CBR"
                    exclusiveGroup: ratecontrolGroup
                    checked: true
                    onCheckedChanged: {
                        if(checked){
                            root.rateControl = 2
                        }
                    }
                }
                RadioButton{
                    id: vbrRadio
                    width: 80
                    text: "VBR"
                    exclusiveGroup: ratecontrolGroup
                    onCheckedChanged: {
                        if(checked){
                            root.rateControl = 1
                        }
                    }
                }
            }
        }

        Rectangle{
            width: parent.width
            height: 25
            color: "transparent"

            Label {
                id: l2cacheLbl
                anchors{
                    left: parent.left
                    leftMargin: 10
                    top: parent.top
                }
                width: 140
                height: 25
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Use L2 cache: ")
            }

            Row{
                anchors{
                    left: l2cacheLbl.right
                    leftMargin: 5
                    top: parent.top
                }
                height: 25
                spacing: 20
                ExclusiveGroup{
                    id: l2cacheGroup
                }

                RadioButton{
                    id: enableL2Cache
                    text: "Enable"
                    exclusiveGroup: l2cacheGroup
                    checked: true
                    width: 80
                    onCheckedChanged: {
                        if(checked){
                            root.l2Cache = 1
                        }
                    }
                }
                RadioButton{
                    id: disableL2Cache
                    text: "Disable"
                    exclusiveGroup: l2cacheGroup
                    width: 80
                    onCheckedChanged: {
                        if(checked){
                            root.l2Cache = 0
                        }
                    }
                }
            }
        }

        Rectangle{
            width: parent.width
            height: 25
            color: "transparent"
            Label{
                id: bitRateLbl
                anchors{
                    left:  parent.left
                    leftMargin: 10
                    top: parent.top
                }
                width: 140
                height: 25
                verticalAlignment: Text.AlignVCenter
                text: "Bitrate: "
            }
            Rectangle{
                id: bitRateLblContainer
                anchors{
                    left: bitRateCount.right
                    leftMargin: 10
                    top: parent.top
                }
                width: 50
                height: 25
                Label{
                    id:  bitRateCountLbl
                    anchors.fill: parent
                    enabled: !root.raw
                    text: qsTr(bitRateCount.value.toString())
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    onTextChanged: {
                        if(root.bitrate!= bitRateCount.value){
                            root.bitrate = bitRateCount.value
                            root.presetSelect = 6
                            root.setPresets(root.presetSelect)
                            presetLbl.text = controlList[root.presetSelect].shortName
                            presetList.resetSource(root.presetSelect)
                        }
                    }
                }
            }

            Slider {
                id: bitRateCount
                anchors{
                    left: bitRateLbl.right
                    leftMargin: 5
                    top: parent.top
                }
                enabled: !root.raw
                minimumValue: 1
                maximumValue: 1000
                stepSize: 1.0
                value : root.bitrate
                style: SliderStyle {
                    groove: Rectangle {
                        implicitWidth: 150
                        implicitHeight: 5
                        color: "gray"
                        radius: 5
                    }
                }
            }
            Row{
                anchors{
                    left: bitRateLblContainer.right
                    leftMargin: 2
                    top: parent.top
                }
                height: 25
                spacing: 5
                ExclusiveGroup{
                    id: bitrateUnitGroup
                }

                RadioButton{
                    id: mbps
                    text: "Mbps"
                    exclusiveGroup: bitrateUnitGroup
                    checked: true
                    onCheckedChanged: {
                        if(checked){
                            root.bitrateUnit = "Mbps"
                        }
                    }
                }
                RadioButton{
                    id: kbps
                    text: "Kbps"
                    exclusiveGroup: bitrateUnitGroup
                    onCheckedChanged: {
                        if(checked){
                            root.bitrateUnit = "Kbps"
                        }
                    }
                }
            }

        }

        Rectangle{
            color: "transparent"
            width: parent.width
            height: 25
            Label {
                id: bFrame
                anchors{
                    left: parent.left
                    leftMargin: 10
                    top: parent.top
                }
                height: 25
                width: 140
                text: qsTr("B-frame: ")
            }
            Rectangle{
                id: framesCountLblContainer
                anchors{
                    left: framesCount.right
                    leftMargin: 10
                    top: parent.top
                }
                width: 50
                height: 25
                Label{
                    id: framesCountLbl
                    anchors.fill: parent
                    enabled: !root.raw
                    text: qsTr(framesCount.value.toString())
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    onTextChanged: {
                        if(root.b_frame != framesCount.value){
                            root.b_frame = framesCount.value
                            root.presetSelect = 6
                            root.setPresets(root.presetSelect)
                            presetLbl.text = controlList[root.presetSelect].shortName
                            presetList.resetSource(root.presetSelect)
                        }
                    }
                }
            }

            Slider {
                id: framesCount
                anchors{
                    left: bFrame.right
                    leftMargin: 5
                    top: parent.top
                }
                enabled: !root.raw
                maximumValue: 4.0
                stepSize: 1.0
                value : 0
                style: SliderStyle {
                    groove: Rectangle {
                        implicitWidth: 150
                        implicitHeight: 5
                        color: "gray"
                        radius: 5
                    }
                }
            }
        }

        Rectangle{
            color: "transparent"
            width: parent.width
            height: 25
            Label {
                id: sliceLbl
                anchors{
                    left: parent.left
                    leftMargin: 10
                    top: parent.top
                }
                height: 25
                width: 140
                text: qsTr("Slice: ")
            }
            Rectangle{
                anchors{
                    left: sliceCount.right
                    leftMargin: 10
                    top: parent.top
                }
                width: 50
                height: 25
                Label{
                    anchors.fill: parent
                    enabled: !root.raw
                    text: qsTr(sliceCount.value.toString())
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    onTextChanged: {
                        if(root.sliceCount != sliceCount.value){
                            root.sliceCount = sliceCount.value
                            root.presetSelect = 6
                            root.setPresets(root.presetSelect)
                            presetLbl.text = controlList[root.presetSelect].shortName
                            presetList.resetSource(root.presetSelect)
                        }
                    }
                }
            }
            Slider {
                id: sliceCount
                anchors{
                    left: sliceLbl.right
                    leftMargin: 5
                    top: parent.top
                }
                enabled: !root.raw
                minimumValue: 1
                maximumValue: h264Radio.checked ? 135 : 22
                stepSize: 1.0
                value : 1
                style: SliderStyle {
                    groove: Rectangle {
                        implicitWidth: 150
                        implicitHeight: 5
                        color: "gray"
                        radius: 5
                    }
                }
            }
        }

        Rectangle{
            color: "transparent"
            width: parent.width
            height: 25

            Label {
                id: gopLenLbl
                width: 140
                height: 25
                anchors{
                    left:  parent.left
                    leftMargin: 10
                    top: parent.top
                }
                text: qsTr("GoP Length: ")
                verticalAlignment: Text.AlignVCenter
            }
            Rectangle{
                width: 50
                height: 25
                id: goPLenTxtRect
                anchors{
                    left:  gopLengthCount.right
                    leftMargin: 10
                    top: gopLenLbl.top
                }
                enabled: !root.raw
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
                    horizontalAlignment: Text.AlignHCenter
                    onTextChanged: {
                        if(root.goP_len != gopLengthCount.value){
                            root.goP_len = gopLengthCount.value
                            root.presetSelect = 6
                            root.setPresets(root.presetSelect)
                            presetLbl.text = controlList[root.presetSelect].shortName
                            presetList.resetSource(root.presetSelect)
                        }
                    }
                }
            }
            Slider {
                id: gopLengthCount
                anchors{
                    left: gopLenLbl.right
                    leftMargin: 5
                    top: parent.top
                }
                enabled: !root.raw
                maximumValue: 100
                minimumValue: 1
                stepSize: 1.0
                value : 30
                style: SliderStyle {
                    groove: Rectangle {
                        implicitWidth: 150
                        implicitHeight: 5
                        color: "gray"
                        radius: 5
                    }
                }
            }
        }

    }

    Rectangle{
        id: controlRectangle
        anchors{
            left: parent.left
            leftMargin: 155
            top: parent.top
            topMargin: 35
        }
        width: 150
        height: 140
        visible: false
        border.color: root.borderColors
        border.width: root.boarderWidths
        clip: true
        color: root.barColors

        ControlVu{
            id: presetList
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
                presetLbl.text = controlList[indexval].shortName
                presetList.resetSource(root.presetSelect)
                if(indexval == 6){
                    root.raw = false
                    encoderDecoderPanel.visible = true
                    passtroughCB.checked = false
                }else{
                    root.raw = false
                    encoderDecoderPanel.tmpPresetSel = indexval
                }
            }
        }
    }
}
