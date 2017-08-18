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
import QtQuick 2.0
Rectangle{
    width: parent.width-6
    height: parent.height-110
    color: "transparent"
    MouseArea{
        anchors.fill: parent
        onClicked: numberPad.visible = false
    }
    onVisibleChanged: {
        if(visible){
            hostIpTxt.text = root.hostIP
            portTxt.text = root.port
        }else{
            numberPad.visible = false
        }
    }

    Column{
        anchors.top: parent.top
        anchors.topMargin: 10
        spacing: 10
        height: 300
        width: parent.width
        Rectangle{
            width: parent.width
            height: 25
            color: "transparent"

            Label{
                id: sinkLbl
                anchors{
                    left:  parent.left
                    leftMargin: 10
                    top: parent.top
                }
                width: 110
                height: 25
                verticalAlignment: Text.AlignVCenter
                text: "SINK: "
            }
            TextField{
                id: sinkTxt
                anchors{
                    left: sinkLbl.right
                    leftMargin: 5
                    top: parent.top
                }
                width: 125
                height: 25
                text: "PS Ethernet"
                enabled: !root.raw
                MouseArea{
                    anchors.fill: parent
                    onClicked: {

                    }
                }
            }

            Button {
                anchors{
                    left: sinkTxt.right
                    leftMargin: -2
                    top: parent.top
                }
                width: sinkTxt.height
                height: sinkTxt.height
                Image{
                    anchors.fill: parent
                    source: "qrc:///images/downArrow.png"
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {

                    }
                }
            }
        }

        Rectangle{
            width: parent.width
            height: 25
            color: "transparent"

            Label{
                id: hostIpLbl
                anchors{
                    left:  parent.left
                    leftMargin: 10
                    top: parent.top
                }
                width: 110
                height: 25
                verticalAlignment: Text.AlignVCenter
                text: "Host IP: "
            }
            TextField{
                id: hostIpTxt
                anchors{
                    left:  hostIpLbl.right
                    leftMargin: 5
                    top: parent.top
                }
                width: 150
                height: 25
                text: root.hostIP
                verticalAlignment: Text.AlignVCenter
                enabled: !root.raw
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        numberPad.state = "hostIpEdit"
                        numberPad.visible =  !numberPad.visible
                    }
                }
            }
        }

        Rectangle{
            width: parent.width
            height: 25
            color: "transparent"

            Label{
                id: ipLbl
                anchors{
                    left:  parent.left
                    leftMargin: 10
                    top: parent.top
                }
                width: 110
                height: 25
                verticalAlignment: Text.AlignVCenter
                text: "IP: "
            }
            Label{
                id: ipTxt
                anchors{
                    left:  ipLbl.right
                    leftMargin: 5
                    top: parent.top
                }
                width: 150
                height: 25
                text: root.ipAddress
                verticalAlignment: Text.AlignVCenter
                enabled: !root.raw
                MouseArea{
                    anchors.fill: parent
                    onClicked: {

                    }
                }
            }
        }

        Rectangle{
            width: parent.width
            height: 25
            color: "transparent"

            Label{
                id: portLbl
                anchors{
                    left:  parent.left
                    leftMargin: 10
                    top: parent.top
                }
                width: 110
                height: 25
                verticalAlignment: Text.AlignVCenter
                text: "Port: "
            }
            TextField{
                id: portTxt
                anchors{
                    left:  portLbl.right
                    leftMargin: 5
                    top: parent.top
                }
                width: 150
                height: 25
                text: root.port
                verticalAlignment: Text.AlignVCenter
                enabled: !root.raw
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        numberPad.state = "portEdit"
                        numberPad.visible =  !numberPad.visible
                    }
                }
            }
        }
    }

    Rectangle{
        id: numberPad
        visible: false
        anchors.left: parent.left
        anchors.leftMargin: 130
        anchors.top: parent.top
        anchors.topMargin: 75
        height: 145
        width: 110
        color: "lightGray"
        MouseArea{
            anchors.fill: parent
        }

        states: [
            State {
                name: "hostIpEdit"
                PropertyChanges {
                    target: numberPad
                    anchors.topMargin: 75
                }
            },

            State {
                name: "portEdit"
                PropertyChanges {
                    target: numberPad
                    anchors.topMargin: 140
                }
            }
        ]

        Grid {
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.top: parent.top
            anchors.topMargin: 5
            columns: 3
            columnSpacing: 5
            rowSpacing: 5

            Repeater{
                model: ["1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "0", "<"]
                Button {
                    text: modelData
                    width: 30
                    height: 30
                    onClicked: {
                        if("<" != modelData){
                            if(numberPad.state == "hostIpEdit"){
                                hostIpTxt.text = hostIpTxt.text + modelData
                            }else{
                                portTxt.text = portTxt.text + modelData
                            }
                        }else{
                            if(numberPad.state == "hostIpEdit"){
                                hostIpTxt.text = hostIpTxt.text.substring(0, hostIpTxt.text.length-1)
                            }else{
                                portTxt.text = portTxt.text.substring(0, portTxt.text.length - 1)
                            }
                        }
                        root.hostIP = hostIpTxt.text
                        root.port = portTxt.text
                    }
                }
            }
        }
    }
}
