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

Item {
    property bool play: false
    property bool errorFound: false

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
    property var presetSelect: 5
    property var outputSelect: 0
    property var plotDisplay: true

    property int bitrate: 100
    property var bitrateUnit: "Mbps"
    property var b_frame: 0
    property var enc_name: "omxh265enc"
    property var goP_len: 30
    property int enc_enum: 2
    property var profile: 1
    property var qpMode: 0
    property var rateControl: 1
    property var l2Cache: true
    property var sliceCount: 22
    property var ipAddress: "Not Connected"
    property var hostIP: "172.23.98.14"
    property var port: "50000"
    property var fileDuration: 1

    property var format : "NV12"
    property var num_src : 1
    property var raw : !(encoderCB.checked || decoderCB.checked)
    property var src : "v4l2src"
    property var device_type : 1
    property var uri : ""
    property var sinkType: 2
    property var outputFileName: "VCU-" + Qt.formatDateTime(new Date(), "yyyyMMddHHmm") + ".mp4"
}
