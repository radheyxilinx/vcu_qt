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
    id: settingsPanel
    anchors.fill: parent
    color: "transparent"
    MouseArea{
        anchors.fill: parent
    }
    property bool validation: true
    property var tmpBitrate: root.bitrate
    property var tmpB_frame: root.b_frame
    property var tmpEnc_name: root.enc_name
    property var tmpGoP_len: root.goP_len
    property var tmpEnc_enum: root.enc_enum
    property var tmpPresetSel: 5
    property var tmpProfile: root.profile
    property var tmpQPMode:root.qpMode
    property var tmpRateControl: root.rateControl
    property var tmpL2Cache: root.l2Cache
    property var tmpsliceCount: root.sliceCount
    property var tmpHostIP: root.hostIP
    property var tmpSinkType: root.sinkType
    property var tmpFileDuration: root.fileDuration
    property var tmpOpFilePath: root.outputFilePath
    property var tmpPort: root.port
    property var tmpBitrateUnit: root.bitrateUnit

    property var selectTabAtIndex: [
        {   "tab1ULvisible" : false,
            "tab2ULvisible" : true,
            "tab3ULvisible" : true,
            "tab1color" : "transparent",
            "tab2color" : "lightgray",
            "tab3color" : "lightgray",
            "encParamTabVvisible" : true,
            "fileTabVvisible" : false,
            "streamOutTabVvisible" : false,
            "keyPadvisible" : false
        },

        {   "tab1ULvisible" : true,
            "tab2ULvisible" : false,
            "tab3ULvisible" : true,
            "tab1color" : "lightgray",
            "tab2color" : "transparent",
            "tab3color" : "lightgray",
            "fileTabVvisible" : true,
            "encParamTabVvisible" : false,
            "streamOutTabVvisible" : false,
            "keyPadvisible" : false
        },
        {   "tab1ULvisible" : true,
            "tab2ULvisible" : true,
            "tab3ULvisible" : false,
            "tab1color" : "lightgray",
            "tab2color" : "lightgray",
            "tab3color" : "transparent",
            "streamOutTabVvisible" : true,
            "fileTabVvisible" : false,
            "encParamTabVvisible" : false,
            "keyPadvisible" : false
        }
    ]

    Rectangle {
        anchors{
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
        onVisibleChanged: {
            if(encoderDecoderPanel.visible){
                validation = true

                switch(root.sinkType){
                case 0:
                    tabSelect(selectTabAtIndex[2])
                    tab1.enabled = true
                    tab2.enabled = false
                    tab3.enabled = true
                    break
                case 1:
                    tabSelect(selectTabAtIndex[1])
                    tab1.enabled = true
                    tab2.enabled = true
                    tab3.enabled = false
                    break
                case 2:
                    tabSelect(selectTabAtIndex[0])
                    tab1.enabled = true
                    tab2.enabled = false
                    tab3.enabled = false
                    break
                }
            }
        }

        width: 500
        height: 460
        color: "#ffffff"
        border.color: "gray"
        border.width: 2
        radius: 5

        MouseArea{
            anchors.fill: parent
            onClicked: {

            }
        }
        Label{
            anchors{
                left: parent.left
                leftMargin: 10
                topMargin: 10
                top: parent.top
            }
            text: "Settings"
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

        Row{
            id: tabRow
            anchors{
                left: parent.left
                leftMargin: 2
                right: parent.right
                rightMargin: 2
                top: header.bottom
                topMargin: 2
            }
            width: parent.width-5
            height: 25
            Rectangle{
                id: tab1
                height: parent.height
                width: parent.width/3
                color: "transparent"
                border.color: "black"
                border.width: 1
                Label{
                    anchors.fill: parent
                    text: "Encoder Parameter"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                Rectangle{
                    id: tab1UL
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 1
                    height: 1
                    width: parent.width
                    color: "black"
                    visible: false
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(validation == true){
                            tabSelect(selectTabAtIndex[0])
                        }
                    }
                }
            }
            Rectangle{
                id: tab2
                height: parent.height
                width: parent.width/3
                color: "lightgray"
                border.color: "black"
                border.width: 1
                Label{
                    anchors.fill: parent
                    text: "Record"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                Rectangle{
                    id: tab2UL
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 1
                    height: 1
                    width: parent.width
                    color: "black"
                    visible: true
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(validation == true){
                            tabSelect(selectTabAtIndex[1])
                        }
                    }
                }
            }
            Rectangle{
                id: tab3
                height: parent.height
                width: parent.width/3
                color: "lightgray"
                border.color: "black"
                border.width: 1

                Label{
                    anchors.fill: parent
                    text: "Stream Out"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                Rectangle{
                    id: tab3UL
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 1
                    height: 1
                    width: parent.width
                    color: "black"
                    visible: true
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(validation == true){
                            tabSelect(selectTabAtIndex[2])
                        }
                    }
                }
            }
        }

        EncParamTab{
            id: encParamTabV
            visible: true
            anchors{
                left: parent.left
                leftMargin: 3
                top: tabRow.bottom
                topMargin: -1
            }
        }
        FileTab{
            id: fileTabV
            visible: false
            anchors{
                left: parent.left
                leftMargin: 3
                top: tabRow.bottom
                topMargin: -1
            }
        }
        StreamOutTab{
            id: streamOutTabV
            visible: false
            anchors{
                left: parent.left
                leftMargin: 3
                top: tabRow.bottom
                topMargin: -1
            }
        }

        NumberKeyPad{
            id: keyPad
            anchors.left: parent.left
            anchors.leftMargin: 160
            anchors.top: parent.top
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
            enabled: validation
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    keyPad.visible = false
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
                keyPad.visible = false
                encoderDecoderPanel.visible = false

                root.b_frame = tmpB_frame
                root.goP_len = tmpGoP_len
                root.enc_name = tmpEnc_name
                root.bitrate = tmpBitrate
                root.enc_enum = tmpEnc_enum
                root.profile = tmpProfile
                root.qpMode = tmpQPMode
                root.rateControl = tmpRateControl
                root.l2Cache = tmpL2Cache
                root.sliceCount = tmpsliceCount
                root.hostIP = tmpHostIP
                root.sinkType = tmpSinkType
                root.fileDuration = tmpFileDuration
                root.port = tmpPort
                root.outputFilePath = tmpOpFilePath
                root.bitrateUnit = tmpBitrateUnit

                root.presetSelect = tmpPresetSel
                root.setPresets(root.presetSelect)
                presetLbl.text = controlList[root.presetSelect].shortName
                presetList.resetSource(root.presetSelect)
            }
        }
        Label{
            id: errorLbl
            anchors{
                left: parent.left
                leftMargin: 10
                right: cancelButton.left
                rightMargin: 20
                bottom: parent.bottom
                bottomMargin: 10
            }
            height: 30
            text: ""
            color: "red"
            visible: !validation
        }
    }
    function tabSelect(selectedTab){
        tab1UL.visible = selectedTab.tab1ULvisible
        tab2UL.visible = selectedTab.tab2ULvisible
        tab3UL.visible = selectedTab.tab3ULvisible
        tab1.color = selectedTab.tab1color
        tab2.color = selectedTab.tab2color
        tab3.color = selectedTab.tab3color
        encParamTabV.visible = selectedTab.encParamTabVvisible
        fileTabV.visible = selectedTab.fileTabVvisible
        streamOutTabV.visible = selectedTab.streamOutTabVvisible
        keyPad.visible = selectedTab.keyPadvisible
    }
    function createTemp(){
        tmpBitrate = root.bitrate
        tmpB_frame = root.b_frame
        tmpEnc_name = root.enc_name
        tmpGoP_len = root.goP_len
        tmpEnc_enum = root.enc_enum
        tmpProfile = root.profile
        tmpQPMode = root.qpMode
        tmpRateControl = root.rateControl
        tmpL2Cache = root.l2Cache
        tmpsliceCount = root.sliceCount
        tmpHostIP = root.hostIP
        tmpSinkType = root.sinkType
        tmpFileDuration = root.fileDuration
        tmpOpFilePath = root.outputFilePath
        tmpPort = root.port
        tmpBitrateUnit = root.bitrateUnit
    }
}
